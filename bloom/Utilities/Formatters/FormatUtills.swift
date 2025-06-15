//
//  FormatUtills.swift
//  bloom
//
//  Created by Mark Brown on 15/06/2025.
//

import Foundation

struct FormatUtills {
    
    func format(distance: Double, with unit: MeasurementUnit = .metric) -> String {
        switch unit {
        case .metric:
            let km = distance / 1000.0
            return km < 10 ? String(format: "%.1fkm", km) : String(format: "%.0fkm", km)
        case .imperial:
            let formatter = MeasurementFormatter()
            formatter.unitOptions = .naturalScale
            formatter.numberFormatter.maximumFractionDigits = 1
            formatter.locale = Locale(identifier: "en_US")
            
            let meters = Measurement(value: distance, unit: UnitLength.meters)
            return formatter.string(from: meters)
        }
    }
}
