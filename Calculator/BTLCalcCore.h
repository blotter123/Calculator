//
//  BTLCalcCore.h
//  Calculator
//
//  Created by Benedikt Lotter on 2/7/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTLCalcCore : NSObject

-(id)doOperation:(NSString *)operation;
-(void)pushOperand:(double)operand;
-(void)clearState;
-(void)removeTopItemFromProgram;


@property (readonly) id program;

+ (id)runProgram:(id)program; //doesn't calculate Variables

+ (NSString *)descriptionOfProgram:(id)program;


@end
