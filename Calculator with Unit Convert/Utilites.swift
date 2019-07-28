//
//  Utilites.swift
//  Calculator + Unit Converter
//
//  Created by TaeYoun Kim on 7/21/19.
//  Copyright © 2019 TaeYoun Kim. All rights reserved.
//

import Foundation
import UIKit

/*
let OP_ACOLOR = "#FFC87EFF"
let OP_BCOLOR = "#FF9300FF"
let OP_TCOLOR = "#FFFFFFFF"
let NUM_ACOLOR = "#9D9D9DFF"
let NUM_BCOLOR = "#424242FF"
let NUM_TCOLOR = "#FFFFFFFF"
let OTHER_ACOLOR = "#E6E6E6FF"
let OTHER_BCOLOR = "#C0C0C0FF"
let OTHER_TCOLOR = "#000000FF"
let CONV_ACOLOR = "#DEF1FFFF"
let CONV_BCOLOR = "#0096FFFF"
let CONV_TCOLOR = "#FFFFFFFF"
//------------------------//
let MAIN_BCOLOR = "#00000000"
let MAIN_TCOLOR = "#FFFFFFFF"
let ANS_BCOLOR = "#00000000"
let ANS_TCOLOR = "#CCCCCCFF"
let SRC_BCOLOR = "#000000FF"
let SRC_TCOLOR = "#FFFFFFFF"
let TAR_BCOLOR = "#000000FF"
let TAR_TCOLOR = "#CCCCCCFF"
//------------------------//
let E_TCOLOR = "#0096FFFF"
//------------------------//
let SEL_ACOLOR = "#DEF1FFFF"
let SEL_BCOLOR = "#FF9300FF"
let SEL_TCOLOR = "#FFFFFFFF"
//------------------------//
let CELL_BCOLOR = "#DEF1FFFF" // background
let CELL_FCOLOR = "#0096FFFF" // foreground
let TABLE_BCOLOR = "#DEF1FFFF"
*/

class Utilities{
    static let MAX_COUNT = 9
    static let UPPER_LIMIT:Double = 1000000000
    static let LOWER_LIMIT:Double = 0.00000001
    
    static func hex2rgba(_ input: String) -> UIColor?{
        let r,g,b,a: CGFloat
        let start = input.index(input.startIndex, offsetBy: 1)
        let hexColor = String(input[start...])
        if(hexColor.count==8){
            let scanner = Scanner(string: hexColor)
            var hexNum: UInt64 = 0
            if(scanner.scanHexInt64(&hexNum)){
                r = CGFloat((hexNum & 0xff000000) >> 24) / 255
                g = CGFloat((hexNum & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNum & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNum & 0x000000ff) / 255
                return UIColor.init(red: r, green: g, blue: b, alpha: a)
            }
        }
        return nil
    }
    
    static func minimizeNum(input: String) -> String {
        if(Double(input) != nil){
            return minimizeNum(input: Double(input)!)
        }
        return input
    }
    
    static func minimizeNum(input: Double) -> String {
        let num = input
        let dec = floor(num)==num
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        if(num >= UPPER_LIMIT || (num < LOWER_LIMIT && num > 0)){
            fmt.maximumSignificantDigits = MAX_COUNT - 2
            fmt.numberStyle = .scientific
            return fmt.string(for: num)!
        }else{
            if(num<1){
                fmt.maximumFractionDigits = MAX_COUNT
            }else{
                fmt.maximumSignificantDigits = MAX_COUNT
            }
            if(dec){
                return fmt.string(for: Int(num))!
            }else{
                return fmt.string(for: num)!
            }
        }
    }
}
