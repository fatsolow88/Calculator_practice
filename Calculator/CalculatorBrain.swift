//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Low Wai Hong on 29/06/2016.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

import Foundation


func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

/* MAGIC IN CLOSURE
VERSION 1
{(op1: Double, op2: Double) -> Double in
    return op1 * op2
}

VERSION 2
With inference, the function know it will take 2 double parameters
and return 1 double , so remove it
{(op1, op2) in return op1 * op2}

VERSION 3
Closure takes default argument, with a dollar sign $
{($0, $1) in return $3 * $4}

Closure also already knew the function will take default 2 passing parameters,
so we can omit that too
{return $3 * $4}

Closure also already knew the function will return a double parameter, so we can omit return too
{$3 * $4}
*/

class CalculatorBrain {

    private var accumulator = 0.0
    private var internalProgram = [AnyObject] ()
    private var description = ""
    private var isPartialResult = false

    func setOperand(operand: Double) {
        accumulator = operand
        print("setOperand\(accumulator)")
        internalProgram.append(operand)
    }

    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "±": Operation.UnaryOperation({ -$0 }), //unary will pass in only 1 paramater
        "cos" : Operation.UnaryOperation(cos),
        "x": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "−": Operation.BinaryOperation({$0 - $1}),
        "=": Operation.Equals
    ]

    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }

    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation (let function):
                accumulator = function(accumulator)
            case .BinaryOperation (let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(
                    binaryFunction: function,
                    firstOperand: accumulator)
                print("value after \(accumulator)")
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }

    private var pending: PendingBinaryOperationInfo?

    private func executePendingBinaryOperation() {
        if pending != nil {

            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
        }
    }

    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        //function can be assign as a value a form of data type
        var firstOperand: Double
    }

    typealias PropertyList = AnyObject

    var program: PropertyList {
        get {
            return internalProgram
        }

        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }

    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    var result: Double {
        return accumulator
    }
}
