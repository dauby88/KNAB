//
//  UserDefaults+Extension.swift
//  KNAB
//
//  Created by TQL Mobile on 8/1/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import Foundation
import BudgetKit

extension UserDefaults {
    
    static var selectedBudgetID: UUID? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "SelectedBudgetID") else { return nil }
            return UUID(uuidString: string)
        }
        set {
            let string = newValue?.uuidString
            UserDefaults.standard.set(string, forKey: "SelectedBudgetID")
        }
    }
    
    static var selectedSpendCategoryID: UUID? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "SpendCategory") else { return nil }
            return UUID(uuidString: string)
        }
        set {
            let string = newValue?.uuidString
            UserDefaults.standard.set(string, forKey: "SpendCategory")
        }
    }
    
    static var selectedSaveCategoryID: UUID? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "SaveCategory") else { return nil }
            return UUID(uuidString: string)
        }
        set {
            let string = newValue?.uuidString
            UserDefaults.standard.set(string, forKey: "SaveCategory")
        }
    }
    
    static var selectedGiveCategoryID: UUID? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "GiveCategory") else { return nil }
            return UUID(uuidString: string)
        }
        set {
            let string = newValue?.uuidString
            UserDefaults.standard.set(string, forKey: "GiveCategory")
        }
    }
    
}
