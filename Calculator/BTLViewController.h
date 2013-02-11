//
//  BTLViewController.h
//  Calculator
//
//  Created by Benedikt Lotter on 1/18/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTLViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;

- (IBAction)equalPress:(UIButton *)sender;
- (IBAction)digitPress:(UIButton *)sender;
- (IBAction)equalPress;
- (IBAction)operationPress:(UIButton *)sender;
- (IBAction)clearPress:(UIButton *)sender;
- (IBAction)decimalPress:(UIButton *)sender;

@end
