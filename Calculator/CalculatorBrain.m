//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Thadeu Carmo on 4/8/12.
//  Copyright (c) 2012 IME-USP. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
+ (double) toRadians: (double) degrees;
+ (BOOL) isVariable: (NSString *) candidate;
+ (BOOL) isOperand: (NSString *) candidate;
@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

+ (BOOL) isVariable: (NSString *) candidate {
    return [@"a" isEqualToString:candidate] || 
            [@"b" isEqualToString:candidate] || 
            [@"x" isEqualToString:candidate];
}

+ (BOOL) isOperand: (NSString *) candidate {
    return [@"+" isEqualToString:candidate] || 
            [@"-" isEqualToString:candidate] || 
            [@"*" isEqualToString:candidate] ||
            [@"/" isEqualToString:candidate] || 
            [@"sin" isEqualToString:candidate] || 
            [@"cos" isEqualToString:candidate] ||
            [@"sqrt" isEqualToString:candidate] ||
            [@"∏" isEqualToString:candidate];
}


- (id)program
{
    id theCopy = [[self programStack] copy];
    return theCopy;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

+ (double)runProgram:(id)program
{
    NSDictionary *emptyDictionary = [[NSDictionary alloc] init];
    return [self runProgram:program usingVariableValues: emptyDictionary];
}

+ (double)runProgram: (id)program usingVariableValues: (NSDictionary *) variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack usingVariableValues: variableValues];

}

+ (NSSet *) variablesUsedInProgram: (id) program
{
    NSMutableArray *variables = [[NSMutableArray alloc] init ];  
    if([program isKindOfClass:[NSArray class]]){
        for (NSString *candidate in program) {
            if([self isVariable:candidate]){
                [variables addObject:candidate];
            }
        }
    }
    return variables.count == 0 ? nil : [[NSSet alloc] initWithArray:variables];
}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack usingVariableValues: (NSDictionary *) variableValues
{
    double result = 0.0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] + 
            [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] * 
            [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if (divisor){
                result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] / divisor;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            double operand = [self toRadians: [self popOperandOffProgramStack:stack usingVariableValues:variableValues]];
            result = sin(operand);
        } else if ([operation isEqualToString:@"cos"]) {
            double operand = [self toRadians: [self popOperandOffProgramStack:stack usingVariableValues:variableValues]];
            result = cos(operand);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double operand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = sqrt(operand);
        } else if([@"∏" isEqualToString:operation]){
            result = M_PI;
        } 
        /* if none of the default operands, assumes it is a variable */
        else {
            id valueForVariable = [variableValues valueForKey: operation];
            if(valueForVariable && [valueForVariable isKindOfClass:[NSNumber class]]){
                result = [valueForVariable doubleValue];
            }            
        }
    }
    return result;
}


+ (double) toRadians: (double) degrees {
    return degrees * M_PI / 180;
}

- (NSMutableArray *) programStack {
    if(!_programStack){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)pushOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
}

- (void)pushVariable:(NSString *) variable
{
    if([CalculatorBrain isVariable:variable])
        [self.programStack addObject:variable];
}

- (void) pushOperand: (double) operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) clearOperands {
    [self.programStack removeAllObjects];
}


@end
