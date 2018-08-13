//
//  Milliunits+Extension.swift
//  KNAB
//
//  Created by TQL Mobile on 8/7/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import Foundation
import BudgetKit

extension Milliunits {
    var dollarAmount: String {
        let formatter = NumberFormatter()
        let locale = Locale(identifier: "en_US")
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        let double = YNAB.convertMilliUnitsToCurrencyAmount(self, currencyDecimalDigits: 2)!
        let number = double as NSNumber
        return formatter.string(from: number)!
    }
}
