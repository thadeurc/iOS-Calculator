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
@property (nonatomic) BOOL numberAlreadyHasDot;
@property (nonatomic, strong) CalculatorBrain *brain;
- (void) appendToHistory: (NSString *) text;
- (void) clearHistory;
- (void) clearDisplay;

@end

@implementation CalculatorViewController

@synthesize brain   = _brain;
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize numberAlreadyHasDot = _numberAlreadyHasDot;

- (void) clearHistory {
    self.history.text = @"";
}

- (void) clearDisplay {
    self.display.text = @"0";
}

- (void) appendToHistory:(NSString *)text {
    NSString *newText = [self.history.text stringByAppendingFormat: @" %@", text];
    if(newText.length > 30){
        newText = text;
    }
    self.history.text = newText;
}

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
        self.numberAlreadyHasDot = NO;
    }
}
- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringNumber){
        [self enterPressed];
    }
    double result = [self.brain performOperation: sender.currentTitle];    
    [self appendToHistory: sender.currentTitle];
    NSString *resultAsString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultAsString;
    NSRange range = [resultAsString rangeOfString: @"."];
    self.numberAlreadyHasDot = range.length != 0;
}

- (IBAction)enterPressed {
    double value = [self.display.text doubleValue];
    [self.brain pushOperand:value];
    [self appendToHistory: self.display.text];    
    self.userIsInTheMiddleOfEnteringNumber = NO;    
}

- (IBAction)dotPressed {
    if(!self.numberAlreadyHasDot){
        self.display.text = [self.display.text stringByAppendingString: @"."];
        self.numberAlreadyHasDot = YES;
        // for the case the user starts with .
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}
- (IBAction)clearPressed {
    [self clearHistory];
    [self clearDisplay];
    [self.brain clearOperands];
}

@end
