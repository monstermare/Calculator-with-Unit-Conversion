//
//  CalculatorComponents.swift
//  Calculator + Unit Converter
//
//  Created by TaeYoun Kim on 7/21/19.
//  Copyright © 2019 TaeYoun Kim. All rights reserved.
//

import Foundation
import UIKit


enum ButtonType{
    case select
    case num
    case op
    case enter
    case clear
    case change
    case dot
    case conv
}

// COMPONENTS

class CalLabel{
    private let label: UILabel
    
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var height: CGFloat
    
    private var bcolor: UIColor
    private var tcolor: UIColor
    
    private var title: String?
    private var fontSize: CGFloat = 15
    private var align: NSTextAlignment = .left
    
    private var textAutoResize = false
    
    public private(set) var value: String?
    public private(set) var tag: Int = 0
    
    init(x: CGFloat = 1, y: CGFloat = 1, w: CGFloat = 1, h: CGFloat = 1){
        self.x = x-(w/2)
        self.y = y-(h/2)
        width = w
        height = h
        label = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        bcolor = .clear
        tcolor = .black
    }
    
    func setFrame(x: CGFloat?, y: CGFloat?, w: CGFloat?, h: CGFloat?){
        if(w != nil){width = w!}
        if(h != nil){height = h!}
        if(x != nil){self.x = x!-(width/2)}
        if(y != nil){self.y = y!-(height/2)}
        if(x != nil || y != nil || w != nil || h != nil){
            label.frame = CGRect(x: self.x, y: self.y, width: width, height: height)
        }
    }
    
    func setFrameCenterPos(x: CGFloat?, y: CGFloat?){
        if(x != nil){ self.x = x! }
        if(y != nil){ self.y = y! }
        label.center.x = self.x
        label.center.y = self.y
    }
    
    func setFramePos(x: CGFloat?, y: CGFloat?){
        if(x != nil){
            self.x = x!
        }
        if(y != nil){
            self.y = y!
        }
        label.frame = CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
    }
    
    func addGesture(_ gesture: UIGestureRecognizer){
        if(!label.isUserInteractionEnabled){ label.isUserInteractionEnabled = true }
        label.addGestureRecognizer(gesture)
    }
    
    func setValue(_ value: String?){
        self.value = value
    }
    
    func setTag(_ tag: Int){
        self.tag = tag
    }
    
    func setCornerRadius(r: CGFloat, base: CGFloat? = nil){
        var b = width
        if(height<width){b = height}
        if(base != nil){b = base!}
        if(!label.layer.masksToBounds) { label.layer.masksToBounds = true }
        label.layer.cornerRadius = r * b
    }
    
    func setFontSize(_ size: CGFloat,_ style: String = "system"){
        fontSize = size
        switch style {
        case "bold":
            label.font = UIFont.boldSystemFont(ofSize: fontSize)
        case "italic":
            label.font = UIFont.italicSystemFont(ofSize: fontSize)
        default:
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    func setTitle(_ title: String, _ state: UIControl.State = .normal){
        self.title = title
        label.text = title
    }
    
    func setBackgroundAlpha(_ value: CGFloat){
        label.alpha = value
    }
    
    func setHighlightedTitle(title: String, highlighted: String, color: UIColor){
        if(title.contains(highlighted)){
            self.title = title
            let range = (title as NSString).range(of: highlighted)
            let attribute = NSMutableAttributedString.init(string: title)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
            label.attributedText = attribute
        }
    }
    
    func setHighlightedTitleByHex(title: String, highlighted: String, hex: String){
        if let color = Utilities.hex2rgba(hex){
            setHighlightedTitle(title: title, highlighted: highlighted, color: color)
        }
    }
    
    func setTextAlign(_ align: NSTextAlignment){
        self.align = align
        label.textAlignment = align
    }
    
    func setAutoTextResize(_ bool: Bool){
        textAutoResize = bool
        label.adjustsFontSizeToFitWidth = bool
    }
    
    func setBackgroundColor(_ color: UIColor){
        label.backgroundColor = color
    }
    
    func setFontColor(_ color: UIColor){
        label.textColor = color
    }
    
    func isHidden(_ bool:Bool){
        label.isHidden = bool
    }
    
    func setBackGroundColorByHex(_ hex: String){
        let color = Utilities.hex2rgba(hex)
        label.backgroundColor = color
    }
    
    func setFontColorByHex(_ hex: String){
        let color = Utilities.hex2rgba(hex)
        label.textColor = color
    }
    
    func showLabel(_ view: UIView){
        view.addSubview(label)
    }
    
    func getRefLabel() -> UILabel {
        return self.label
    }
    
    func getTitle() -> String{
        if(title != nil){
            return title!
        }
        return ""
    }
}

class CalButton{
    private let type: ButtonType
    private let button: UIButton
    
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var height: CGFloat
    
    public private(set) var bcolor: UIColor
    public private(set) var tcolor: UIColor
    public private(set) var acolor: UIColor?
    
    private var textAutoResize = false
    
    private var title: String?
    private var fontSize: CGFloat = 15
    
    public private(set) var value: String?
    public private(set) var tag: Int = 0
    
    init(_ t: ButtonType, x: CGFloat = 1, y: CGFloat = 1, w: CGFloat = 1, h: CGFloat = 1) {
        type = t
        self.x = x-(w/2)
        self.y = y-(h/2)
        width = w
        height = h
        button = UIButton(frame: CGRect(x:x,y:y,width:w,height:h))
        bcolor = UIColor.white
        tcolor = UIColor.white
    }
    
    // This sets position of button with given points
    // notes that x and y are recalculated to be centered
    // x and y must be calculated after w and h are updated
    func setFrame(x: CGFloat?, y: CGFloat?, w: CGFloat?, h: CGFloat?){
        if(w != nil){width = w!}
        if(h != nil){height = h!}
        if(x != nil){self.x = x!-(width/2)}
        if(y != nil){self.y = y!-(height/2)}
        if(x != nil || y != nil || w != nil || h != nil){
            button.frame = CGRect(x: self.x, y: self.y, width: width, height: height)
        }
    }
    
    func setFrameCenterPos(x: CGFloat?, y: CGFloat?){
        if(x != nil){ self.x = x! }
        if(y != nil){ self.y = y! }
        button.center.x = self.x
        button.center.y = self.y
    }
    
    func setFramePos(x: CGFloat?, y: CGFloat?){
        if(x != nil){
            self.x = x!
        }
        if(y != nil){
            self.y = y!
        }
        button.frame = CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
    }
    
    func setCornerRadius(r: CGFloat, base: CGFloat? = nil){
        var b = width
        if(height<width){b = height}
        if(base != nil){b = base!}
        button.layer.cornerRadius = r * b
    }
    
    func setValue(_ value: String?){
        self.value = value
    }
    
    func setTag(_ tag: Int){
        self.tag = tag
    }
    
    func setFontSize(_ size: CGFloat){
        fontSize = size
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    func setTitle(_ title: String, _ state: UIControl.State = .normal){
        self.title = title
        button.setTitle(title, for: state)
    }
    
    func setAutoTextResize(_ bool: Bool){
        textAutoResize = bool
        button.titleLabel?.adjustsFontSizeToFitWidth = bool
    }
    
    func setAnimationColor(_ color: UIColor){
        acolor = color
    }
    
    func setAnimationColorByHex(_ hex: String){
        let color = Utilities.hex2rgba(hex)
        if(color != nil){
            acolor = color!
        }
    }
    
    func setBackgroundColor(_ color: UIColor){
        bcolor = color
        button.backgroundColor = color
    }
    
    func setBackGroundColorByHex(_ hex: String){
        let color = Utilities.hex2rgba(hex)
        if(color != nil){
            bcolor = color!
            button.backgroundColor = color!
        }
    }
    
    func setFontColor(_ color: UIColor, _ state: UIControl.State = .normal){
        tcolor = color
        button.setTitleColor(color, for: state)
    }
    
    func setFontColorByHex(_ hex: String, _ state: UIControl.State = .normal){
        let color = Utilities.hex2rgba(hex)
        if(color != nil){
            tcolor = color!
            button.setTitleColor(color!, for: state)
        }
    }
    
    func addTarget(target: Any?, selector: Selector, event: UIControl.Event){
        button.addTarget(target, action: selector, for: event)
    }
    
    func showButton(_ view: UIView){
        view.addSubview(button)
    }
    
    func isHidden(_ bool:Bool){
        button.isHidden = bool
    }
    
    func addTarget(_ target: Any?, action: Selector, event: UIControl.Event){
        button.addTarget(target, action: action, for: event)
    }
    
    func addBackgroundColorAnimation(cg: CGColor? = nil ,dur: CFTimeInterval){
        var color: CGColor? = acolor?.cgColor
        if(cg != nil){ color = cg! }
        if(color != nil){
            let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
            colorAnimation.fromValue = color
            colorAnimation.duration = dur
            button.layer.add(colorAnimation, forKey: "ColorPulse")
        }
    }
    
    func getRefButton() -> UIButton {
        return self.button
    }
    
    func getButtonType() -> ButtonType {
        return self.type
    }
}

class TableView{
    private let table: UITableView
    
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var height: CGFloat
    
    public private(set) var bcolor: UIColor
    public private(set) var scolor: UIColor
    
    public private(set) var value: String?
    public private(set) var tag: Int = 0
    
    init(x: CGFloat = 1, y: CGFloat = 1, w: CGFloat = 1, h: CGFloat = 1) {
        self.x = x-(w/2)
        self.y = y-(h/2)
        width = w
        height = h
        bcolor = Utilities.hex2rgba(COLOR_A1)!
        scolor = Utilities.hex2rgba(COLOR_A1)!
        table = UITableView(frame: CGRect(x:x,y:y,width:w,height:h))
        table.backgroundColor = bcolor
        table.separatorColor = scolor
    }
    
    func setExtension(_ view: ViewController){
        table.delegate = view as UITableViewDelegate
        table.dataSource = view as UITableViewDataSource
    }
    
    func setFrame(x: CGFloat?, y: CGFloat?, w: CGFloat?, h: CGFloat?){
        if(w != nil){width = w!}
        if(h != nil){height = h!}
        if(x != nil){self.x = x!-(width/2)}
        if(y != nil){self.y = y!-(height/2)}
        if(x != nil || y != nil || w != nil || h != nil){
            table.frame = CGRect(x: self.x, y: self.y, width: width, height: height)
        }
    }
    
    func setFrameCenterPos(x: CGFloat?, y: CGFloat?){
        if(x != nil){ self.x = x! }
        if(y != nil){ self.y = y! }
        table.center.x = self.x
        table.center.y = self.y
    }
    
    func setFramePos(x: CGFloat?, y: CGFloat?){
        if(x != nil){
            self.x = x!
        }
        if(y != nil){
            self.y = y!
        }
        table.frame = CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
    }
    
    func setCornerRadius(r: CGFloat, base: CGFloat? = nil){
        var b = width
        if(height<width){b = height}
        if(base != nil){b = base!}
        table.layer.cornerRadius = r * b
    }
    
    func setValue(_ value: String?){
        self.value = value
    }
    
    func setTag(_ tag: Int){
        self.tag = tag
    }
    
    func setRegister(_ cellClass: AnyClass?, forCellReuseIdentifier: String){
        table.register(cellClass, forCellReuseIdentifier: forCellReuseIdentifier)
    }
    
    func setCell(withIdentifier: String, indexPath: IndexPath) -> TableViewCell{
        let cell = table.dequeueReusableCell(withIdentifier: withIdentifier, for: indexPath) as! TableViewCell
        return cell
    }
    
    func setBackgroundColor(_ color: UIColor){
        bcolor = color
        table.backgroundColor = color
    }
    
    func setBackgroundColorByHex(_ hex: String){
        if let color = Utilities.hex2rgba(hex){
            bcolor = color
            table.backgroundColor = color
        }
    }
    
    func refreshTable(row: Int = 0, section: Int = 0, animated: Bool = false){
        table.reloadData()
        table.scrollToRow(at: IndexPath(row: row, section: section), at: .top, animated: animated)
    }
    
    func showTable(_ view: UIView){
        view.addSubview(table)
    }
    
    func isHidden(_ bool:Bool){
        table.isHidden = bool
    }
    
    func getRefTable() -> UITableView {
        return self.table
    }
}
