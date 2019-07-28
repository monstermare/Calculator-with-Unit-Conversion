//
//  CalculatorAlgorithm.swift
//  Calculator + Unit Converter
//
//  Created by TaeYoun Kim on 7/22/19.
//  Copyright © 2019 TaeYoun Kim. All rights reserved.
//

import Foundation

enum InputType{
    case op
    case num
    case dot
    case enter
    case clear
    case change
}

class CalAlgorithm{
    let MAX_COUNT = 9
    let UPPER_LIMIT:Double = 1000000000
    let LOWER_LIMIT:Double = 0.00000001
    
    var state: Int
    
    var current: String
    
    var previous: String?
    
    var decimal: Bool
    var inActive: Bool
    
    var lc_operand: Double?
    var lc_operator: String?
    
    var activeOp: String?
    
    var newVal: Double?
    
    init(_ cur: Double = 0) {
        state = 0
        decimal = false
        inActive = false
        current = String(cur)
    }
    
    private func getNumCount(str: String) -> (Int,Int){
        var upper = 0
        var lower = 0
        var dec = false
        for c in str{ // 0-9 -ascii-> 48-57 , dot(.) = 46
            if let a = c.asciiValue{
                if(a>47 && a<58){
                    if(dec){
                        lower += 1
                    }else{
                        upper += 1
                    }
                }else if(a == 46){
                    dec = true
                }
            }
        }
        return (upper,lower)
    }
    
    func minimizeNum(input: Double) -> String {
        return Utilities.minimizeNum(input: String(input))
    }
    
    func getCurrentNum() -> String {
        return Utilities.minimizeNum(input: current)
    }
    
    func getPreviousNum() -> String? {
        if(previous != nil){
            return Utilities.minimizeNum(input: previous!)
        }
        return nil
    }
    
    func getInActiveOp() -> String? {
        if(inActive){
            return activeOp
        }
        return nil
    }
    
    func addInput(_ type: InputType,_ value: String){
        //print("state: \(state)\tinput: \(type)\tvalue: \(value)") // debugging purpose
        switch state {
        case 0:
            s0_init(type, value)
        case 1:
            s1_num(type, value)
        case 2:
            s2_op(type, value)
        case 3:
            s3_num(type, value)
        case 4:
            s4_cal(type, value)
        case 6:
            s6_op(type, value)
        case 7:
            s7_num(type, value)
        default:
            error()
        }
    }
    
    func addNum(_ num: String){
        if(Double(num) != nil){
            var max = MAX_COUNT
            if(current.contains("-")){max+=1}
            if(current.contains(".")){max+=1}
            if(current.count<max){
                if(current=="0"){
                    if(num != "0"){
                        current = num
                    }
                }else if(current=="-0"){
                    if(num != "0"){
                        current = "-"+num
                    }
                }else{
                    current += num
                }
            }
        }else{
            error()
        }
    }
    
    func addDot(){
        if(!decimal){
            current += "."
            decimal = true
        }
    }
    
    func setOp(_ input: String, _ active: Bool){
        activeOp = input
        inActive = active
    }
    
    func calculation(first: Double, second: Double, op: String) -> Double?{
        lc_operand = second
        lc_operator = op
        var cal: Double?
        switch op{ // op: plus, minus, multiply, divide, EE, power
        case "plus":
            cal = first + second
        case "minus":
            cal = first - second
        case "multiply":
            cal = first * second
        case "divide":
            if(second == 0){
                cal = nil
            }
            cal = first / second
        case "EE":
            cal = first * pow(10,second)
        case "power":
            cal = pow(first,second)
        default:
            cal = nil
        }
        if(cal == nil || cal == Double.infinity){
            return nil
        }
        return cal
    }
    
    func convNum(_ input: String){
        switch input {
        case "reverse":
            if(current.first=="-"){
                let range = current.index(after: current.startIndex)..<current.endIndex
                current = String(current[range])
            }else{
                current = "-"+current
            }
        case "percent":
            let f = Double(current)!
            let c = calculation(first: f, second: 100, op: "multiply")
            current = String(c!)
        case "reciprocal":
            if(Double(current) != 0){
                let f = Double(current)!
                let c = calculation(first: 1, second: f, op: "divide")
                current = String(c!)
            }
        case "converted":
            if let f = newVal{
                let c = calculation(first: 0, second: f, op: "plus")
                current = String(c!)
            }
        default:
            break
        }
    }
    
    func s0_init(_ type: InputType,_ value: String){
        current = "0"
        previous = nil
        decimal = false
        inActive = false
        activeOp = nil
        state = 1
        s1_num(type,value)
    }
    
    func s1_num(_ type: InputType,_ value: String){
        switch type {
        case .num:
            addNum(value)
        case .dot:
            addDot()
        case .op:
            setOp(value, true)
            state = 2
        case .enter:
            let cal = calculation(first: 0, second: Double(current)!, op: "plus")
            if(cal != nil){
                previous = current
                current = String(cal!)
                state = 4
            }else{
                error()
            }
        case .clear:
            state = 0
            s0_init(InputType.num, "0")
        case .change:
            convNum(value)
        }
    }
    
    func s2_op(_ type: InputType,_ value: String){
        switch type {
        case .num:
            inActive = false
            previous = current
            current = "0"
            decimal = false
            state = 3
            addInput(type, value)
        case .dot:
            inActive = false
            previous = current
            current = "0"
            decimal = false
            state = 3
            addInput(type, value)
        case .op:
            activeOp = value
        case .enter:
            let val = Double(current)!
            let cal = calculation(first: val, second: val, op: activeOp!)
            if(cal != nil){
                previous = current
                current = String(cal!)
                state = 4
            }else{
                error()
            }
        case .clear:
            if(previous != nil){
                current = previous!
                decimal = current.contains(".")
                previous = nil
            }
            activeOp = nil
            inActive = false
            state = 1
        case .change:
            convNum(value)
        }
    }
    
    func s3_num(_ type: InputType,_ value: String){
        switch type {
        case .num:
            addNum(value)
        case .dot:
            addDot()
        case .op:
            s5_cal(value)
        case .enter:
            let f = Double(previous!)!
            let s = Double(current)!
            let cal = calculation(first: f, second: s, op: activeOp!)
            if(cal != nil){
                previous = current
                current = String(cal!)
                state = 4
            }else{
                error()
            }
        case .clear:
            current = "0"
            decimal = false
            inActive = true
            state = 2
        case .change:
            convNum(value)
        }
    }
    
    func s4_cal(_ type: InputType,_ value: String){
        switch type {
        case .num:
            activeOp = nil
            previous = current
            current = "0"
            decimal = false
            state = 1
            addInput(type, value)
        case .dot:
            activeOp = nil
            previous = current
            current = "0"
            decimal = false
            state = 1
            addInput(type, value)
        case .op:
            activeOp = value
            inActive = true
            state = 6
        case .enter:
            if(activeOp != nil){
                if(lc_operand != nil && lc_operator != nil){
                    let f = Double(current)!
                    let cal = calculation(first: f, second: lc_operand!, op: lc_operator!)
                    if(cal != nil){
                        previous = current
                        current = String(cal!)
                    }
                }
            }
        case .clear:
            activeOp = nil
            previous = current
            decimal = false
            current = "0"
            state = 1
        case .change:
            convNum(value)
        }
    }
    
    func s5_cal(_ value: String){
        let f = Double(previous!)!
        let s = Double(current)!
        let cal = calculation(first: f, second: s, op: activeOp!)
        if(cal != nil){
            previous = current
            current = String(cal!)
            activeOp = value
            inActive = true
            state = 6
        }else{
            error()
        }
    }
    
    func s6_op(_ type: InputType,_ value: String){
        switch type {
        case .num:
            inActive = false
            previous = current
            current = "0"
            decimal = false
            state = 7
            addInput(type, value)
        case .dot:
            inActive = false
            previous = current
            current = "0"
            decimal = false
            state = 7
            addInput(type, value)
        case .op:
            activeOp = value
        case .enter:
            let f = Double(current)!
            let s = Double(previous!)!
            let cal = calculation(first: f, second: s, op: activeOp!)
            if(cal != nil){
                previous = current
                current = String(cal!)
                state = 4
            }else{
                error()
            }
        case .clear:
            inActive = false
            activeOp = nil
            state = 4
        case .change:
            convNum(value)
        }
    }
    
    func s7_num(_ type: InputType,_ value: String){
        switch type {
        case .num:
            addNum(value)
        case .dot:
            addDot()
        case .op:
            s5_cal(value)
        case .enter:
            let f = Double(previous!)!
            let s = Double(current)!
            let cal = calculation(first: f, second: s, op: activeOp!)
            if(cal != nil){
                previous = current
                current = String(cal!)
                state = 4
            }else{
                error()
            }
        case .clear:
            current = "0"
            decimal = false
            inActive = true
            state = 6
        case .change:
            convNum(value)
        }
    }
    
    func error(){
        current = "Undefined"
        state = 0
    }
}
