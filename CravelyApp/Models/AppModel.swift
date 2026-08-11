//
//  AppModel.swift
//  CravelyApp
//
//  Created by ayman moh on 07/08/2026.
//

import SwiftUI
import SwiftData
import Foundation
import Observation


@Model
final class Tap {
    var id: UUID
    var time: Date
    var brand: AppModel.CigaretteBrand
    var price: Double
    
    init(brand: AppModel.CigaretteBrand, price: Double, time: Date = Date(), id: UUID = UUID()) {
        self.id = id
        self.time = time
        self.brand = brand
        self.price = price
    }
}

@Observable
class AppModel {
    
    //User Selection
    var habitType: HabitType = .ciggeretes
    enum HabitType: String, CaseIterable {
        case ciggeretes = "Cigs"
        case cannabis = "Cannabis"
        var emoji: String {
            switch self {
            case .ciggeretes: return "🚬"
            case .cannabis: return "🌿"
            }
        }
    }
    var selectedBrand: CigaretteBrand = .marlboro {
            didSet {
                // Automatically sync packPrice when the user selects a new brand
                packPrice = selectedBrand.brandPrice
            }
    }
    // Note not neccessary (Alert)
    let brands = [
        "Marlboro Red",
        "Marlboro Gold",
        "Camel",
        "Winston",
        "Parliament",
        "Other Cigarette"
    ]

    enum CigaretteBrand: String, CaseIterable, Identifiable, Codable {
        case marlboro = "Marlboro"
        case newport = "Newport"
        case americanSpirit = "American Spirit"
        case camel = "Camel"
        case parliament = "Parliament"
        case pallMall = "Pall Mall"
        case winston = "Winston"
        case other = "Other Cigarette"

        var id: String { rawValue }
 
        // Note name it as title instead of raw value within a variable (Alert)
            
/*var title : Double {
            switch self {
            case .americanSpirit:
                return "American Spirit"
            case .newport, .parliament:
                return 15.00
            case .marlboro:
                return 14.50
            case .camel:
                return 13.75
            case .winston, .pallMall:
                return 12.50
            case .other:
                return 12.00
            }
 */     
       
            
        var brandPrice : Double {
            switch self {
            case .americanSpirit:
                return 15.50
            case .newport, .parliament:
                return 15.00
            case .marlboro:
                return 14.50
            case .camel:
                return 13.75
            case .winston, .pallMall:
                return 12.50
            case .other:
                return 12.00
            }
        }
    }
    
    // Editable pack price (defaults to initial brand price)
    var packPrice: Double = CigaretteBrand.marlboro.brandPrice
        
    // Dynamically computed price per individual unit (20 cigs per pack)
    var unitPrice: Double {
        if habitType == .ciggeretes {
            packPrice / 20.0
        } else {
            packPrice
        }
    }
    var dailyReminders: Bool = false
    
    var totalResisted : Int = 0

        
    func addTap(context: ModelContext) {
        let newTap = Tap(brand: selectedBrand, price: unitPrice)
        context.insert(newTap)
        
        do {
            try context.save()
        } catch {
            print("Failed to save tap: \(error)")
        }
    }
    func todayTapsCount(from taps: [Tap]) -> Int {
            let calendar = Calendar.current
            return taps.filter { calendar.isDateInToday($0.time) }.count
    }
}


