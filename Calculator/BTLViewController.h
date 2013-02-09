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
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;

- (IBAction)equalPress:(UIButton *)sender;

@end
