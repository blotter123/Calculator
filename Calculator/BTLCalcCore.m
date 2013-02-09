//
//  BTLCalcCore.m
//  Calculator
//
//  Created by Benedikt Lotter on 2/7/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLCalcCore.h"

@interface BTLCalcCore  ()

@property (nonatomic, strong)   NSMutableArray  *programStack;

+ (NSSet *)   calculatorOperations:(int)numberOfOperands;
+ (BOOL)    stringIsOperation: (NSString*)inputString;
+ (int)     noOfOperands: (NSString *)inputString;
+ (int) encodeString:(NSString *) inputString;




@end

@implementation BTLCalcCore


- (NSMutableArray *) programStack{
    if (!_programStack){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

+ (NSSet *)calculatorOperations
{
    NSSet *mySetOfOperations;
    
        mySetOfOperations = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
    
    return mySetOfOperations;
}

+ (int)encodeString: (NSString *)inputString
{
    // return values: 
    //                -1 = is Number
    //                 1 = is Operation with 2 operands
    
    
    int result = -1;
    
    if (inputString) {
        if ([inputString isKindOfClass:[NSNumber class]]) {
            result = - 1;
        } else if ([[self calculatorOperations] member:inputString]) {
            result = 1;
        } 
    }
    
    return result;
}

+ (BOOL)stringIsOperation:(NSString *)inputString
{
    BOOL result = FALSE;
    
    if (inputString) {
        result = ([self encodeString:inputString] == 1);
    }
    
    return result;
}


- (void)pushOperand: (double) operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)removeTopItemFromProgram
{
    id anObject = [self.programStack lastObject];
    if (anObject) {
        [self.programStack removeLastObject];
    }
}

- (id)doOperation: (NSString *) operation
{
    [self.programStack addObject:operation];
    return [BTLCalcCore runProgram:self.program];
}



- (id)program
{
    return [self.programStack copy];
}

+ (id)popOperandOffStack:(NSMutableArray *)stack
//
//returns an object tpyeof NSNumber or NSString, never NIL
//type is NSNumber -> method result is a correct math operation
//type is NSString -> method result is an error string
//
{
    id resultObject;
    id operand1, operand2;
    NSNumber *resultNumberObject;
    NSString *resultStringObject = @"Error";
    int evalResult;
    int popErrorNr = 0;
    
    double result = 0;
    resultNumberObject = [NSNumber numberWithDouble:result];
    
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    } else {
        popErrorNr = 1;
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        evalResult = [self encodeString:operation];
        
        if (evalResult == 1) {
            operand1 = [self popOperandOffStack:stack];
            
            if ([operand1 isKindOfClass:[NSNumber class]]) //validate operand1
            {
                operand2 = [self popOperandOffStack:stack];
                
                if ([operand2 isKindOfClass:[NSNumber class]]) //validate operand2
                {
                    //perform operations with two operands
                    
                    if ([operation isEqualToString:@"+"]) {
                        result = [operand1 doubleValue] + [operand2 doubleValue];
                    } else if ([@"*" isEqualToString:operation]) {
                        result = [operand1 doubleValue] * [operand2 doubleValue];
                    } else if ([@"-" isEqualToString:operation]) {
                        result = [operand2 doubleValue] - [operand1 doubleValue];
                    } else if ([@"/" isEqualToString:operation]) {
                        if ([operand1 doubleValue] != 0) {
                            result = [operand2 doubleValue] / [operand1 doubleValue];
                        } else {
                            popErrorNr = 2;
                        }
                    } else {
                        popErrorNr = -1;
                        if ([operand1 isKindOfClass:[NSString class]]) {
                            resultStringObject = operand1;
                        }
                    }
                }
                else { //getting operand2 resulted in error
                    popErrorNr = -1;
                    if ([operand2 isKindOfClass:[NSString class]]) {
                        resultStringObject = operand2;
                    }
                }
            }
            else { //getting operand1 resulted in error
                popErrorNr = -1;
                if ([operand1 isKindOfClass:[NSString class]]) {
                    resultStringObject = operand1;
                }
            }
        }
    }
    
    //return result;
    if (popErrorNr == 0) {
        resultNumberObject = [NSNumber numberWithDouble:result];
        resultObject = resultNumberObject;
    } else {
        if (popErrorNr == -1) { //error resulting from recursive method call
            ; //do nothing, resultStringObject was initalized above
        } else if (popErrorNr == 1) {
            resultStringObject = @"Error: missing operand";
        } else if (popErrorNr == 2) {
            resultStringObject = @"Error: division by zero";
        }  
        
        resultObject = resultStringObject;
    }
    
    return resultObject;
}


+ (NSString *)forceOuterParentheses:(NSString *)mathExpression;
//do it only if necessary, no duplicate open/close-pairs!
{
    NSString *workString = mathExpression;
    NSString *helpString;
    BOOL hasThem = FALSE;
    int nrOfOpenBrackets;
    
    NSRange myRange;
    myRange.length = 1;
    myRange.location = 0;
    
    if ([@"(" isEqualToString:[workString substringWithRange:myRange]]) {
        nrOfOpenBrackets = 1;
        while (nrOfOpenBrackets !=0) {
            myRange.location++;
            if ((myRange.location) < [workString length]) {
                helpString = [workString substringWithRange:myRange];
                if ([@"(" isEqualToString:helpString]) {
                    nrOfOpenBrackets++;
                } else if ([@")" isEqualToString:helpString]) {
                    nrOfOpenBrackets--;
                }
                if (nrOfOpenBrackets == 0) {
                    hasThem = (myRange.location == [workString length] - 1);
                }
            }
            else {
                nrOfOpenBrackets = 0; //force exit of loop, is end of workstring
            }
        }
        
    }
    
    if (!hasThem) {
        workString = [NSString stringWithFormat:@"(%@)", workString];
    }
    
    return workString;
}


+ (int)priorityOfOperandByString:(NSString *)anOperandString;
/*
 5 for Operators with 2 Operands (/)
 4 for Operators with 2 Operands (*)
 3 for Operators with 2 Operands (-)
 2 for Operators with 2 Operands (+)
 1 - not returned here, reserved priority for leading "-" of a number
 0 for anything else (numbers, Pi, variables)
 
 Thesis:
 Parentheses around a child operation must be set, when the priority of the parent operator is higher than
 the priority of the child operator.
 Exception: "-"-Operator, Example: 3-(2-1) needs parentheses when both priorities are equal.
 */
{
    int result = 0;
   
        if ([anOperandString isEqualToString:@"/"]) {
            result = 5;
        } else if ([anOperandString isEqualToString:@"*"]) {
            result = 4;
        } else if ([anOperandString isEqualToString:@"-"]) {
            result = 3;
        } else if ([anOperandString isEqualToString:@"+"]) {
            result = 2;
    }
    
    return result;
}


+ (NSMutableArray *)replaceSignOperatorByMultiplication:(NSMutableArray *) anArray;
// replace any occurance of "+/-"-Operator-Objects by combination of "(-1)" and "*")
{
    NSMutableArray *resultArray;
    id curObjectRead;
    id curObjectWrite;
    BOOL isPlusMinus;
    
    if (anArray) {
        resultArray = [[NSMutableArray alloc] init];
    }
    
    for (curObjectRead in anArray) {
        isPlusMinus = FALSE;
        curObjectWrite = curObjectRead;
        
        if ([curObjectRead isKindOfClass:[NSString class]]) {
            if ([curObjectRead isEqualToString:@"+/-"]) isPlusMinus = TRUE;
        }
        
        if (isPlusMinus) {
            [resultArray addObject:[[NSNumber alloc] initWithInt:(-1)]];
            curObjectWrite = @"*";
        }
        
        [resultArray addObject:curObjectWrite];
    }
    
    return resultArray;
}


+ (NSString *)descriptionOfProgramArray:(NSMutableArray *)stack priorityOfCaller:(int)callerPriority;
{
    NSString *myDescription = @"";
    NSString *formatHelpStringOpen = @"";
    NSString *formatHelpStringClose = @"";
    NSString *operand1 = @"";
    NSString *operand2 = @"";
    int ownPriority;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) //Number
    {
        NSNumber *myZeroNumber = [[NSNumber alloc] initWithInt:0];
        if ([(NSNumber *)topOfStack compare:myZeroNumber] == NSOrderedAscending) {
            
            ownPriority = 1;
            if (ownPriority < callerPriority) {
                formatHelpStringOpen = @"(";
                formatHelpStringClose = @")";
            } else {
                formatHelpStringOpen = @"";
                formatHelpStringClose = @"";
            }
            myDescription = [NSString stringWithFormat:@"%@%@%@", formatHelpStringOpen, [topOfStack stringValue], formatHelpStringClose];
        } else {
            myDescription = [NSString stringWithFormat:@"%@", [topOfStack stringValue]];
        }
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
                    ownPriority = [self priorityOfOperandByString:(NSString *)topOfStack];
                    operand2 = [self descriptionOfProgramArray:stack priorityOfCaller:ownPriority];
                    //if ([operand2 length] == 0) operand2 = @"0";
                    if ([operand2 length] == 0) operand2 = @"☹";
                    operand1 = [self descriptionOfProgramArray:stack priorityOfCaller:ownPriority];
                    //if ([operand1 length] == 0) operand1 = @"0";
                    if ([operand1 length] == 0) operand1 = @"☹";
                    
                    myDescription = [NSString stringWithFormat:@"%@%@ %@ %@%@", formatHelpStringOpen, operand1, (NSString *)topOfStack, operand2, formatHelpStringClose];
    }
            
    
    
    return myDescription;
}



+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *myDescription = @"";
    NSString *strAppendOps = @", ";
    NSString *strHelper;
    NSMutableArray *stack;
    int nrOfStackObjects, nrOfCurrentLoop;
    
    //NSLog(@"descriptionOfProgram BEGIN");
    
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [self replaceSignOperatorByMultiplication:[program mutableCopy]];
        
        nrOfStackObjects = [stack count];
        nrOfCurrentLoop = 0;
        
        while ([stack count] > 0) {
            nrOfCurrentLoop++;
            
            //NSLog(@"While-Loop Nr. %i BEGIN - nrOfStackObjects=%i, myDescription='%@'", nrOfCurrentLoop, nrOfStackObjects, myDescription);
            
            strHelper = @"";
            if (nrOfCurrentLoop > 1) strHelper = strAppendOps;
            
            myDescription = [NSString stringWithFormat:@"%@%@%@", myDescription, strHelper, [self descriptionOfProgramArray:stack priorityOfCaller:0]];
            nrOfStackObjects = [stack count];
            
            //NSLog(@"While-Loop Nr. %i END - nrOfStackObjects=%i, myDescription='%@'", nrOfCurrentLoop, nrOfStackObjects, myDescription);
            
        }
    }
    
    //NSLog(@"descriptionOfProgram END - myDescription='%@'", myDescription);
    //NSLog(@" ");
    
    return myDescription;
}

+ (id)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    if ([stack count]) {
        return [self popOperandOffStack:stack];
    } else {
        return [NSNumber numberWithDouble:0];
    }
}

- (void)clearState
{
    [self.programStack removeAllObjects];
}



@end
