//
//  NumberFormatter+Extensions.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 21/12/2025.
//

import Foundation

extension Double {
    func formatted(decimals: Int = 1, currency: Bool = false) -> String {
        let absValue = abs(self)
        let sign = self < 0 ? "-" : ""
        let currencySign = currency ? "$" : ""
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals == 0 ? 0 : 0
        
        switch absValue {
        case 1_000_000_000...:
            let billions = absValue / 1_000_000_000
            let formatted = formatter.string(from: NSNumber(value: billions)) ?? "\(billions)"
            return "\(sign)\(currencySign)\(formatted)B"
        case 1_000_000...:
            let millions = absValue / 1_000_000
            let formatted = formatter.string(from: NSNumber(value: millions)) ?? "\(millions)"
            return "\(sign)\(currencySign)\(formatted)M"
        case 1_000...:
            let thousands = absValue / 1_000
            let formatted = formatter.string(from: NSNumber(value: thousands)) ?? "\(thousands)"
            return "\(sign)\(currencySign)\(formatted)K"
        default:
            let formatted = formatter.string(from: NSNumber(value: absValue)) ?? "\(absValue)"
            return "\(sign)\(currencySign)\(formatted)"
        }
    }
    
    func formattedChange(decimals: Int = 1) -> String {
        let sign = self >= 0 ? "+" : ""
        return "\(sign)\(self.formatted(decimals: decimals))%"
    }
}

extension Int {
    func formatted(decimals: Int = 1, currency: Bool = false) -> String {
        Double(self).formatted(decimals: decimals, currency: currency)
    }
}
