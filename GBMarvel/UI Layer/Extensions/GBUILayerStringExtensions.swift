//
//  GBUILayerStringExtensions.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 18/05/21.
//

import Foundation

extension String {
    
    /// Returns string as per current "Localisation" string file from "main" bundle.
    ///
    /// - Parameters:
    ///   - bundle: Uses "main" bundle as default value provide custom bundle if applicable
    ///   - tableName: Uses "Localisation" as default string file provide custom file name if applicable
    func localizedString(bundle: Bundle = .main, tableName: String = "Localisation") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
