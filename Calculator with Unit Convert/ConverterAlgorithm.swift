//
//  ConverterAlgorithm.swift
//  Calculator + Unit Converter
//
//  Created by TaeYoun Kim on 7/24/19.
//  Copyright © 2019 TaeYoun Kim. All rights reserved.
//

import Foundation

enum UnitType {
    case area
    case length
    case volume
    case angle
    case mass
    case pressure
    case duration
    case speed
    case energy
    case temperature
    case fuel
    case currency
}

let CURRENCY_API_URL = "https://api.exchangeratesapi.io/latest?base=USD"

struct ParsedCurrency: Decodable{
    var date: String
    var rates: [String:Double]
    var base: String
}

func getCurrencyFromURL(address: String, completion: @escaping ((ParsedCurrency) -> Void)){
    guard let url = URL(string: address) else { return }
    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        guard let dataResponse = data, error == nil else {
            print(error?.localizedDescription ?? "Response Error")
            return
        }
        DispatchQueue.main.async {
            do{
                let json = try JSONDecoder().decode(ParsedCurrency.self, from: dataResponse)
                completion(json)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    task.resume()
}

struct convertedHistory {
    var index: Int16
    var source: String
    var target: String
    var unitType: String
    
    static func ==(lhs: convertedHistory, rhs: convertedHistory) -> Bool {
        return (lhs.source == rhs.source && lhs.target == rhs.target && lhs.unitType == rhs.unitType)
    }
    
    mutating func setIndex(_ index: Int16){
        self.index = index
    }
}

struct UnitConvLibrary{
    var unit: [String:Any]
    let area: [String:UnitArea] = [
        "Square Megameters (Mm²)":UnitArea.squareMegameters,
        "Square Kilometers (km²)":UnitArea.squareKilometers,
        "Square Meters (m²)":UnitArea.squareMeters,
        "Square Centimeter (cm²)":UnitArea.squareCentimeters,
        "Square Millimeters (mm²)":UnitArea.squareMillimeters,
        "Square Micrometers (µm²)":UnitArea.squareMicrometers,
        "Square Nanometers (nm²)":UnitArea.squareNanometers,
        "Square Inches (in²)":UnitArea.squareInches,
        "Square Feet (ft²)":UnitArea.squareFeet,
        "Square Yards (yd²)":UnitArea.squareYards,
        "Square Miles (mi²)":UnitArea.squareMiles,
        "Acres (ac)":UnitArea.acres,
        "Ares (a)":UnitArea.ares,
        "Hectares (ha)":UnitArea.hectares
    ]
    let length: [String:UnitLength] = [
        "Megameters (Mm)":UnitLength.megameters,
        "Kilometers (kM)":UnitLength.kilometers,
        "Hectometers (hm)":UnitLength.hectometers,
        "Decameters (dam)":UnitLength.decimeters,
        "Meters (m)":UnitLength.meters,
        "Decimeters (dm)":UnitLength.decimeters,
        "Centimeters (cm)":UnitLength.centimeters,
        "Millimeters (mm)":UnitLength.millimeters,
        "Micrometers (µm)":UnitLength.micrometers,
        "Nanometers (nm)":UnitLength.nanometers,
        "Picometers (pm)":UnitLength.picometers,
        "Inches (in)":UnitLength.inches,
        "Feet (ft)":UnitLength.feet,
        "Yards (yd)":UnitLength.yards,
        "Miles (mi)":UnitLength.miles,
        "Scandinavian Miles (smi)":UnitLength.scandinavianMiles,
        "Light Years (ly)":UnitLength.lightyears,
        "Nautical Miles (NM)":UnitLength.nauticalMiles,
        "Fathoms (ftm)":UnitLength.fathoms,
        "Furlongs (fur)":UnitLength.furlongs,
        "Astronomical Units (ua)":UnitLength.astronomicalUnits,
        "Parsecs (pc)":UnitLength.parsecs,
    ]
    let volume: [String:UnitVolume] = [
        "Megaliters (ML)":UnitVolume.megaliters,
        "Kiloliters (kL)":UnitVolume.kiloliters,
        "Liters (L)":UnitVolume.liters,
        "Deciliters (dL)":UnitVolume.deciliters,
        "Centiliters (cL)":UnitVolume.centiliters,
        "Milliliters (mL)":UnitVolume.milliliters,
        "Cubic Kilometers (km³)":UnitVolume.cubicKilometers,
        "Cubic Meters (m³)":UnitVolume.cubicMeters,
        "Cubic Decimeters (dm³)":UnitVolume.cubicDecimeters,
        "Cubic Millimeters (mm³)":UnitVolume.cubicMillimeters,
        "Cubic Inches (in³)":UnitVolume.cubicInches,
        "Cubic Feet (ft³)":UnitVolume.cubicFeet,
        "Cubic Yards (yd³)":UnitVolume.cubicYards,
        "Cubic Miles (mi³)":UnitVolume.cubicMiles,
        "Acre Foeet (af)":UnitVolume.acreFeet,
        "Bushels (bsh)":UnitVolume.bushels,
        "Teaspoons (tsp)":UnitVolume.teaspoons,
        "Tablespoons (tbsp)":UnitVolume.tablespoons,
        "Fluid Ounces (fl oz)":UnitVolume.fluidOunces,
        "Cups (cup)":UnitVolume.cups,
        "Pints (pt)":UnitVolume.pints,
        "Quarts (qt)":UnitVolume.quarts,
        "Gallons (gal)":UnitVolume.gallons,
        "Imperial Teaspoons (tsp)":UnitVolume.imperialTeaspoons,
        "Imperial Tablespoons (tbsp)":UnitVolume.imperialTablespoons,
        "Imperial Fluid Ounces (fl oz)":UnitVolume.imperialFluidOunces,
        "Imperial Pints (pt)":UnitVolume.imperialPints,
        "Imperial Quarts (qt)":UnitVolume.imperialQuarts,
        "Imperial Gallons (gal)":UnitVolume.imperialGallons,
        "Metric Cups (metric cup)":UnitVolume.metricCups
    ]
    let angle: [String:UnitAngle] = [
        "Degrees (°)":UnitAngle.degrees,
        "Arc Minutes (ʹ)":UnitAngle.arcMinutes,
        "Arc Seconds (ʺ)":UnitAngle.arcSeconds,
        "Radians (rad)":UnitAngle.radians,
        "Gradians (grad)":UnitAngle.gradians,
        "Revolutions (rev)":UnitAngle.revolutions
    ]
    let mass: [String:UnitMass] = [
        "Kilograms (kg)":UnitMass.kilograms,
        "Grams (g)":UnitMass.grams,
        "Decigrams (dg)":UnitMass.decigrams,
        "Centigrams (cg)":UnitMass.centigrams,
        "Milligrams (mg)":UnitMass.milligrams,
        "Micrograms (µg)":UnitMass.micrograms,
        "Nanograms (ng)":UnitMass.nanograms,
        "Picograms (pg)":UnitMass.picograms,
        "Ounces (oz)":UnitMass.ounces,
        "Pounds (lb)":UnitMass.pounds,
        "Stones (st)":UnitMass.stones,
        "Metric Tons (t)":UnitMass.metricTons,
        "Short Tons (ton)":UnitMass.shortTons,
        "Carats (ct)":UnitMass.carats,
        "Ounces Troy (oz t)":UnitMass.ouncesTroy,
        "Slugs (slug)":UnitMass.slugs
    ]
    let pressure: [String:UnitPressure] = [
        "Pascals (Pa)":UnitPressure.newtonsPerMetersSquared,
        "Gigapascals (GPa)":UnitPressure.gigapascals,
        "Megapascals (MPa)":UnitPressure.megapascals,
        "Kilopascals (kPa)":UnitPressure.kilopascals,
        "Hectopascals (hPa)":UnitPressure.hectopascals,
        "Inches of Mercury (inHg)":UnitPressure.inchesOfMercury,
        "Bars (bar)":UnitPressure.bars,
        "Millibars (mbar)":UnitPressure.millibars,
        "Millimeters of Mercury (mmHg)":UnitPressure.millimetersOfMercury,
        "Pounds Per Square Inch (psi)":UnitPressure.poundsForcePerSquareInch
    ]
    let duration: [String:UnitDuration] = [
        "Seconds (sec)":UnitDuration.seconds,
        "Minutes (min)":UnitDuration.minutes,
        "Hours (hr)":UnitDuration.hours
    ]
    let speed: [String:UnitSpeed] = [
        "Meters Per Second (m/s)":UnitSpeed.metersPerSecond,
        "Kilometers Per Hour (km/h)":UnitSpeed.kilometersPerHour,
        "Miles Per Hour (mph)":UnitSpeed.milesPerHour,
        "Knots (kn)":UnitSpeed.knots
    ]
    let energy: [String:UnitEnergy] = [
        "Kilojoules (kJ)":UnitEnergy.kilojoules,
        "Joules (J)":UnitEnergy.joules,
        "Kilocalories (kCal)":UnitEnergy.kilocalories,
        "Calories (cal)":UnitEnergy.calories,
        "Kilowatt Hours (kWh)":UnitEnergy.kilowattHours
    ]
    let temperature: [String:UnitTemperature] = [
        "Kelvin (K)":UnitTemperature.kelvin,
        "Celsius (°C)":UnitTemperature.celsius,
        "Fahrenheit (°F)":UnitTemperature.fahrenheit
    ]
    let fuel: [String:UnitFuelEfficiency] = [
        "Liters Per 100 Kilometers (L/100km)":UnitFuelEfficiency.litersPer100Kilometers,
        "Miles Per Gallon (mpg)":UnitFuelEfficiency.milesPerGallon,
        "Miles Per Imperial Gallon (mpg)":UnitFuelEfficiency.milesPerImperialGallon
    ]
    let currency: [String:String] = [
        "🇦🇺 Australian Dollar($)":"AUD",
        "🇧🇬 Bulgarian Lev(лв)":"BGN",
        "🇧🇷 Brazilian Real(R$)":"BRL",
        "🇨🇦 Canadian Dollar($)":"CAD",
        "🇨🇭 Swiss Franc(CHF)":"CHF",
        "🇨🇳 Chinese Yuan Renminbi(¥)":"CNY",
        "🇨🇿 Czech Koruna(Kč)":"CZK",
        "🇩🇰 Danish Krone(kr)":"DKK",
        "🇪🇺 Euro(€)":"EUR",
        "🇬🇧 Pound Sterling(£)":"GBP",
        "🇭🇰 Hong Kong Dollar($)":"HKD",
        "🇭🇷 Croatian Kuna(kn)":"HRK",
        "🇭🇺 Hungarian Forint(Ft)":"HUF",
        "🇮🇩 Indonesian Rupiah(Rp)":"IDR",
        "🇮🇱 Israeli Shekel(₪)":"ILS",
        "🇮🇳 Indian Rupee(₹)":"INR",
        "🇮🇸 Icelandic Krona(kr)":"ISK",
        "🇯🇵 Japanese Yen(¥)":"JPY",
        "🇰🇷 South Korean Won(₩)":"KRW",
        "🇲🇽 Mexican Peso($)":"MXN",
        "🇲🇾 Malaysian Ringgit(RM)":"MYR",
        "🇳🇴 Norwegian Krone(kr)":"NOK",
        "🇳🇿 New Zealand Dollar($)":"NZD",
        "🇵🇭 Philippine Peso(₱)":"PHP",
        "🇵🇱 Polish Zloty(zł)":"PLN",
        "🇷🇴 Romanian Leu(lei)":"RON",
        "🇷🇺 Russian Rouble(₽)":"RUB",
        "🇸🇪 Swedish Krona(kr)":"SEK",
        "🇸🇬 Singapore Dollar($)":"SGD",
        "🇹🇭 Thai Baht(฿)":"THB",
        "🇹🇷 Turkish Lira(₺)":"TRY",
        "🇺🇸 US Dollar($)":"USD",
        "🇿🇦 South African Rand(R)":"ZAR",
    ]
    let currencySymbol: [String:String] = [
        "AUD":"🇦🇺($)",
        "BGN":"🇧🇬(лв)",
        "BRL":"🇧🇷(R$)",
        "CAD":"🇨🇦($)",
        "CHF":"🇨🇭(CHF)",
        "CNY":"🇨🇳(¥)",
        "CZK":"🇨🇿(Kč)",
        "DKK":"🇩🇰(kr)",
        "EUR":"🇪🇺(€)",
        "GBP":"🇬🇧(£)",
        "HKD":"🇭🇰($)",
        "HRK":"🇭🇷(kn)",
        "HUF":"🇭🇺(Ft)",
        "IDR":"🇮🇩(Rp)",
        "ILS":"🇮🇱(₪)",
        "INR":"🇮🇳(₹)",
        "ISK":"🇮🇸(kr)",
        "JPY":"🇯🇵(¥)",
        "KRW":"🇰🇷(₩)",
        "MXN":"🇲🇽($)",
        "MYR":"🇲🇾(RM)",
        "NOK":"🇳🇴(kr)",
        "NZD":"🇳🇿($)",
        "PHP":"🇵🇭(₱)",
        "PLN":"🇵🇱(zł)",
        "RON":"🇷🇴(lei)",
        "RUB":"🇷🇺(₽)",
        "SEK":"🇸🇪(kr)",
        "SGD":"🇸🇬($)",
        "THB":"🇹🇭(฿)",
        "TRY":"🇹🇷(₺)",
        "USD":"🇺🇸($)",
        "ZAR":"🇿🇦(R)"
    ]
    
    var currencyLibrary: ParsedCurrency?
    var currencyLoaded = false
    var currencyTitle = "Currency"
    
    init(){
        unit = ["Area":self.area,
                "Length":self.length,
                "Volume":self.volume,
                "Angle":self.angle,
                "Mass":self.mass,
                "Pressure":self.pressure,
                "Duration":self.duration,
                "Speed":self.speed,
                "Energy":self.energy,
                "Temperature":self.temperature,
                "Fuel Efficiency":self.fuel,
                //"Currency":self.currency
        ]
    }
    
    mutating func setCurrencyLibrary(_ curLibrary: ParsedCurrency,_ currencyTitle: String){
        self.currencyLibrary = curLibrary
        self.currencyLoaded = true
        self.currencyTitle = currencyTitle
        unit[currencyTitle] = self.currency
    }
    
    func getUnitTypeTitles() -> Array<String>{
        return Array(unit.keys).sorted()
    }
    
    func getUnitTitles(_ unitType: String) -> Array<String>? {
        if let unitTitles = unit[unitType]{
            let output = unitTitles as! [String:Any]
            return Array(output.keys).sorted()
        }
        return nil
    }
    
    func getUnitSymbol(_ unitType: String, unit: String) -> String{
        switch unitType {
        case currencyTitle:
            guard let code = currency[unit] else { return "" }
            guard let symbol = currencySymbol[code] else { return "" }
            return symbol
        default:
            if let unitTitle = self.unit[unitType]{
                let specific = unitTitle as! [String:Unit]
                if let target = specific[unit]{
                    let output = target as! Dimension
                    return output.symbol
                }
            }
        }
        return ""
    }
    
    func getUnitTypeTitleByType(_ unitType: UnitType) -> String{
        switch unitType {
        case .angle:
            return "Angle"
        case .area:
            return "Area"
        case .duration:
            return "Duration"
        case .energy:
            return "Energy"
        case .fuel:
            return "Fuel"
        case .length:
            return "Length"
        case .mass:
            return "Mass"
        case .pressure:
            return "Pressure"
        case .speed:
            return "Speed"
        case .temperature:
            return "Temperature"
        case .volume:
            return "Volume"
        case .currency:
            return currencyTitle
        }
    }
    
    func getConverted(sourceValue: Double, sourceUnitType: String, sourceUnit: String, targetUnitType: String, targetUnit: String) -> (Double,String)?{
        if(sourceUnitType == targetUnitType){
            switch sourceUnitType {
            case currencyTitle:
                return CurrencyConverter(sourceValue, sourceUnit, targetUnit)
            default:
                return inBuiltConverter(sourceValue, sourceUnitType, sourceUnit, targetUnitType, targetUnit)
            }
        }else{
            return nil
        }
    }
    
    func CurrencyConverter(_ sourceValue: Double,_ sourceUnit: String,_ targetUnit: String) -> (Double,String)?{
        if(currencyLoaded){
            let currency = unit[currencyTitle] as! [String:String]
            guard let source = currency[sourceUnit] else { return nil }
            guard let target = currency[targetUnit] else { return nil }
            guard let srcRate = currencyLibrary?.rates[source] else { return nil }
            guard let tarRate = currencyLibrary?.rates[target] else { return nil }
            guard let symbol = currencySymbol[target] else { return nil }
            let cal = (sourceValue/srcRate)*tarRate
            return (cal,symbol)
        }
        return nil
    }
    
    func inBuiltConverter(_ sourceValue: Double,_ sourceUnitType: String,_ sourceUnit: String,_ targetUnitType: String,_ targetUnit: String) -> (Double,String)?{
        let sut = unit[sourceUnitType] as! [String:Unit]?
        let tut = unit[targetUnitType] as! [String:Unit]?
        if(sut != nil && tut != nil){
            let source = sut![sourceUnit] as! Dimension?
            let target = tut![targetUnit] as! Dimension?
            if(source != nil && target != nil){
                let input = Measurement(value: sourceValue, unit: source!)
                let output = input.converted(to: target!)
                return (output.value,output.unit.symbol)
            }
        }
        return nil
    }
}
