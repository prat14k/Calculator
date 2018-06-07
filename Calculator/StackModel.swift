//
//  StackModel.swift
//  Calculator
//
//  Created by Prateek Sharma on 6/7/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import Foundation

struct Stack<T> {
    private var collection = [T]()
    
    var isEmpty: Bool { return count == 0 }
    var top: T? { return collection.last }
    var count: Int { return collection.count }
}
extension Stack {
    mutating func pop() -> T? {
        return !isEmpty ? collection.removeLast() : nil
    }
    mutating func clear() {
        collection.removeAll()
    }
    mutating func push(element: T) {
        collection.append(element)
    }
}


typealias Operand = Double

struct Operation {
    let precedence: Int
    let operation: (Double,Double)->Double
}
