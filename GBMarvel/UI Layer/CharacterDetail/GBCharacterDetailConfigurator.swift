//
//  GBCharacterDetailConfigurator.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 19/05/21.
//

import Foundation

/// A standard configurator for setting up UI layer connections
class GBCharacterDetailConfigurator {
    
    func configure(viewController: GBCharacterDetailViewController) {
        
        let presenter = GBCharacterDetailPresenter()
        viewController.presenterRequestDelegate = presenter
        presenter.presenterResponseDelegate = viewController
        
        let interactor = GBCharacterDetailInteractor()
        presenter.interactor = interactor
        interactor.interactorResponseDelegate = presenter

        /// To keep layer logic separate, domain layer will perform its own connection logic
        let domainConfigurator = GBDomainLayerCharacterDetailConfigurator()
        domainConfigurator.configure(interactor: interactor)
    }
}
