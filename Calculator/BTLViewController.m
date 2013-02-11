//
//  BTLViewController.m
//  Calculator
//
//  Created by Benedikt Lotter on 1/18/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLViewController.h"

#import "BTLInfixCalc.h"

@interface BTLViewController ()

@property (nonatomic, strong) BTLInfixCalc *test;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userSelectedMinusBeforeEnteringADigit;
@property (nonatomic) BOOL decimalState;
@property (nonatomic) NSMutableString* workingString;


@end

@implementation BTLViewController

@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userSelectedMinusBeforeEnteringADigit = _userSelectedMinusBeforeEnteringADigit;
@synthesize workingString = _workingString;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"matt_shadow2.jpg"]];
    self.userIsInTheMiddleOfEnteringANumber = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (BTLInfixCalc *)test{
    if (!_test) _test = [[BTLInfixCalc alloc] init];
    return _test;
}


- (NSMutableString *)workingString{
    if (!_workingString) {
        _workingString = [[NSMutableString alloc] init];
    }
    return _workingString;
}



// IBActions for all the buttons

- (IBAction)digitPress:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
    NSMutableString* digit = [[NSMutableString alloc] initWithString:[sender currentTitle]];
    [self.workingString appendString:digit];
    }
   
}



- (IBAction)equalPress {
    
    if (self.display.text) {
        [self.test pushItem:self.workingString];
        double result = [self.test doCalculation];
        [self.test.inputArray removeAllObjects];
        self.workingString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%f",result]];
        [self.test pushOperand:result];
        self.display.text = [NSString stringWithFormat:@"%lf", result];
    }
    
    
}



- (IBAction)operationPress:(UIButton *)sender {
    
    
    if (self.userIsInTheMiddleOfEnteringANumber){
    NSString *operation = sender.currentTitle;
    if (([operation isEqualToString:@"-"]) && ([self.workingString isEqualToString:@""])){
        [self.workingString appendString:@"-"];
        self.userSelectedMinusBeforeEnteringADigit = YES;
    }
    else{
        [self.display.text stringByAppendingString:operation];
        [self.test pushItem:self.workingString];
        [self.test pushItem:operation];
        
        self.workingString = [NSMutableString stringWithString:@""];
        
    }
    }
    
    
}


- (IBAction)clearPress:(UIButton *)sender {
    
    self.display.text = @"0";
    self.userSelectedMinusBeforeEnteringADigit = NO;
    self.workingString = [NSMutableString stringWithString:@""];
    [self.test clearState];
}



- (IBAction)decimalPress:(UIButton *)sender {
    
    [self.display.text stringByAppendingString:@"."];
    [self.workingString appendString:@"."];
    self.decimalState = YES;
    self.userIsInTheMiddleOfEnteringANumber = YES;

}







@end
