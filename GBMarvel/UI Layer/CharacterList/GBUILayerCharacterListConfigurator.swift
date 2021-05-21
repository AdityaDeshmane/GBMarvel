//
//  GBCharacterListConfigurator.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 18/05/21.
//

import Foundation

/// A standard configurator for setting up UI layer connections
class GBUILayerCharacterListConfigurator {
    
    func configure(viewController: GBCharacterListViewController) {
        
        let router = GBCharacterListRouter()
        viewController.router = router
        
        let presenter = GBCharacterListPresenter()
        viewController.presenterRequestDelegate = presenter
        presenter.presenterResponseDelegate = viewController
        
        let interactor = GBCharacterListInteractor()
        presenter.interactor = interactor
        interactor.interactorResponseDelegate = presenter

        /// To keep layer logic separate, domain layer will perform its own connection logic
        let domainConfigurator = GBDomainLayerCharacterListConfigurator()
        domainConfigurator.configure(interactor: interactor)
    }
}
