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
@property (nonatomic, strong) NSDictionary *testVariableValues;
- (void) appendToHistory: (NSString *) text: (BOOL)useEquals;
- (void) clearHistory;
- (void) clearDisplay;
- (void) updateVariablesDisplay;
- (void) clearVariablesDisplay;

@end

@implementation CalculatorViewController

@synthesize brain   = _brain;
@synthesize display = _display;
@synthesize history = _history;
@synthesize variables = _variables;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize numberAlreadyHasDot = _numberAlreadyHasDot;
@synthesize testVariableValues = _testVariableValues;

- (NSDictionary *) testVariableValues {
    if(!_testVariableValues){
        _testVariableValues = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithDouble:50.0], @"a", 
                               [NSNumber numberWithDouble:100.0], @"b",
                               [NSNumber numberWithDouble:500.0], @"x", nil];

    }
    return _testVariableValues;
}

- (void) clearHistory {
    self.history.text = @"";
}

- (void) clearVariablesDisplay {
    self.variables.text = @"";
}

- (void) clearDisplay {
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringNumber = NO;
}

- (void) appendToHistory:(NSString *)text: (BOOL) useEquals {
    NSString *pattern = useEquals ? @" %@ =" : @" %@";
    NSString *newText = [self.history.text stringByAppendingFormat: pattern, text];
    if(newText.length > 50){
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
    [self.brain pushOperation: sender.currentTitle];        
    double result = [CalculatorBrain runProgram: self.brain.program usingVariableValues: self.testVariableValues];
    [self appendToHistory: sender.currentTitle : YES];
    NSString *resultAsString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultAsString;
    NSRange range = [resultAsString rangeOfString: @"."];
    self.numberAlreadyHasDot = range.length != 0;
}

- (IBAction)enterPressed {
    double value = [self.display.text doubleValue];
    [self.brain pushOperand:value];
    [self appendToHistory: self.display.text : NO]; 
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
    [self clearVariablesDisplay];
    [self.brain clearOperands];
}

- (IBAction)backspacePressed {
    NSString *text = self.display.text;
    if(text.length == 1){
        self.display.text = @"0";
        self.numberAlreadyHasDot = NO;
        self.userIsInTheMiddleOfEnteringNumber = NO;
    }
    else{
        text = [text substringToIndex: text.length - 1];
        self.display.text = text;
        self.numberAlreadyHasDot = [text rangeOfString: @"."].length != 0;
    }
}
- (IBAction)undoPressed:(UIButton *)sender {
}

- (IBAction)test1Pressed {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:5.0], @"a", 
                               [NSNumber numberWithDouble:10.0], @"b",
                               [NSNumber numberWithDouble:50.0], @"x", nil];
    [self updateVariablesDisplay];
}

- (IBAction)test2Pressed {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:-2.3212], @"a", 
                               [NSNumber numberWithDouble:-12232.2], @"b",
                               [NSNumber numberWithDouble:0.0], @"x", nil];

    [self updateVariablesDisplay];
}
- (IBAction)test3Pressed {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    [self updateVariablesDisplay];
}

- (void) updateVariablesDisplay {
    NSSet *inUseVariables = [CalculatorBrain variablesUsedInProgram: self.brain.program];
    if(inUseVariables){
        NSString *result = @"";
        for (NSString *variable in inUseVariables) {
            NSString *value = [self.testVariableValues objectForKey:variable];
            if(!value) value = @"0";
            result = [result stringByAppendingFormat: @"%@ = %@   ", variable, value];
        }
        self.variables.text = result;
    }
}
- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
    [self appendToHistory: sender.currentTitle : NO];    
    [self updateVariablesDisplay];
}

@end
