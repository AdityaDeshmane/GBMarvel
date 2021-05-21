//
//  GBCharacterListRouter.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 18/05/21.
//

import Foundation
import UIKit

class GBCharacterListRouter {
    
    func rowClicked(navController: UINavigationController, characterId: String) {
        if let detailVC = GBCharacterDetailViewController.getViewController() {
            detailVC.inputParameters(charId: characterId)
            let configurator = GBCharacterDetailConfigurator()
            configurator.configure(viewController: detailVC)
            navController.pushViewController(detailVC, animated: true)
        }
    }
}
