//
//  ViewController.swift
//  Calculator
//
//  Created by Low Wai Hong on 17/06/2016.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!

    private var userIsInTheMiddleOfTyping = false

    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }

    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }

        set {
            display.text = String(newValue)
        }
    }

    private var brain = CalculatorBrain()

    var savedProgram: CalculatorBrain.PropertyList?

    @IBAction func Save() {
        savedProgram = brain.program
    }
    @IBAction func Restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue) //if no value, no need to set operand
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
}
