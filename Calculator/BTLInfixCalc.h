//
//  BTLInfixCalc.h
//  Calculator
//
//  Created by Benedikt Lotter on 2/9/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTLInfixCalc : NSObject



-(void)pushOperand:(double)operand;
-(void)pushItem:(NSString*)x;
-(void)clearState;
-(int)inputLength;



@property (readonly) id program;
- (double)doCalculation;

@end
