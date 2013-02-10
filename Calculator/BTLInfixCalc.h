//
//  BTLInfixCalc.h
//  Calculator
//
//  Created by Benedikt Lotter on 2/9/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTLInfixCalc : NSObject

@property (nonatomic, strong) NSMutableString *workingString;

-(void)pushOperand:(double)operand;
-(void)clearState;



@property (readonly) id program;
+ (id)runProgram:(id)program;

@end
