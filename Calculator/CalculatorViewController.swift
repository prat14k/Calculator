//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Prateek Sharma on 6/6/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    let maxDigits = 25
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    @IBOutlet weak var inputTextField: UITextField!
    
    var isTyping = false
    
    @IBAction func digitsPressAction(_ sender: UIButton) {
        let digit = sender.currentTitle!
        inputTextField.text = isTyping ? inputTextField.text! + digit : digit
        isTyping = true
    }
    
    var calciModel = CalculatorModel()
    
    @IBAction func operateAction(_ sender: UIButton) {
        
        print(calciModel.operationStack)
        print(calciModel.operandStack)
        if isTyping {
            calciModel.pushOperand(operand: displayValue)
        }
        
        print(calciModel.operationStack)
        print(calciModel.operandStack)
        
        if let operation = sender.currentTitle{
            let result = calciModel.performOperations(symbol: operation)
            if !result.errorOccured {
                if let res = result.result { displayValue = res }
            }
            else {
                displayValue = 0
            }
        }
        
        print(calciModel.operationStack)
        print(calciModel.operandStack)
    }
    
    
    
    
    @IBAction func enterAction() {
        isTyping = false
        
        
        print(calciModel.operationStack)
        print(calciModel.operandStack)
        
        calciModel.pushOperand(operand: displayValue)
        
        
        print(calciModel.operationStack)
        print(calciModel.operandStack)
        
        if let result = calciModel.evaluateAll() {
            displayValue = result
        }
        else{
            displayValue = 0
            
        }
        
        print(calciModel.operationStack)
        print(calciModel.operandStack)
    }
    var displayValue : Double{
        get{
            return Double(inputTextField.text!)!
        }
        set{
            inputTextField.text = "\(newValue)"
            isTyping = false
        }
    }
    
    @IBAction func clearAllOperations() {
        inputTextField.text = "0"
    }
    
}

