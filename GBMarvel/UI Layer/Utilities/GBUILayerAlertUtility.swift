//
//  GBUILayerAlertUtility.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 19/05/21.
//

import Foundation
import UIKit

class GBUILayerAlertUtility {
    static let shared = GBUILayerAlertUtility()
    
    private init() {}
    
    /// Provides native UIAlertController object for message.
    ///
    /// Alert provided will have emtpy title and "Ok" button to dismiss in localised format.
    ///
    /// - Parameters:
    ///   - message: The message to show in alert.
    func createSimpleAlertWithMessage(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: LocalisationKey.GenericTexts.ok, style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}
