//
//  TableViewElements.swift
//  Calculator + Unit Converter
//
//  Created by TaeYoun Kim on 7/24/19.
//  Copyright © 2019 TaeYoun Kim. All rights reserved.
//

import Foundation

import UIKit

class TableViewCell: UITableViewCell{
    var corner_radius: CGFloat = 10
    var font_size: CGFloat = 16
    var background_color = COLOR_A4
    var label_text = "?? Undefined Unit Value ??"
    
    let cellView: UIView = UIView()
    let label: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initcell()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initcell(){
        cellView.backgroundColor = Utilities.hex2rgba(background_color)
        cellView.layer.cornerRadius = corner_radius
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = label_text
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: font_size)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(label)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        label.heightAnchor.constraint(equalToConstant: 200).isActive = true
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        
    }
}

// EXTENSIONS

// viewcontroller: UITableViewDelegate for UITableView
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // DESCRIPTION: ACTION FOR 'BUTTON_CLICKED' EVENT
        // TODO:: return appropriate unit type by given index
        if let cg = cell_group{
            let element = cg[indexPath.row]
            if tableSection != nil{
                if(element == PREVIOUS_BUTTON){
                    cell_group = conv_menu.getUnitTypeTitles()
                    if let cg = cell_group{
                        cell_size = cg.count
                    }
                    tableSection = nil
                    table!.refreshTable()
                }else{
                    if(tableSelected){
                        sourceUnit = element
                        //selects[1].setTitle(sourceUnit!)
                        // reset target select button if unit type of source and target are different
                        if let tu = targetUnit{
                            if let tcg = conv_menu.getUnitTitles(tableSection!){
                                if(!tcg.contains(tu)){
                                    targetUnit = nil
                                    //selects[0].setTitle(SELECT_TARGET_DEFAULT)
                                }
                            }
                        }
                    }else{
                        targetUnit = element
                        //selects[0].setTitle(targetUnit!)
                    }
                    self.tableMode(false)
                }
            }else{
                tableSection = cg[indexPath.row]
                if let ts = tableSection{
                    cell_group = conv_menu.getUnitTitles(ts)
                    if(tableSelected && cell_group != nil){
                        cell_group!.insert(PREVIOUS_BUTTON, at: 0)
                    }
                    if let ncg = cell_group{
                        cell_size = ncg.count
                    }else{
                        cell_size = 0
                    }
                }
                table!.refreshTable()
            }
        }
        self.updateLabels()
    }
}


// viewcontroller: UITableViewDataSource for UITableView
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // DESCRIPTION: RETURN X MANY CELLS IN THE TABLEVIEW
        return cell_size
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // DESCRIPTION: RETURN HEIGHT OF EACH CELL
        return cell_height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // DESCRIPTION: CREATE A CELLVIEW TO POPULATE THE TABLE
        // TODO:: setup basic property of cell
        let cell = table!.setCell(withIdentifier: CELL_ID, indexPath: indexPath)
        let color = Utilities.hex2rgba(COLOR_A1)
        cell.backgroundColor = color
        if let cg = cell_group{
            cell.label.text = cg[indexPath.row]
        }
        return cell
    }
}

extension UIView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
