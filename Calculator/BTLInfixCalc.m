//
//  BTLInfixCalc.m
//  Calculator
//
//  Created by Benedikt Lotter on 2/9/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//
#include <math.h>
#import "BTLInfixCalc.h"

@interface BTLInfixCalc ()

@property (nonatomic, strong)   NSMutableArray  *operatorStack;
@property (nonatomic, strong)   NSMutableArray  *numberStack;


+ (int) inputLength;
+ (int) encodeString:(NSString *) inputString;
+ (BOOL)stringIsOperation: (NSString*)inputString;

@end

@implementation BTLInfixCalc


-(int)inputLength
{
    return [self.inputArray count];
}

- (NSMutableArray *) operatorStack{
    if (!_operatorStack){
        _operatorStack = [[NSMutableArray alloc] init];
    }
    return _operatorStack;
}

- (NSMutableArray *) numberStack{
    if (!_numberStack){
        _numberStack = [[NSMutableArray alloc] init];
    }
    return _numberStack;
}

- (NSMutableArray *) inputArray{
    if (!_inputArray){
        _inputArray = [[NSMutableArray alloc] init];
    }
    return _inputArray;
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

-(void)pushItem: (NSString*) x
{
    [self.inputArray addObject:x];
    
}


- (void)pushOperand: (double) operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    NSLog(@"pushing %@", operandObject);
    [self.numberStack addObject:operandObject];
}


- (void)pushOperator: (double) operator
{
    NSNumber *operatorObject = [NSNumber numberWithDouble:operator];
    
    [self.numberStack addObject:operatorObject];
}

+(NSString*)popOperator: (NSMutableArray*) aOperatorArray
{
    NSString* lastObject = [aOperatorArray lastObject];
    [aOperatorArray removeLastObject];
    //NSLog(@"poping %@", lastObject);
    return lastObject;
    
}

+(NSNumber*)popOperand: (NSMutableArray*) aNumberArray
{
    NSNumber* lastObject = [aNumberArray lastObject];
    [aNumberArray removeLastObject];
    //NSLog(@"poping %@", lastObject);
    return lastObject;
    
}




+ (int)priorityOfOperandByString:(NSString *)anOperandString;

{
    int result = 0;
    
    if ([anOperandString isEqualToString:@"/"]) {
        result = 2;
    } else if ([anOperandString isEqualToString:@"*"]) {
        result = 2;
    } else if ([anOperandString isEqualToString:@"-"]) {
        result = 1;
    } else if ([anOperandString isEqualToString:@"+"]) {
        result = 1;
    }
    
    return result;
}


//once the number and operator array have been filled and the */ (/) operations have been computed, this calculates the remaining operations in the inputArray

+ (double) computeFinalResult:(NSMutableArray*) operandsStack through:(NSMutableArray*)operationsStack
{
    while ([operationsStack count] > 0) {
        NSString* operation = [self popOperator:operationsStack];
        
        NSNumber* operand1 = [self popOperand:operandsStack];
        
        NSNumber* operand2 = [self popOperand:operandsStack];
        
        NSNumber* tempResult = 0;
        if ([operation isEqualToString:@"+"]) {
            tempResult = [NSNumber numberWithDouble:([operand1 doubleValue] + [operand2 doubleValue])];
            [operandsStack addObject: (id)tempResult];
        } else if ([@"*" isEqualToString:operation]) {
            tempResult = [NSNumber numberWithDouble:([operand1 doubleValue] * [operand2 doubleValue])];
            [operandsStack addObject: (id)tempResult];
        } else if ([@"-" isEqualToString:operation]) {
            tempResult = [NSNumber numberWithDouble:([operand1 doubleValue] - [operand2 doubleValue])];
            [operandsStack addObject: (id)tempResult];
        } else if ([@"/" isEqualToString:operation]) {
            if ([operand1 doubleValue] != 0) {
                tempResult = [NSNumber numberWithDouble:([operand1 doubleValue] / [operand2 doubleValue])];
                [operandsStack addObject: (id)tempResult];
            }
            else {
                tempResult = [NSNumber numberWithDouble:NAN];
            }
            
        }
               
    }
    
    
    NSNumber* lastObject = [operandsStack lastObject];
    
    return [lastObject doubleValue];
    
}


/*
 For each item in the infix expression (no parens) from the right to the left
 If the item is a number then push it on the number stack.
 If the item is an operator (+,-,*, or /) and: the operator stack is empty or the operator on the top of the stack is higher in priority (* and / are higher in priority than + or -), then
 Pop an operator from the operator stack.
 Pop two numbers off the number stack.
 Calculate using second number-operator-first number.
 Push the result on the number stack.
 Push the item on the operator stack.
 Else push the item on the operator stack.
 After the loop, while the operator stack is not empty
 Pop an operator from the operator stack.
 Pop two numbers off the number stack.
 Calculate using second number-operator-first number.
 Push the result on the number stack.
 The answer is the last item in the number stack.
 
 */
 

+ (double) computeResult:(NSMutableArray*)inArray computedInto: (NSMutableArray*)numStack
                                                           by: (NSMutableArray*)operStack
{
    
    
    for (int i = ([inArray count]-1); i>=0; i--) {
        NSString* currObject = [inArray objectAtIndex:i];
        
        if ([self stringIsOperation:currObject]) {
            if ([operStack count] != 0 || ([self priorityOfOperandByString:currObject] < [self priorityOfOperandByString:[operStack lastObject]])) {
                NSString* operation = [self popOperator:operStack];
                
                NSNumber* operand1 = [self popOperand:numStack];
                
                NSNumber* operand2 = [self popOperand:numStack];
                NSNumber* tempResult = 0;
                
                if ([operation isEqualToString:@"+"]) {
                   tempResult = [NSNumber numberWithDouble:([operand2 doubleValue] + [operand1 doubleValue])];
                } else
                    if ([@"*" isEqualToString:operation]) {
                    tempResult = [NSNumber numberWithDouble:([operand2 doubleValue] * [operand1 doubleValue])];
                } else if ([@"-" isEqualToString:operation]) {
                   tempResult = [NSNumber numberWithDouble:([operand2 doubleValue] - [operand1 doubleValue])];
                }
                    else if ([@"/" isEqualToString:operation]) {
                    if ([operand1 doubleValue] != 0) {
                        tempResult = [NSNumber numberWithDouble:([operand2 doubleValue] / [operand1 doubleValue])];
                    }
                    else {
                        tempResult = [NSNumber numberWithDouble:NAN];
                    }
                }
                [numStack addObject: (id)tempResult];
                [operStack addObject:(id)currObject];
                
            } else {
                [operStack addObject:(id)currObject];
            }
        } else {
           
            [numStack addObject:(id)currObject];
        }
    }
    
    
    double finalResult = [self computeFinalResult:numStack through:operStack];
    return finalResult;
    
}

- (void) clearState
{
    [self.inputArray removeAllObjects];
    [self.operatorStack removeAllObjects];
    [self.numberStack removeAllObjects];
    
}


//actually use the computeResult method to compute the result from the inputs os inputArray

- (double)doCalculation
{
    
    double result = [BTLInfixCalc computeResult: self.inputArray computedInto: self.numberStack by: self.operatorStack];
    return result;
    [self.inputArray removeAllObjects];
}





@end
