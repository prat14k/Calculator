//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Prateek Sharma on 6/6/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    static private let maxDigits = 15
    private let maxDigitsReachedError = (title: "Max digits Reached", message: "You are allowed to enter only \(maxDigits) digits at max")
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBOutlet private var inputButtons: [UIButton]!
    
    @IBOutlet weak private var inputTextField: UITextField!
    @IBOutlet weak private var decimalButton: UIButton!
    @IBOutlet private var operationButtons: [UIButton]!
    
    private var isTyping = false
    
    private var calciModel = CalculatorModel()
    
    private var isDecimalButtonEnabled = true {
        didSet {
            decimalButton.isEnabled = isDecimalButtonEnabled
            decimalButton.alpha = isDecimalButtonEnabled ? 1 : 0.7
        }
    }
    
    
    private func updateOperationButtonsAlpha() {
        for button in operationButtons {
            button.alpha = 1
        }
    }
    
    private var displayValue : Double{
        get{
            return Double(inputTextField.text!) ?? 0
        }
        set {
            inputTextField.text = "\(newValue)"
            isTyping = false
            isDecimalButtonEnabled = true
        }
    }

    private func pushOperation(symbol: String) -> Bool {
        let result = calciModel.performOperations(symbol: symbol)
        if !result.errorOccured {
            isTyping = false
            isDecimalButtonEnabled = true
            if let output = result.output {
                displayValue = output
            }
        }
        else {
            displayValue = 0
            return false
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setButtonsCircular()
    }
    
    func setButtonsCircular() {
        for button in inputButtons {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = button.frame.size.height / 2.0
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setButtonsCircular()
    }
}

extension CalculatorViewController {
    
    @IBAction private func digitsPressAction(_ sender: UIButton) {
        let text = isTyping ? inputTextField.text! + sender.currentTitle! : sender.currentTitle!
        guard text.count < CalculatorViewController.maxDigits
        else {
                return presentAlert(title: maxDigitsReachedError.title, message: maxDigitsReachedError.message)
        }
        inputTextField.text = text
        isTyping = true
    }
    
    @IBAction private func decimalPressAction(_ sender: UIButton) {
        inputTextField.text = isTyping ? inputTextField.text! + "." : "0."
        isTyping = true
        isDecimalButtonEnabled = false
    }
    
    @IBAction private func operateAction(_ sender: UIButton) {
        updateOperationButtonsAlpha()
        isTyping ? calciModel.pushOperand(operand: displayValue) : ()
        guard let operationSymbol = sender.currentTitle  else { return }
        sender.alpha = pushOperation(symbol: operationSymbol) ? 0.7 : 1
    }
    
    @IBAction private func enterAction() {
        updateOperationButtonsAlpha()
        calciModel.pushOperand(operand: displayValue)
        displayValue = calciModel.evaluateAll() ?? 0
    }
    
    @IBAction private func clearAllOperations() {
        displayValue = 0
    }
    
}

