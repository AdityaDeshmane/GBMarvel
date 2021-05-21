//
//  GBDomainLayerCharacterListConfigurator.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 20/05/21.
//

import Foundation

/// A standard configurator for setting up Domain layer connections
class GBDomainLayerCharacterListConfigurator {
    
    func configure(interactor: GBCharacterListInteractor) {
        
        let provider = GBCharacterListProvider()
        provider.delegate = interactor
        interactor.providerRequestDelegate = provider
    }
}
