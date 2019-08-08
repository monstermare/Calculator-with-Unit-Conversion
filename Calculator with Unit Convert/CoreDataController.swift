//
//  CoreDataController.swift
//  Calculator with Unit Convert
//
//  Created by TaeYoun Kim on 7/28/19.
//  Copyright © 2019 TaeYoun Kim. All rights reserved.
//

import Foundation
import CoreData
import UIKit


func updateCurrencyToDB(base: String, date: String, rates: [String:Double]){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let request: NSFetchRequest<Currency> = Currency.fetchRequest()
    do {
        let loaded = try context.fetch(request)
        loaded.forEach { c in context.delete(c) }
    } catch {
        print("Have error while updating Currency")
    }
    rates.keys.forEach { k in
        let currency = Currency(context: context)
        currency.date = date
        currency.base = base
        currency.country = k
        currency.rate = rates[k]!
    }
    appDelegate.saveContext()
}

func getCurrencyFromDB() -> [Currency] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
    let context = appDelegate.persistentContainer.viewContext
    let request: NSFetchRequest<Currency> = Currency.fetchRequest()
    do {
        let loaded = try context.fetch(request)
        return loaded
    } catch {
        return []
    }
}

func addConvertedHistory(unitType: String, source: String, target: String, index: Int16 = MAX_HISTORY_LIST){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let request: NSFetchRequest<Converted> = Converted.fetchRequest()
    do {
        let loaded = try context.fetch(request)
        loaded.forEach { h in
            var ni = h.index
            if(ni == index){
                h.setValue(unitType, forKey: "unitType")
                h.setValue(source, forKey: "source")
                h.setValue(target, forKey: "target")
                h.setValue(0, forKey: "index")
            }else if(h.index < index){
                ni += 1
                h.setValue(ni, forKey: "index")
            }
            if(ni < MAX_HISTORY_LIST){
                context.delete(h)
            }
            if(index >= MAX_HISTORY_LIST){
                let converted = Converted(context: context)
                converted.unitType = unitType
                converted.source = source
                converted.target = target
                converted.index = 0
            }
        }
    } catch {
        print("Have error while re-indexing history list")
    }
    appDelegate.saveContext()
}

func getConvertedHistory() -> [Converted] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
    let context = appDelegate.persistentContainer.viewContext
    let request: NSFetchRequest<Converted> = Converted.fetchRequest()
    do {
        let loaded = try context.fetch(request)
        return loaded
    } catch {
        print("Have error while fetching converted history")
    }
    return []
}



@objc(Currency)
final class Currency: NSManagedObject {
    @NSManaged var date: String
    @NSManaged var base: String
    @NSManaged var country: String
    @NSManaged var rate: Double
}

extension Currency {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }
}

@objc(Converted)
final class Converted: NSManagedObject {
    @NSManaged var source: String
    @NSManaged var target: String
    @NSManaged var unitType: String
    @NSManaged var index: Int16
}

extension Converted {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Converted> {
        return NSFetchRequest<Converted>(entityName: "Currency")
    }
}
