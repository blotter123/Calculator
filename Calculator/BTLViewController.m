//
//  BTLViewController.m
//  Calculator
//
//  Created by Benedikt Lotter on 1/18/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLViewController.h"
#import "BTLCalcCore.h"

@interface BTLViewController ()

@property (nonatomic, strong) BTLCalcCore *operator;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userSelectedMinusBeforeEnteringADigit;

+ (void)setCalculatorBrainAndState:(BTLViewController *)destinationViewController calCore:(id)oper isInTheMiddleOfEnteringANumber:(BOOL)stateEntering selectedMinusBeforeEnteringADigit:(BOOL)stateMinus;

@end

@implementation BTLViewController

@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userSelectedMinusBeforeEnteringADigit = _userSelectedMinusBeforeEnteringADigit;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"matt_shadow2.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BTLCalcCore *)operator {
    if (!_operator) _operator = [[BTLCalcCore alloc] init];
    return _operator;
}

- (void) delIsResultIndicator; {
    /*
     NSString *sumSignLong = @" =";
     NSRange posOfSumSign = [self.historyDisplay.text rangeOfString:sumSignLong];
     if (posOfSumSign.location != NSNotFound) {
     self.historyDisplay.text = [self.historyDisplay.text substringToIndex:posOfSumSign.location];
     }
     */
}

- (void) setIsResultIndicator; {
    /*
     NSString *sumSignLong = @" =";
     NSRange posOfSumSign = [self.historyDisplay.text rangeOfString:sumSignLong];
     if (posOfSumSign.location == NSNotFound) {
     self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString: sumSignLong];
     }
     */
}



- (void) secureSetDisplayText:(NSString *)newDisplayString {
    NSString *workDisplayString = @"";
    NSString *zeroString = @"0";
    NSUInteger index;
    BOOL stateMinus = NO;   //change to YES at the 1st occurance of "-"
    BOOL stateDecimal = NO; //change to YES at the 1st occurance of period
    BOOL stateFreeShotforZeroAllowed = NO; //change to YES at period or 1st occurance of digit >=1
    BOOL stateExponential = NO; //change to YES at 1st occurance of "e"
    NSString *curCharString = @"";
    NSString *prevCharString = @"";
    NSRange curRange;
    NSString *digitString = @"0123456789einf"; //allow "e" for operation results w/ large values
    
    
    //Check if newDisplayString is nil
    if (!newDisplayString) {
        workDisplayString = zeroString;
        
        //Check if newDisplayString is empty
    } else if ([newDisplayString isEqualToString:@""]) {
        workDisplayString = zeroString;
        
        //**From now on, newDisplayString is NOT empty
    } else {
        for (index = 0; index <= ([newDisplayString length]-1); index++) {
            prevCharString = curCharString;
            curRange.length = 1;
            curRange.location = index;
            curCharString = [newDisplayString substringWithRange:curRange];
            
            //NSLog(@"Index=%i, curCharString=%@, prevCharString=%@", index, curCharString, prevCharString);
            
            //Check "-"
            if ([curCharString isEqualToString:@"-"]) {
                
                if (stateExponential) {
                    workDisplayString = [workDisplayString stringByAppendingString:@"-"];
                } else if (!stateMinus) {
                    workDisplayString = [@"-" stringByAppendingString:workDisplayString];
                    stateMinus = YES;
                };
            }
            
            // Check period
            else if ([curCharString isEqualToString:@"."]) {
                if (!stateDecimal) {
                    if ([digitString rangeOfString:prevCharString].location == NSNotFound) {
                        workDisplayString = [workDisplayString stringByAppendingString:@"0."];
                    } else {
                        workDisplayString = [workDisplayString stringByAppendingString:@"."];
                    }
                    stateDecimal = YES;
                    stateFreeShotforZeroAllowed = YES;
                    
                }
            }
            
            // Check digits with "zero-handling"
            //
            else if ([digitString rangeOfString:curCharString].location != NSNotFound) {
                if (stateFreeShotforZeroAllowed) {
                    workDisplayString = [workDisplayString stringByAppendingString:curCharString];
                } else {
                    if ([prevCharString isEqualToString:@"0"]) {
                        workDisplayString = [[workDisplayString substringToIndex:([workDisplayString length]-1)] stringByAppendingString:curCharString];
                    } else {
                        workDisplayString = [workDisplayString stringByAppendingString:curCharString];
                    };
                    if (![curCharString isEqualToString:@"0"]) {
                        stateFreeShotforZeroAllowed = YES;
                    }
                }
                
                if ([curCharString isEqualToString:@"e"]) {
                    stateExponential = YES;
                    stateFreeShotforZeroAllowed = YES;
                }
            }
        }
    }
    
    //last check of workDisplayString
    if ([workDisplayString isEqualToString:@"-"]) {
        workDisplayString = @"-0";
    }
    
    //assign to display.text
    
    self.display.text = workDisplayString;
    
    //correct state information
    
    if ([workDisplayString isEqualToString:@"0"]) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
    } else if ([workDisplayString isEqualToString:@"-0"]) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
    
}



// IBActions for all the buttons

- (IBAction)digitPress:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    [self delIsResultIndicator];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self secureSetDisplayText:([self.display.text stringByAppendingString:digit])];
    } else {
        if (self.userSelectedMinusBeforeEnteringADigit) {
            [self secureSetDisplayText:[@"-" stringByAppendingString:(digit)]];
        } else {
            [self secureSetDisplayText:digit];
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}



- (IBAction)equalPress {
    if (self.display.text) {
        
        if ([self.display.text rangeOfString:@"Error"].location == NSNotFound ) {
            [self.operator pushOperand:[self.display.text doubleValue]];
            self.userIsInTheMiddleOfEnteringANumber = NO;
            self.userSelectedMinusBeforeEnteringADigit = NO;
            
            [self delIsResultIndicator];
            self.historyDisplay.text = [BTLCalcCore descriptionOfProgram:self.operator.program];
        }
    
    }
}



- (IBAction)operationPress:(UIButton *)sender {
    
    [self delIsResultIndicator];
    if (self.userIsInTheMiddleOfEnteringANumber) [self equalPress];
    NSString *operation = sender.currentTitle;
    
    id resultObject = [self.operator   doOperation:operation];
    self.historyDisplay.text = [BTLCalcCore descriptionOfProgram:self.operator.program];
    
       if ([resultObject isKindOfClass:[NSNumber class]]) {
        [self secureSetDisplayText:([NSString stringWithFormat:@"%g", [(NSNumber *)resultObject doubleValue]])];
    } else if ([resultObject isKindOfClass:[NSString class]]) {
        self.display.text = (NSString *)resultObject;
    }
    [self setIsResultIndicator];
}


- (IBAction)clearPress:(UIButton *)sender {
    
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userSelectedMinusBeforeEnteringADigit = NO;
    [self.operator clearState];
}



- (IBAction)decimalPress:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self secureSetDisplayText:([self.display.text stringByAppendingString:@"."])];
    } else {
        if (self.userSelectedMinusBeforeEnteringADigit) {
            [self secureSetDisplayText:@"-."];
        } else {
            [self secureSetDisplayText:@"."];
            
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
        [self delIsResultIndicator];
    }

}

+ (void)setCalculatorBrainAndState:(BTLViewController *)destinationViewController calcCore:(id)oper isInTheMiddleOfEnteringANumber:(BOOL)stateEntering selectedMinusBeforeEnteringADigit:(BOOL)stateMinus {
    if (destinationViewController) {
        if (oper) destinationViewController.operator = oper;
        destinationViewController.userIsInTheMiddleOfEnteringANumber = stateEntering;
        destinationViewController.userSelectedMinusBeforeEnteringADigit = stateMinus;
    }
}







@end
