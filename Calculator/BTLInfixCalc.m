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
    NSLog(@"pushing %@ into inArray", x);
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

+ (double) computeFinalResult:(NSMutableArray*) operandsStack through:(NSMutableArray*)operationsStack
{
    while ([operationsStack count] > 0) {
        NSString* operation = [self popOperator:operationsStack];
        NSLog(@"operation is %@", operation);
        NSLog(@"top of operands stack is %@", operandsStack.lastObject);
        NSNumber* operand1 = [self popOperand:operandsStack];
        //NSLog(@"operand2 is %@", operand2);
        NSLog(@"top of operands stack is %@", operandsStack.lastObject);
        NSNumber* operand2 = [self popOperand:operandsStack];
        NSLog(@"operand1 is %@", operand1);
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
        NSLog(@"top of operands stack is %@", operandsStack.lastObject);
        //NSLog(@"current result is %@", tempResult);
        
    }
    
    
    NSNumber* lastObject = [operandsStack lastObject];
    NSLog(@"top of operands stack is %@", operandsStack.lastObject);
    //NSLog(@"deepest number in operand stack is %@", [operandsStack objectAtIndex:0]);
    //NSLog(@"deepest number in operations stack is %@", [operationsStack objectAtIndex:0]);
    //NSLog(@"top of operations stack is %@", operationsStack.lastObject);
    NSLog(@"the length of the operand stack is %u", [operandsStack count]);
    NSLog(@"the length of the operations stack is %u", [operationsStack count]);
    //[operandsStack removeLastObject];
    //NSLog(@"end result is %@", lastObject);
    //NSLog(@"operandStack length %u", [operandsStack count]);
    //NSLog(@"operationsStack length %u", [operationsStack count]);
    return [lastObject doubleValue];
    
}



+ (double) computeResult:(NSMutableArray*)inArray computedInto: (NSMutableArray*)numStack
                                                           by: (NSMutableArray*)operStack
{
    
    for (int i = 0; i< ([inArray count]); i ++) {
        NSLog(@"element in inArray is %@", [inArray objectAtIndex:i]);
    }
    
    
    for (int i = ([inArray count]-1); i>=0; i--) {
    
    //for (int i = 0 ; i<(inArray.count); i++) {
        NSString* currObject = [inArray objectAtIndex:i];
        //NSLog(@"the current object is%@", currObject);
        if ([self stringIsOperation:currObject]) {
            if ([operStack count] != 0 || ([self priorityOfOperandByString:currObject] < [self priorityOfOperandByString:[operStack lastObject]])) {
                NSString* operation = [self popOperator:operStack];
                NSLog(@"top of operands stack is %@", operStack.lastObject);
                NSNumber* operand1 = [self popOperand:numStack];
                NSLog(@"top of operands stack is %@", operStack.lastObject);
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
                NSLog(@"branch test push to operStack %@", currObject);
                [operStack addObject:(id)currObject];
            }
        } else {
           // NSLog(@"number added to numstack %@", currObject);
            [numStack addObject:(id)currObject];
        }
    }
    for (int i = 0; i< ([operStack count]); i ++) {
        NSLog(@"element in operArray is %@", [operStack objectAtIndex:i]);
    }
    
    double finalResult = [self computeFinalResult:numStack through:operStack];
    return finalResult;
    //NSLog(@"inStack length %u", [inArray count]);
    //NSLog(@"numStack length %u", [numStack count]);
    //NSLog(@"operandStack length %u", [operStack count]);

}

- (void) clearState
{
    [self.inputArray removeAllObjects];
    [self.operatorStack removeAllObjects];
    [self.numberStack removeAllObjects];
    
}


- (double)doCalculation
{
    //NSLog(@"when starting the calculation, the operandStack length %u", [self.numberStack count]);
    //NSMutableArray* opStack = [self operatorStack];
    //NSMutableArray* numStack = [self numberStack];
    //NSMutableArray* inArray = [self inputArray];
    double result = [BTLInfixCalc computeResult: self.inputArray computedInto: self.numberStack by: self.operatorStack];
    return result;
    [self.inputArray removeAllObjects];
}





@end
