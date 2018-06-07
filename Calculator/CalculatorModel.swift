//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Prateek Sharma on 6/7/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import Foundation


struct CalculatorModel{

    private var operationStack = Stack<Operation>()
    private var operandStack = Stack<Operand>()

    private var knownOps = [
        "+" : Operation(precedence: 1, operation: +), //Uses the infix method
        "-" : Operation(precedence: 1, operation: -),
        "/" : Operation(precedence: 2, operation: /),
        "*" : Operation(precedence: 2, operation: *)
    ]

    mutating func evaluate() -> Double? {
        guard let operand2 = operandStack.pop(),
              let operand1 = operandStack.pop(),
             let operation = operationStack.pop()
            else { return nil }
        
        return operation.operation(operand1, operand2)
    }

    mutating func clearOutStacks() {
        operandStack.clear()
        operationStack.clear()
    }
    
    mutating func evaluateAll() -> Double? {
        while !operationStack.isEmpty {
            guard let result = evaluate() else { break }
            operandStack.push(element: Operand(result))
        }
        let result = operandStack.pop()
        clearOutStacks()
        return result
    }
    
    mutating func pushOperand(operand:Operand) {
        operandStack.push(element: Operand(operand));
    }

    mutating func performOperations(symbol:String) -> (output: Double?, errorOccured: Bool) {
        var output: Double?
        if let operation = knownOps[symbol] {
            while let previousOp = operationStack.top, previousOp.precedence >= operation.precedence {
                guard let evaluationResult = evaluate()
                else {   // Error in calculator
                    clearOutStacks()
                    return (output: nil, errorOccured: true)
                }
                output = evaluationResult
                operandStack.push(element: evaluationResult)
            }
            operationStack.push(element: operation)
        }
        return (output: output, errorOccured: false)
    }

}
