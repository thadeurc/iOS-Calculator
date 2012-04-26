//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Thadeu Carmo on 4/8/12.
//  Copyright (c) 2012 IME-USP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject


- (void) pushOperand: (double) operand;
- (void) pushOperation: (NSString *) operation;
- (void) pushVariable: (NSString *) variable;
- (void) clearOperands;

@property (nonatomic, readonly) id program;
+ (NSString *)descriptionOfProgram: (id)program;
+ (double)runProgram: (id)program;
+ (double)runProgram: (id)program usingVariableValues: (NSDictionary *) variableValues;
+ (NSSet *) variablesUsedInProgram: (id) program;

@end
