//
//  SettingsViewModel.swift
//  CravelyApp
//
//  Created by ayman moh on 14/08/2026.
//

import SwiftUI
import Observation

@Observable
class SettingsViewModel {
    
    // MARK: - Enums
    
    enum HabitType: String, CaseIterable, Identifiable {
        case cigarettes = "Cigs"
        case cannabis = "Cannabis"
        
        var id: String { rawValue }
        
        var emoji: String {
            switch self {
            case .cigarettes: return "🚬"
            case .cannabis: return "🌿"
            }
        }
    }

    enum CigaretteBrand: String, CaseIterable, Identifiable {
        case marlboro = "Marlboro"
        case newport = "Newport"
        case americanSpirit = "American Spirit"
        case camel = "Camel"
        case parliament = "Parliament"
        case pallMall = "Pall Mall"
        case winston = "Winston"
        case other = "Other Cigarette"

        var id: String { rawValue }
        
        var defaultPrice: Double {
            switch self {
            case .americanSpirit: return 15.50
            case .newport, .parliament: return 15.00
            case .marlboro: return 14.50
            case .camel: return 13.75
            case .winston, .pallMall: return 12.50
            case .other: return 12.00
            }
        }
    }

    enum CannabisProduct: String, CaseIterable, Identifiable {
        case preRollHalf = "Pre-roll (0.5g)"
        case preRollGram = "Pre-roll (1g)"
        case topShelfFlower = "Top Shelf Flower"
        case midShelfFlower = "Mid-shelf Flower"
        case vapeCart = "Vape Cart"
        case edible = "Edible"
        case concentrate = "Concentrate"

        var id: String { rawValue }
        
        /// Average US dispensary price as of mid-2026
        var defaultPrice: Double {
            switch self {
            case .preRollHalf: return 7.00
            case .preRollGram: return 9.00
            case .topShelfFlower: return 40.00
            case .midShelfFlower: return 25.00
            case .vapeCart: return 40.00
            case .edible: return 18.00
            case .concentrate: return 30.00
            }
        }
        
        /// Estimated number of sessions/uses per purchase — same "price ÷ units" pattern used for cigarette packs (÷20)
        var totalUsesPerPack: Double {
            switch self {
            case .preRollHalf, .preRollGram:
                return 1.0  // One-time use
            case .topShelfFlower, .midShelfFlower:
                return 7.0  // ~0.5g per session out of an eighth (3.5g)
            case .vapeCart:
                return 100.0 // ~100 pulls
            case .edible:
                return 10.0 // 10 servings per pack (10mg each)
            case .concentrate:
                return 20.0 // ~20 dabs per gram
            }
        }
    }

    // MARK: - Persisted Properties
    //
    // NOTE: These are intentionally plain stored properties (not @AppStorage).
    // @AppStorage requires @ObservationIgnored to compile inside an @Observable
    // class, which means the Observation framework never sees these values
    // change — SwiftUI won't re-render when they're mutated (e.g. tapping the
    // habit type toggle in Settings silently updates the model but the view
    // never redraws). Using plain stored properties keeps them inside
    // Observation's tracking, while `didSet` keeps them persisted manually.
    
    @ObservationIgnored
    private let defaults = UserDefaults.standard

    var habitTypeRaw: String {
        didSet { defaults.set(habitTypeRaw, forKey: "habitType") }
    }

    var selectedBrand: String {
        didSet { defaults.set(selectedBrand, forKey: "selectedBrand") }
    }

    var packPrice: Double {
        didSet { defaults.set(packPrice, forKey: "packPrice") }
    }

    var dailyReminders: Bool {
        didSet { defaults.set(dailyReminders, forKey: "dailyReminders") }
    }

    var totalResisted: Int {
        didSet { defaults.set(totalResisted, forKey: "totalResisted") }
    }

    init() {
        let defaults = UserDefaults.standard
        habitTypeRaw = defaults.string(forKey: "habitType") ?? HabitType.cigarettes.rawValue
        selectedBrand = defaults.string(forKey: "selectedBrand") ?? CigaretteBrand.marlboro.rawValue
        packPrice = defaults.object(forKey: "packPrice") != nil
            ? defaults.double(forKey: "packPrice")
            : CigaretteBrand.marlboro.defaultPrice
        dailyReminders = defaults.bool(forKey: "dailyReminders")
        totalResisted = defaults.integer(forKey: "totalResisted")
    }

    // MARK: - Computed Properties
    
    var habitType: HabitType {
        get { HabitType(rawValue: habitTypeRaw) ?? .cigarettes }
        set {
            habitTypeRaw = newValue.rawValue
            // Automatically switch selection and default price on habit type change
            if newValue == .cigarettes {
                selectedBrand = CigaretteBrand.marlboro.rawValue
                packPrice = CigaretteBrand.marlboro.defaultPrice
            } else {
                selectedBrand = CannabisProduct.preRollGram.rawValue
                packPrice = CannabisProduct.preRollGram.defaultPrice
            }
        }
    }

    /// Calculated price per single use/dose/cigarette
    var unitPrice: Double {
        if habitType == .cigarettes {
            return packPrice / 20.0 // 20 cigarettes per pack
        } else {
            let product = CannabisProduct(rawValue: selectedBrand) ?? .preRollGram
            return packPrice / product.totalUsesPerPack
        }
    }

    // MARK: - Helper Methods
    
    func selectBrandOrProduct(_ name: String) {
        selectedBrand = name
        if habitType == .cigarettes {
            if let brand = CigaretteBrand(rawValue: name) {
                packPrice = brand.defaultPrice
            }
        } else {
            if let cannabis = CannabisProduct(rawValue: name) {
                packPrice = cannabis.defaultPrice
            }
        }
    }

    /// Resets all stored user defaults and observable state back to initial default values.
    func resetToDefaults() {
        // Clear UserDefaults domain keys directly to remove persisted keys
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }

        // Reset view model properties back to initial defaults
        habitTypeRaw = HabitType.cigarettes.rawValue
        selectedBrand = CigaretteBrand.marlboro.rawValue
        packPrice = CigaretteBrand.marlboro.defaultPrice
        dailyReminders = false
        totalResisted = 0
    }
}
