//
//  KidsCategory.swift
//  KNAB
//
//  Created by TQL Mobile on 8/18/18.
//  Copyright © 2018 Dauby Cafe. All rights reserved.
//

import UIKit

enum KidsCategory: String {
    case spend
    case give
    case save
    
    var color: UIColor {
        switch self {
        case .spend:
            return UIColor.ynabGreen
        case .give:
            return UIColor.ynabRed
        case .save:
            return UIColor.ynabLightBlue
        }
    }
    
    var name: String {
        return self.rawValue.capitalized
    }
    
    var selectedID: UUID? {
        switch self {
        case .spend:
            return UserDefaults.selectedSpendCategoryID
        case .give:
            return UserDefaults.selectedGiveCategoryID
        case .save:
            return UserDefaults.selectedSaveCategoryID
        }
    }
}
