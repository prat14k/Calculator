//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Prateek Sharma on 6/7/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import Foundation


class CalculatorModel{

    struct Stack<T> {
        
        var collection = [T]()
        
        mutating func push(element: T) {
            collection.append(element)
        }
        
        var isEmpty: Bool { return count == 0 }
        var top: T? { return collection.last }
        var count: Int { return collection.count }
        
        mutating func pop() -> T? {
            return !isEmpty ? collection.removeLast() : nil
        }
        
        mutating func clear() { collection.removeAll() }
        
    }
    
    
    struct Operand: CustomStringConvertible {
        var operand: Double
        
        init(_ operand: Double) {
            self.operand = operand
        }
        
        var description : String{
            get{
                return "\(operand)"
            }
        }
        
    }

    
    struct Operation: CustomStringConvertible {
        let symbol: String
        let precedence: Int
        let operation: (Double,Double)->Double
        
        var description : String{
            get{
                return symbol
            }
        }

    }

    var operationStack = Stack<Operation>()
    var operandStack = Stack<Operand>()

    private var knownOps = [String:Operation]()

    init() {
        knownOps["+"] = Operation(symbol: "+", precedence: 1, operation: +) //Uses the infix method

        knownOps["-"] = Operation(symbol: "-", precedence: 1, operation: -)

        knownOps["/"] = Operation(symbol: "/", precedence: 2, operation: /)

        knownOps["*"] = Operation(symbol: "*", precedence: 2, operation: *)

    }


//    private func evaluate(operations : [Operation], operand: [Operand]) -> (result: Double? , remainingOperationStack: [Operation], remainingOperandStack: [Operand]) {
//
//
//
//
//
////        if(!ops.isEmpty)
////        {
////            var remainingOps = ops
////            let op = remainingOps.removeLast()
////
////            switch op {
////            case Op.Operand(let operand):
////                return (operand,remainingOps)
////            case Op.BinaryOperation(_, let precedence, let operation):
////                let operationEvaluation = evaluate(ops:remainingOps)
////                if let operand = operationEvaluation.result{
////                    let operationEvaluation2 = evaluate(ops : operationEvaluation.remainingStack)
////                    if let operand2 = operationEvaluation2.result {
////                        return (operation(operand,operand2),operationEvaluation2.remainingStack)
////                    }
////                }
////            }
////        }
////        return (nil,ops)
//    }

    func evaluate() -> Double? {
        guard let operand2 = operandStack.pop(),
              let operand1 = operandStack.pop(),
             let operation = operationStack.pop()
            else { return nil }
        
        return operation.operation(operand1.operand, operand2.operand)
    }

    func clearOutStacks() {
        operandStack.clear()
        operationStack.clear()
    }
    
    func evaluateAll() -> Double? {
        while !operationStack.isEmpty {
            guard let result = evaluate() else { break }
            operandStack.push(element: Operand(result))
        }
        let result = operandStack.pop()
        clearOutStacks()
        return result?.operand
    }
    
    func pushOperand(operand:Double) {
        operandStack.push(element: Operand(operand));
    }

    func performOperations(symbol:String) -> (result: Double?, errorOccured: Bool) {
        var result: Double?
        if let operation = knownOps[symbol] {
            while let previousOp = operationStack.top, previousOp.precedence >= operation.precedence {
                guard let evaluationResult = evaluate()
                else {   // Error in calculator
                    clearOutStacks()
                    return (result: nil, errorOccured: true)
                }
                result = evaluationResult
                operandStack.push(element: Operand(evaluationResult))
            }
            operationStack.push(element: operation)
        }
        return (result: result, errorOccured: false)
    }

}
