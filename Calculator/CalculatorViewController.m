//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Thadeu Carmo on 4/8/12.
//  Copyright (c) 2012 IME-USP. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize brain   = _brain;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;

- (CalculatorBrain *) brain {
    if(!_brain){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {

    NSString *digit = [sender currentTitle];
    if(self.userIsInTheMiddleOfEnteringNumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}
- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringNumber){
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultAsString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultAsString;
}

- (IBAction)enterPressed {
    double value = [self.display.text doubleValue];
    [self.brain pushOperand:value];
    self.userIsInTheMiddleOfEnteringNumber = NO;
}

@end
