//
//  TapModel.swift
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
    var brand: String
    var price: Double
    
    init(brand: String, price: Double, time: Date = Date(), id: UUID = UUID()) {
        self.id = id
        self.time = time
        self.brand = brand
        self.price = price
    }
}
