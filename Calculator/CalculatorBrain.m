//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Thadeu Carmo on 4/8/12.
//  Copyright (c) 2012 IME-USP. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end


@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack {
    if(!_operandStack){
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (double) popOperand{
    NSNumber *operandObject = [self.operandStack lastObject];
    if(operandObject){
        [self.operandStack removeLastObject];   
    }
    return [operandObject doubleValue];
}

- (void) pushOperand: (double) operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) performOperation: (NSString *) operation {
    double result = 0.0;
    if([operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    }
    // sending a message to a constant string
    else if([@"*" isEqualToString:operation]){
        result = [self popOperand] * [self popOperand];
    }
    else if([@"-" isEqualToString:operation]){
        double leftOperand = [self popOperand];
        result = [self popOperand] - leftOperand;
    }
    else if([@"/" isEqualToString:operation]){
        double leftOperand = [self popOperand];
        result = [self popOperand] / leftOperand;
    }
    [self pushOperand:result];
    return result;
}


@end
