//
//  ApplicationRouter.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 18/05/21.
//

import Foundation
import UIKit

/// Responsible for starting first screen and switching from one flow to another
/// For navigation inside same flow use ViewController routers
class GBApplicationRouter {
    static let shared = GBApplicationRouter()
    
    private init() {}
    
    /// Launches Marvel List flow
    ///
    /// Configures and launches flow on the Application window.
    ///
    func launchCharacterListFlow() {
        if let listVC = GBCharacterListViewController.getViewController() {
            let configurator = GBUILayerCharacterListConfigurator()
            configurator.configure(viewController: listVC)
            let navVC = UINavigationController.init(rootViewController: listVC)
            if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window {
                window?.rootViewController = navVC
            }
        }
    }
}
