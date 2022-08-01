//
//  PaymentActivityModel.swift
//  Expense Tracker
//
//  Created by Tsenguun on 1/8/22.
//

import Foundation
import CoreData

enum PaymentCategory: Int {
    case income = 0
    case expense = 1
}

public class ExpensesActivity: NSManagedObject {
    
    @NSManaged public var paymendId: UUID
    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var address: String?
    @NSManaged public var amount: Double
    @NSManaged public var memo: String?
    @NSManaged public var typeNum: Int32
}

extension ExpensesActivity: Identifiable {
    var type: PaymentCategory {
        get {
            return PaymentCategory(rawValue: Int(typeNum)) ?? .expense
        }
        
        set {
            self.typeNum = Int32(newValue.rawValue)
        }
    }
}
