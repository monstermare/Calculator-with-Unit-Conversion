//
//  ViewController.swift
//  Calculator with Unit Convert
//
//  Created by TaeYoun Kim on 7/26/19.
//  Copyright © 2019 TaeYoun Kim. All rights reserved.
//

import UIKit


let COLOR_A1 = "#4cb1e0FF" // conv_button, E sign, selector cells
let COLOR_A2 = "#FFFFFFFF" // font color
let COLOR_A3 = "#cfeefcFF" // animation color
let COLOR_A4 = "#79d3fcFF"
let COLOR_B1 = "#8fcf70FF" // op_button, unit sign, selector
let COLOR_B2 = "#FFFFFFFF"
let COLOR_B3 = "#e4ffd6FF"
let COLOR_C1 = "#C9C9C9FF" // num button
let COLOR_C2 = "#2B2B2BFF"
let COLOR_C3 = "#F0F0F0FF"
let COLOR_D1 = "#8F8F8FFF" // other buttons
let COLOR_D2 = "#FFFFFFFF"
let COLOR_D3 = "#F0F0F0FF"
let COLOR_E1 = "#FFFFFFFF" // main, target
let COLOR_E2 = "#CCCCCCFF" // ans, source
let COLOR_E3 = "#999999FF" // cell table background
let COLOR_E4 = "#2B2B2BFF" // background color

let MAX_HISTORY_LIST: Int16 = 5 // size of history stack

class ViewController: UIViewController {
    // ::::CONSTANTS::::
    // essential constants
    let SCREEN_MAXHEIGHT = UIScreen.main.bounds.height
    let SCREEN_MAXWIDTH = UIScreen.main.bounds.width
    let BACKGROUND_COLOR = Utilities.hex2rgba("#2B2B2BFF")
    //------------------------//
    let SAVED_CURRENCY_KEY = "CURRENCYLIBRARY"
    //------------------------//
    let OP_BCOLOR = COLOR_B1
    let OP_TCOLOR = COLOR_B2
    let OP_ACOLOR = COLOR_B3
    let NUM_BCOLOR = COLOR_C1
    let NUM_TCOLOR = COLOR_C2
    let NUM_ACOLOR = COLOR_C3
    let OTHER_BCOLOR = COLOR_D1
    let OTHER_TCOLOR = COLOR_D2
    let OTHER_ACOLOR = COLOR_D3
    let CONV_BCOLOR = COLOR_A1
    let CONV_TCOLOR = COLOR_A2
    let CONV_ACOLOR = COLOR_A3
    //------------------------//
    let MAIN_BCOLOR = COLOR_E4
    let MAIN_TCOLOR = COLOR_E1
    let ANS_BCOLOR = COLOR_E4
    let ANS_TCOLOR = COLOR_E2
    let SRC_BCOLOR = COLOR_E4
    let SRC_TCOLOR = COLOR_E1
    let TAR_BCOLOR = COLOR_E4
    let TAR_TCOLOR = COLOR_E2
    //------------------------//
    let E_TCOLOR = COLOR_A1
    //------------------------//
    let SEL_BCOLOR = COLOR_B1
    let SEL_TCOLOR = COLOR_B2
    let SEL_ACOLOR = COLOR_B3
    //------------------------//
    let CELL_BCOLOR = COLOR_A1 // background
    let CELL_FCOLOR = COLOR_A2 // foreground
    let TABLE_BCOLOR = COLOR_A1
    let MSG_BCOLOR = COLOR_D1
    let MSG_TCOLOR = COLOR_E1
    //------------------------//
    let BUTTON_FONT_SIZE: CGFloat = 25
    let MAIN_FONT_SIZE: CGFloat = 95
    let ANS_FONT_SIZE: CGFloat = 40
    let MSG_FONT_SIZE: CGFloat = 25
    //------------------------//
    let ANIMATION_BC_INTERVAL: CFTimeInterval = 1
    //------------------------//
    let CELL_ID = "Cell_ID"
    let SELECT_SOURCE_DEFAULT = "Select Source Unit"
    let SELECT_TARGET_DEFAULT = "Select Target Unit"
    let PREVIOUS_BUTTON = "⬅︎ Previous"
    let CONV_MODE_BACK_BUTTON = "⬅︎"
    
    // size of grid
    let MAX_ROW = 4
    let MAX_COL = 6
    
    // constrants of button's attribute
    let BOX_SIZE: Float = 0.85
    let BAK_SIZE: Float = 0.55
    let BOX_ROUND: Float = 0.3 //0.40625
    let SEL_ROUND: Float = 0.3
    let TABLE_ROUND: Float = 0.0625
    let MSG_ROUND: Float = 0.125
    let MSG_DUR: TimeInterval = 1
    
    // ::::VARIABLES:::
    // system preference
    var statusBarStyle:UIStatusBarStyle = .lightContent
    
    // views
    var calculatorView = UIView()
    var converterView = UIView()
    var tableView = UIView()
    
    // switch
    var safeInit = false
    var shorten = false // iphone X-like -> false, iphone 8-like -> true
    var isTableMode = false
    var sourceSelected = false
    var tableSelected = true // false = target / true = source
    var currencyLoaded = false
    
    // safeArea
    var safeLeft: CGFloat = 0
    var safeRight: CGFloat = 0
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    
    // the angular points of the display
    var sx: CGFloat = 0
    var sy: CGFloat = 0
    var ex: CGFloat = UIScreen.main.bounds.width
    var ey: CGFloat = UIScreen.main.bounds.height
    
    // table init pos
    var tablePos: (open:CGFloat,close:CGFloat)?
    
    // view swipe
    var calCenterX: CGFloat?
    var convCenterX: CGFloat?
    
    // extensions
    var cell_size: Int = 0
    var cell_height: CGFloat = 75
    var cell_group: Array<String>?
    
    // conversion table selections
    var tableSection: String?
    var sourceUnit: String?
    var targetUnit: String?
    
    // factors
    var segXFactor: CGFloat = 8
    var segYFactor: CGFloat = 8
    var boxSizeFactor: CGFloat = 1
    var mainXFactor: CGFloat = 0.5
    var mainWidthFactor: CGFloat = 0.9
    var mainHeightFactor: CGFloat = 1.8
    var ansXFactor: CGFloat = 0.5
    var ansYFactor: CGFloat = 1.8
    var ansWidthFactor: CGFloat = 0.88
    var ansHeightFactor: CGFloat = 1
    var labelFontSizeFactor: CGFloat = 1
    var selectorWidthFactor: CGFloat = 0.9
    var selectorHeightFactor: CGFloat = 0.15
    var selectorYFactor: CGFloat = 0.09
    var backFactor: CGFloat = 9
    var tableXFactor: CGFloat = 0.5
    var tableYFactor: CGFloat = 0.7
    var tableWidthFactor: CGFloat = 0.95
    var tableHeightFactor: CGFloat = 0.8
    var sourceXFactor: CGFloat = 1.8
    var sourceWidthFactor: CGFloat = 0.7
    var sourceHeightFactor: CGFloat = 1.3
    var sourceYFactor: CGFloat = 1.1
    var targetHeightFactor: CGFloat = 2.2
    var targetYFactor: CGFloat = 1.1
    var msgBoxXFactor: CGFloat = 0.5
    var msgBoxYFactor: CGFloat = 0.4
    var msgBoxWidthFactor: CGFloat = 0.65
    var msgBoxHeightFactor: CGFloat = 0.15
    var historyYFactor: CGFloat = 2.25
    var historyWidthFactor: CGFloat = 0.9
    var historyHeightFactor: CGFloat = 0.06
    var historyGapFactor: CGFloat = 1.5
    
    // arrays & dict
    var grid: [[(CGFloat,CGFloat)]] = []
    var cell: [[CalButton?]] = []
    var nums = Array<CalButton>()
    var others: [String:CalButton] = [:]
    var labels = Array<CalLabel>()
    var selects = Array<CalButton>()
    var history = Array<(label: CalLabel,info: convertedHistory)>()
    
    // ref
    var btnDict: [UIButton:CalButton] = [:]
    
    // algorithm
    let calAlg = CalAlgorithm()
    
    // history
    var prevUnitType: String?
    var prevSource: String?
    var prevTarget: String?
    
    // conv unit dict
    var conv_menu = UnitConvLibrary()
    
    //other
    var highlighted: CalButton?
    var backToCal: CalButton?
    var table: TableView?
    var msgBox: CalLabel?
    var tarValue: Double?
    var curLibrary: ParsedCurrency?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initType()
        initView()
        initOthers()
        initButtons()
        initLabels()
        initConvButtons()
        initConvTables()
        activateButtons()
        self.view.backgroundColor = BACKGROUND_COLOR
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!safeInit){initSafe(view.safeAreaInsets)}
    }
    
    func addHistory(_ unitType: String,_ source: String,_ target: String){
        let info = convertedHistory(index: 0, source: source, target: target, unitType: unitType)
        var indicator = MAX_HISTORY_LIST
        var newWritten = false
        history.forEach { h in
            if(h.info==info) {
                indicator = h.info.index
            }
        }
        for (i,h) in history.enumerated(){
            if(h.info.index>=0){
                if(h.info.index==indicator){
                    history[i].info = convertedHistory(index: -1, source: "", target: "", unitType: "")
                    setHistoryCell(i, h.info.index+1, false)
                }else if(h.info.index<indicator){
                    let j = h.info.index+1
                    if(j>=MAX_HISTORY_LIST){
                        history[i].info = convertedHistory(index: -1, source: "", target: "", unitType: "")
                        setHistoryCell(i, j, false)
                    }else{
                        history[i].info.setIndex(h.info.index+1)
                        setHistoryCell(i, j, true)
                    }
                }
            }else if(!newWritten){
                history[i].info = info
                setHistoryCell(i,0, true)
                newWritten = true
            }
        }
        
    }
    
    func setHistoryCell(_ index: Int, _ pos: Int16, _ show: Bool){
        var y = (ey-sy)/segYFactor*(historyYFactor)
        let label = history[index].label
        var alpha: CGFloat = 0
        if(show) { alpha = 1 }
        y += (ey-sy)*historyHeightFactor*historyGapFactor*CGFloat(pos)
        label.setFrame(x: nil, y: y, w: nil, h: nil)
        y = (ey-sy)*historyHeightFactor*historyGapFactor
        UIView.animate(withDuration: 1.25, delay: 0.25, options: .transitionCrossDissolve, animations: {
            label.setBackgroundAlpha(alpha)
            label.getRefLabel().center.y += y
        })
    }
    
    func loadData(){
        //currency loading
        let currencies = getCurrencyFromDB()
        let today = {() -> String in
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            return f.string(from: Date())
        }()
        if(currencies != [] && currencies[0].date == today){
            let base = currencies[0].base
            let date = currencies[0].date
            var rates: [String:Double] = [:]
            currencies.forEach { c in
                rates[c.country] = c.rate
            }
            let pc = ParsedCurrency(date: date, rates: rates, base: base)
            let title = "Currency (\(date))"
            self.curLibrary = pc
            self.currencyLoaded = true
            self.conv_menu.setCurrencyLibrary(pc,title)
            conv_menu.setCurrencyLibrary(curLibrary!, title)
        }
    }
    
    @objc func buttonClicked(_ sender: UIButton){
        let button = btnDict[sender]
        if(button != nil){
            calProgress(button!)
        }
    }
    
    @objc func backButtonClicked(_ sender: UIButton){
        if(sender === backToCal?.getRefButton()){
            convertMode(true)
            backToCal!.addBackgroundColorAnimation(cg: nil, dur: ANIMATION_BC_INTERVAL)
        }
    }
    
    @objc func selectorClicked(_ sender: UIButton){
        var button: CalButton?
        if(sender === selects[0].getRefButton() && tableSection != nil){ // target
            popSelectBar(false)
            button = selects[0]
        }else if(sender === selects[1].getRefButton()){ // source
            popSelectBar(true)
            button = selects[1]
        }
        if button != nil{
            button!.addBackgroundColorAnimation(cg: nil, dur: ANIMATION_BC_INTERVAL)
        }
    }
    
    @objc func converterBackgroundClicked(_ sender: UITapGestureRecognizer){
        if(isTableMode){
            tableMode(false)
        }
    }
    
    @objc func labelValueClicked(_ sender: UITapGestureRecognizer){
        if(sender.state == UIGestureRecognizer.State.began){
            var copied = false
            var value: String = ""
            if(sender.view === labels[0].getRefLabel()){
                copied = true
                value = labels[0].getTitle()
            }else if(sender.view === labels[3].getRefLabel() && sourceUnit != nil && tableSection != nil){
                value = labels[1].getTitle()
                copied = true
            }else{
                for h in history{
                    if(h.info.index > -1 && h.label.getRefLabel() === sender.view){
                        copied = true
                        value = h.label.value!
                        break
                    }
                }
            }
            if(copied){
                copyValueToClipboard(value)
                msgBox?.setTitle("Value Copied!")
                msgBox?.setBackgroundAlpha(0.75)
                UIView.animate(withDuration: 1.25, delay: 0.25, options: .transitionCrossDissolve, animations: {
                    self.msgBox!.setBackgroundAlpha(0)
                })
            }
            
        }
    }
    
    @objc func targetValueClicked(_ sender: UITapGestureRecognizer){
        if(sender.view === labels[3].getRefLabel() && sourceUnit != nil && tableSection != nil && tarValue != nil){
            calAlg.newVal = tarValue!
            calAlg.addInput(.change, "converted")
            convertMode(true)
        }else{
            
        }
    }
    
    @objc func swipeView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: sender.view)
        let isCal: Bool = sender.view === calculatorView
        let x = translation.x
        if(sender.state == .began){
            updateLabels()
            calCenterX = calculatorView.center.x
            convCenterX = converterView.center.x
        }else if(sender.state == .ended){
            let newCalX: CGFloat
            let newConvX: CGFloat
            if(-x > SCREEN_MAXWIDTH/2 && isCal){ // move to other state
                //newCalX = calCenterX! - SCREEN_MAXWIDTH
                //newConvX = convCenterX! - SCREEN_MAXWIDTH
                newCalX = (SCREEN_MAXWIDTH/2) - SCREEN_MAXWIDTH
                newConvX = (SCREEN_MAXWIDTH/2)
            }else if(x > SCREEN_MAXWIDTH/2 && !isCal){
                //newCalX = calCenterX! + SCREEN_MAXWIDTH
                //newConvX = convCenterX! + SCREEN_MAXWIDTH
                newCalX = (SCREEN_MAXWIDTH/2)
                newConvX = (SCREEN_MAXWIDTH/2) + SCREEN_MAXWIDTH
            }else{ // back to original state
                newCalX = calCenterX!
                newConvX = convCenterX!
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self.calculatorView.center.x = newCalX
                self.converterView.center.x = newConvX
            }, completion: nil)
        }else if( (x<0 && isCal) || (x>0 && !isCal)){
            guard let cal = calCenterX else { return }
            guard let conv = convCenterX else { return }
            calculatorView.center.x = cal + x
            converterView.center.x = conv + x
        }
    }
    
    func copyValueToClipboard(_ str: String){
        let board = UIPasteboard.general
        board.string = str
    }
    
    func popSelectBar(_ source: Bool){
        if(source){
            tableSelected = true
            if let type = tableSection{ // if section page is selected
                cell_group = conv_menu.getUnitTitles(type)
            }else{
                cell_group = conv_menu.getUnitTypeTitles()
            }
            if(cell_group != nil){
                if(tableSection != nil){
                    cell_group!.insert(PREVIOUS_BUTTON, at: 0)
                }
                cell_size = cell_group!.count
            }else{
                cell_size = 0
            }
        }else{
            tableSelected = false
            cell_group = conv_menu.getUnitTitles(tableSection!)
            if let cg = cell_group{
                cell_size = cg.count
            }else{
                cell_size = 0
            }
        }
        tableMode(true)
        table!.refreshTable()
    }
    
    func tableMode(_ open: Bool){
        isTableMode = open
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            if(open){
                self.table!.setFrame(x: nil, y: self.tablePos?.open, w: nil, h: nil)
                self.tableView.center.y -= self.SCREEN_MAXHEIGHT
            }else{
                self.table!.setFrame(x: nil, y: self.tablePos?.close, w: nil, h: nil)
                self.tableView.center.y += self.SCREEN_MAXHEIGHT
            }
            
        }, completion: nil)
        updateSelectLabel()
    }
    
    func updateSelectLabel(){
        if(sourceUnit != nil && tableSection != nil){
            selects[1].setTitle(sourceUnit!)
        }else{
            selects[1].setTitle(SELECT_SOURCE_DEFAULT)
        }
        if(targetUnit != nil && tableSection != nil){
            selects[0].setTitle(targetUnit!)
        }else{
            selects[0].setTitle(SELECT_TARGET_DEFAULT)
        }
    }
    
    func initSafe(_ view: UIEdgeInsets){
        safeLeft = view.left
        safeRight = view.right
        safeTop = view.top
        safeBottom = view.bottom
        safeInit = true
        sx = safeLeft
        sy = safeTop
        ex = SCREEN_MAXWIDTH - safeRight
        ey = SCREEN_MAXHEIGHT - safeBottom
        initGrid()
        initButtons()
        initLabels()
        initConvButtons()
        initConvTables()
        initOthers()
    }
    
    func initType(){
        shorten = !(SCREEN_MAXHEIGHT>2*SCREEN_MAXWIDTH) // check the screen ratio and set it true if device is iphone X series
        if(shorten){
            segYFactor = 9
            boxSizeFactor = 0.95
            labelFontSizeFactor = 0.85
            tableHeightFactor = 0.70
        }
    }
    
    func initView(){
        self.view.addSubview(converterView)
        self.view.addSubview(calculatorView)
        self.view.addSubview(tableView)
        converterView.frame = CGRect(x: SCREEN_MAXWIDTH, y: 0, width: SCREEN_MAXWIDTH, height: SCREEN_MAXHEIGHT)
        calculatorView.frame = CGRect(x: 0, y: 0, width: SCREEN_MAXWIDTH, height: SCREEN_MAXHEIGHT)
        tableView.frame = CGRect(x: 0, y: SCREEN_MAXHEIGHT, width: SCREEN_MAXWIDTH, height: SCREEN_MAXHEIGHT)
        // swipe gesture
        let swipeLeft = UIPanGestureRecognizer(target: self, action: #selector(swipeView))
        calculatorView.addGestureRecognizer(swipeLeft)
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(swipeView))
        converterView.addGestureRecognizer(swipeRight)
    }
    
    func btype2atype(button: ButtonType) -> InputType?{
        let it = InputType.self
        switch button {
        case .op:
            return it.op
        case .num:
            return it.num
        case .dot:
            return it.dot
        case .enter:
            return it.enter
        case .clear:
            return it.clear
        case .change:
            return it.change
        default:
            return nil
        }
    }
    
    func calProgress(_ button: CalButton){
        // get button type and check if it is an appropriate input for the algorithm
        let atype = btype2atype(button: button.getButtonType())
        let value = button.value
        // give input to algorithm
        if(atype != nil && value != nil){
            calAlg.addInput(atype!, value!)
        }
        updateLabels()
        // button highlighted set
        if let hl = highlighted{
            swapColor(hl)
            highlighted = nil
        }
        if let hlop = calAlg.getInActiveOp(){
            if let hlbt = others[hlop]{
                highlighted = hlbt
                swapColor(hlbt)
            }
        }
        // button animation set
        if(highlighted == nil || button !== highlighted!){
            // play animation
            button.addBackgroundColorAnimation(cg: nil, dur: ANIMATION_BC_INTERVAL)
        }
        // conversion set
        if(button.value == "converter"){
            convertMode(false)
            //converterView.isHidden = false
        }
    }
    
    func convertMode(_ convToCal: Bool){
        let x = SCREEN_MAXWIDTH
        updateLabels()
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            if(convToCal){
                self.converterView.center.x += x
                self.calculatorView.center.x += x
            }else{
                self.converterView.center.x -= x
                self.calculatorView.center.x -= x
            }
        }, completion: nil)
    }
    
    func updateLabels(){
        // main text set
        let main = labels[0]
        let mainText = calAlg.getCurrentNum()
        if(mainText.contains("E")){
            main.setHighlightedTitleByHex(title: mainText, highlighted: "E", hex: E_TCOLOR)
        }else{
            main.setTitle(mainText)
        }
        // ans text set
        let ans = labels[1]
        if let ansText = calAlg.getPreviousNum(){
            if(ansText.contains("E")){
                ans.setHighlightedTitleByHex(title: ansText, highlighted: "E", hex: E_TCOLOR)
            }else{
                ans.setTitle(ansText)
            }
        }else{
            ans.setTitle("")
        }
        // target
        if(targetUnit != nil && sourceUnit != nil && tableSection != nil && Double(calAlg.current) != nil){
            let src = Double(calAlg.current)!
            if let tar = conv_menu.getConverted(sourceValue: src, sourceUnitType: tableSection!, sourceUnit: sourceUnit!, targetUnitType: tableSection!, targetUnit: targetUnit!){
                if(prevUnitType != nil && prevSource != nil && prevTarget != nil){
                    if(prevSource != sourceUnit || prevTarget != targetUnit){
                        self.addHistory(prevUnitType!, prevSource!, prevTarget!)
                    }
                }
                prevUnitType = tableSection!
                prevSource = sourceUnit!
                prevTarget = targetUnit!
                tarValue = tar.0
                let val = Utilities.minimizeNum(input: tar.0)
                let symbol = tar.1
                labels[3].setHighlightedTitleByHex(title: val+" "+symbol, highlighted: symbol, hex: OP_BCOLOR)
            }else{
                tarValue = nil
                labels[3].setTitle("")
            }
        }else{
            tarValue = nil
            labels[3].setTitle("")
        }
        // source
        if(sourceUnit != nil && tableSection != nil){
            let val = calAlg.getCurrentNum()
            let symbol = conv_menu.getUnitSymbol(tableSection!, unit: sourceUnit!)
            labels[2].setHighlightedTitleByHex(title: val+" "+symbol+" ➜", highlighted: symbol, hex: OP_BCOLOR)
        }else{
            let text = calAlg.getCurrentNum()+" ➜"
            labels[2].setTitle(text)
        }
        // history
        for h in history{
            let label = h.label
            let info = h.info
            if(info.index > -1){
                let srcSymbol = conv_menu.getUnitSymbol(info.unitType, unit: info.source)
                let src = Double(calAlg.current)!
                if let tar = conv_menu.getConverted(sourceValue: src, sourceUnitType: info.unitType, sourceUnit: info.source, targetUnitType: info.unitType, targetUnit: info.target){
                    tarValue = tar.0
                    let val = Utilities.minimizeNum(input: tar.0)
                    let symbol = tar.1
                    let text = srcSymbol+" ➜ "+val+symbol
                    label.setValue(val)
                    label.setTitle(text)
                }
            }
        }
    }
    
    func swapColor(_ button: CalButton){
        let pb = button.bcolor
        let pt = button.tcolor
        button.setFontColor(pb)
        button.setBackgroundColor(pt)
    }
    
    func activateButtons(){
        for b in btnDict.values {
            b.addTarget(target: self, selector: #selector(buttonClicked), event: .touchUpInside)
        }
        backToCal?.addTarget(target: self, selector: #selector(backButtonClicked), event: .touchUpInside)
        for s in selects{
            s.addTarget(target: self, selector: #selector(selectorClicked), event: .touchUpInside)
        }
    }
    
    func initGrid(){
        let segmentX = (ex-sx)/segXFactor
        let segmentY = (ex-sx)/segYFactor
        let position: (Int) -> CGFloat = { f in
            return CGFloat((f-1)*2+1)
        }
        for i in 1...MAX_COL {
            var g: [(CGFloat,CGFloat)] = []
            var c: [CalButton?] = []
            for j in 1...MAX_ROW {
                let x = segmentX*position(j)
                let y = ey - segmentY*position(i)
                g.append((x,y))
                c.append(nil)
            }
            grid.append(g)
            cell.append(c)
        }
    }
    
    func initOthers(){
        if(!safeInit){
            msgBox = CalLabel()
            msgBox!.setBackGroundColorByHex(MSG_BCOLOR)
            msgBox!.setFontColorByHex(MSG_TCOLOR)
            msgBox!.setBackgroundAlpha(0)
            msgBox!.setTextAlign(.center)
            msgBox!.setAutoTextResize(true)
            // load currency info from open api
            if(!currencyLoaded){
                getCurrencyFromURL(address: CURRENCY_API_URL, completion: { (pc) in
                    let date = pc.date
                    let title = "Currency (\(date))"
                    self.curLibrary = pc
                    self.currencyLoaded = true
                    self.conv_menu.setCurrencyLibrary(pc,title)
                    // update currency to db for later use
                    updateCurrencyToDB(base: pc.base, date: pc.date, rates: pc.rates)
                })
            }
            // load history
            for _ in 0...(MAX_HISTORY_LIST){
                let copyGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.labelValueClicked))
                copyGesture.minimumPressDuration = MSG_DUR
                let label = CalLabel()
                label.setBackGroundColorByHex(CONV_BCOLOR)
                label.setFontColorByHex(CONV_TCOLOR)
                label.setTextAlign(.center)
                label.setAutoTextResize(true)
                label.showLabel(converterView)
                label.setBackgroundAlpha(0)
                label.setFontSize(BUTTON_FONT_SIZE)
                label.addGesture(copyGesture)
                let ch = convertedHistory(index: -1, source: "", target: "", unitType: "")
                history.append((label: label,info: ch))
            }
        }else{
            var x = (ex-sx)*msgBoxXFactor
            var y = (ey-sy)*msgBoxYFactor
            var w = (ex-sx)*msgBoxWidthFactor
            var h = (ey-sy)*msgBoxHeightFactor
            msgBox!.setFrame(x: x, y: y, w: w, h: h)
            msgBox!.setCornerRadius(r: CGFloat(MSG_ROUND))
            msgBox!.setFontSize(MSG_FONT_SIZE, "bold")
            msgBox!.showLabel(self.view)
            //load history
            x = (ex-sx)/2
            //y = (ey-sy)/segYFactor*3
            w = (ex-sx)*historyWidthFactor
            h = (ey-sy)*historyHeightFactor
            history.forEach { history in
                let label = history.label
                y = (ey-sy)/segYFactor*(historyYFactor)
                y += (ey-sy)*historyHeightFactor*historyGapFactor
                label.setFrame(x: x, y: y, w: w, h: h)
                label.setCornerRadius(r: CGFloat(BOX_ROUND))
            }
        }
    }
    
    func initConvTables(){
        if(!safeInit){
            table = TableView()
            table!.setBackgroundColorByHex(TABLE_BCOLOR)
            table!.setExtension(self)
            table!.setRegister(TableViewCell.self, forCellReuseIdentifier: CELL_ID)
            //gesture
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.converterBackgroundClicked))
            tableView.addGestureRecognizer(gesture)
        }else{
            let x = (ex-sx)*tableXFactor
            let y = (ey-sy)*tableYFactor
            let w = (ex-sx)*tableWidthFactor
            let h = (ey-sy)*tableHeightFactor
            tablePos = (open: y,close: y+SCREEN_MAXHEIGHT)
            table!.setFrame(x: x, y: tablePos!.close, w: w, h: h)
            table!.setCornerRadius(r: CGFloat(0.0625))
            table!.showTable(self.view)
        }
    }
    
    func initConvButtons(){
        if(!safeInit){
            var button = CalButton(ButtonType.select)
            button.setTitle(SELECT_TARGET_DEFAULT)
            button.setBackGroundColorByHex(SEL_BCOLOR)
            button.setAnimationColorByHex(SEL_ACOLOR)
            button.setFontColorByHex(SEL_TCOLOR)
            button.setAutoTextResize(true)
            button.setValue("target")
            button.showButton(converterView)
            selects.append(button)
            button = CalButton(ButtonType.select)
            button.setTitle(SELECT_SOURCE_DEFAULT)
            button.setBackGroundColorByHex(SEL_BCOLOR)
            button.setAnimationColorByHex(SEL_ACOLOR)
            button.setFontColorByHex(SEL_TCOLOR)
            button.setAutoTextResize(true)
            button.setValue("source")
            button.showButton(converterView)
            selects.append(button)
            button = CalButton(ButtonType.conv)
            button.setTitle(CONV_MODE_BACK_BUTTON)
            button.setBackGroundColorByHex(SEL_BCOLOR)
            button.setAnimationColorByHex(SEL_ACOLOR)
            button.setFontColorByHex(SEL_TCOLOR)
            button.setValue("back")
            button.showButton(converterView)
            backToCal = button
        }else{
            let segmentX = (ex-sx)/segXFactor
            let segmentY = segmentX
            var sizeX = segmentX*2*CGFloat(BAK_SIZE)*boxSizeFactor
            var sizeY = segmentY*2*CGFloat(BAK_SIZE)*boxSizeFactor
            let x = (ex-sx)/backFactor
            let y = (ey-sy)/backFactor
            setCircularShapeButton(backToCal!, x, y, sizeX, sizeY, BUTTON_FONT_SIZE, BOX_ROUND)
            sizeX = (ex-sx)*selectorWidthFactor
            sizeY = sizeX*selectorHeightFactor
            for (i,b) in selects.enumerated(){
                let x = (ex-sx)/2
                let y = ey - ((ey-sy)*CGFloat(i+1)*selectorYFactor)
                setCircularShapeButton(b, x, y, sizeX, sizeY, BUTTON_FONT_SIZE, SEL_ROUND)
            }
        }
    }
    
    func initLabels(){
        if(!safeInit){
            var copyGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.labelValueClicked))
            copyGesture.minimumPressDuration = MSG_DUR
            let main = CalLabel()
            main.setTitle("0")
            main.setValue("0")
            main.setBackGroundColorByHex(MAIN_BCOLOR)
            main.setFontColorByHex(MAIN_TCOLOR)
            main.setTextAlign(.right)
            main.setAutoTextResize(true)
            main.showLabel(calculatorView)
            main.addGesture(copyGesture)
            labels.append(main)
            let ans = CalLabel()
            ans.setTitle("")
            ans.setValue(nil)
            ans.setBackGroundColorByHex(ANS_BCOLOR)
            ans.setFontColorByHex(ANS_TCOLOR)
            ans.setTextAlign(.right)
            ans.setAutoTextResize(true)
            ans.showLabel(calculatorView)
            labels.append(ans)
            let source = CalLabel()
            source.setTitle("0")
            source.setValue("0")
            source.setBackGroundColorByHex(TAR_BCOLOR)
            source.setFontColorByHex(TAR_TCOLOR)
            source.setTextAlign(.right)
            source.setAutoTextResize(true)
            source.showLabel(converterView)
            labels.append(source)
            copyGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.labelValueClicked))
            copyGesture.minimumPressDuration = MSG_DUR
            let tarToMainGesture = UITapGestureRecognizer(target: self, action: #selector(self.targetValueClicked))
            let target = CalLabel()
            target.setTitle("0")
            target.setValue("0")
            target.setBackGroundColorByHex(SRC_BCOLOR)
            target.setFontColorByHex(SRC_TCOLOR)
            target.setTextAlign(.right)
            target.setAutoTextResize(true)
            target.showLabel(converterView)
            target.addGesture(copyGesture)
            target.addGesture(tarToMainGesture)
            labels.append(target)
        }else{
            let main = labels[0]
            let ans = labels[1]
            let source = labels[2]
            let target = labels[3]
            var segmentX = (ex-sx)*mainWidthFactor
            var segmentY = (ex-sx)/segYFactor
            var centerX = (ex-sx)*mainXFactor
            var centerY = ey - segmentY*CGFloat(MAX_COL*2+1)
            main.setFrame(x: centerX, y: centerY, w: segmentX, h: segmentY*mainHeightFactor)
            main.setFontSize(MAIN_FONT_SIZE*labelFontSizeFactor)
            //------------------//
            target.setFrame(x: centerX, y: centerY*targetYFactor, w: segmentX, h: segmentY*targetHeightFactor)
            target.setFontSize(MAIN_FONT_SIZE*labelFontSizeFactor)
            //------------------//
            segmentX = (ex-sx)*ansWidthFactor
            segmentY = (ex-sx)/segYFactor
            centerX = (ex-sx)*ansXFactor
            centerY = ey - segmentY*(CGFloat(MAX_COL*2+1)+ansYFactor)
            ans.setFrame(x: centerX, y: centerY, w: segmentX, h: segmentY*ansHeightFactor)
            ans.setFontSize(ANS_FONT_SIZE*labelFontSizeFactor)
            //------------------//
            segmentX = (ex-sx)*sourceWidthFactor
            centerX = (ex-sx)/sourceXFactor
            source.setFrame(x: centerX, y: centerY*sourceYFactor, w: segmentX, h: segmentY*sourceHeightFactor)
            source.setFontSize(ANS_FONT_SIZE*labelFontSizeFactor)
        }
    }
    
    func initButtons(){
        let op = [("plus","+"),("minus","−"),("multiply","×"),("divide","÷")]
        let other = [("dot","."),("enter","="),("clear","C"),("power","x^y"),("EE","EE"),("percent","%"),("reciprocal","1/x"),("reverse","±"),("converter","☍")]
        if(!safeInit){ // ViewDidLoad: init buttons
            for i in 0...9 {
                let button = CalButton(ButtonType.num)
                button.setTitle(String(i))
                button.setBackGroundColorByHex(NUM_BCOLOR)
                button.setAnimationColorByHex(NUM_ACOLOR)
                button.setFontColorByHex(NUM_TCOLOR)
                button.setValue(String(i))
                button.showButton(calculatorView)
                //button.isHidden(true)
                btnDict[button.getRefButton()] = button
                nums.append(button)
            }
            for (value,string) in op{
                let button = CalButton(ButtonType.op)
                button.setTitle(string)
                button.setBackGroundColorByHex(OP_BCOLOR)
                button.setAnimationColorByHex(OP_ACOLOR)
                button.setFontColorByHex(OP_TCOLOR)
                button.setValue(value)
                button.showButton(calculatorView)
                //button.isHidden(true)
                btnDict[button.getRefButton()] = button
                others[value] = button
            }
            for (value,string) in other{
                var ac = OTHER_ACOLOR
                var bc = OTHER_BCOLOR
                var tc = OTHER_TCOLOR
                var bt = ButtonType.change
                switch value {
                case "clear":
                    bt = ButtonType.clear
                case "enter":
                    bt = ButtonType.enter
                    ac = OP_ACOLOR
                    bc = OP_BCOLOR
                    tc = OP_TCOLOR
                case "dot":
                    bt = ButtonType.dot
                    ac = NUM_ACOLOR
                    bc = NUM_BCOLOR
                    tc = NUM_TCOLOR
                case "converter":
                    bt = ButtonType.conv
                    ac = CONV_ACOLOR
                    bc = CONV_BCOLOR
                    tc = CONV_TCOLOR
                case "power":
                    bt = ButtonType.op
                    ac = OP_ACOLOR
                    bc = OP_BCOLOR
                    tc = OP_TCOLOR
                case "EE":
                    bt = ButtonType.op
                    ac = OP_ACOLOR
                    bc = OP_BCOLOR
                    tc = OP_TCOLOR
                default:
                    break
                }
                let button = CalButton(bt)
                button.setTitle(string)
                button.setBackGroundColorByHex(bc)
                button.setFontColorByHex(tc)
                button.setAnimationColorByHex(ac)
                button.setValue(value)
                button.showButton(calculatorView)
                //button.isHidden(true)
                btnDict[button.getRefButton()] = button
                others[value] = button
            }
        }else{ // ViewDidAppear: show buttons at right place
            let segmentX = (ex-sx)/segXFactor
            let segmentY = segmentX
            let sizeX = segmentX*2*CGFloat(BOX_SIZE)*boxSizeFactor
            let sizeY = segmentY*2*CGFloat(BOX_SIZE)*boxSizeFactor
            // relocate numbers
            for (i,b) in nums.enumerated() {
                if(i==0){ // 0 has a special property
                    let x = (grid[0][0].0+grid[0][1].0)/2
                    let y = grid[0][0].1
                    setCircularShapeButton(b, x, y, segmentX*2+sizeX, sizeY, BUTTON_FONT_SIZE, BOX_ROUND)
                    cell[0][0] = b
                    cell[0][1] = b
                }else{ // r = row, c = col, p = position
                    let r = (i-1)%3
                    let c = ((i-1)/3)+1
                    let p = grid[c][r]
                    setCircularShapeButton(b, p.0, p.1, sizeX, sizeY, BUTTON_FONT_SIZE, BOX_ROUND)
                    cell[c][r] = b
                }
            }
            // relocate operators
            for (i,(value,_)) in op.enumerated(){
                let p = grid[i+1][3]
                setCircularShapeButton(others[value]!, p.0, p.1, sizeX, sizeY, BUTTON_FONT_SIZE, BOX_ROUND)
                cell[i+1][3] = others[value]
            }
            // relocate other buttons
            let ind = [1:(2,0),2:(0,4),3:(0,5)]
            var index = 0
            for i in 1...3{
                for j in 0...i{
                    let k = ind[i]!
                    let p = grid[k.1][k.0+j]
                    setCircularShapeButton(others[other[index].0]!, p.0, p.1, sizeX, sizeY, BUTTON_FONT_SIZE, BOX_ROUND)
                    cell[k.1][k.0+j] = others[other[index].0]!
                    index += 1
                }
            }
        }
    }
    
    func setCircularShapeButton(_ b: CalButton,_ x: CGFloat,_ y: CGFloat,_ w: CGFloat,_ h: CGFloat, _ s: CGFloat, _ r: Float){
        b.setFrame(x: x, y: y, w: w, h: h)
        b.setCornerRadius(r: CGFloat(r))
        b.setFontSize(s)
    }
    
}

