//
//  NumberFormatter+Ext.swift
//  PFinance
//
//  Created by Tsenguun on 2/8/22.
//

import Foundation

extension NumberFormatter {
    static func currency(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let formattedValue = formatter.string(from: NSNumber(value: value)) ?? ""
        
        return "$" + formattedValue
    }
}
