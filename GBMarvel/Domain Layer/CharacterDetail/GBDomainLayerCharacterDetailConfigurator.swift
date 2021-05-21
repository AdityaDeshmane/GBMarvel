//
//  GBDomainLayerCharacterDetailConfigurator.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 20/05/21.
//

import Foundation

/// A standard configurator for setting up Domain layer connections
class GBDomainLayerCharacterDetailConfigurator {
    
    func configure(interactor: GBCharacterDetailInteractor) {
        
        let provider = GBCharacterDetailProvider()
        provider.delegate = interactor
        interactor.providerRequestDelegate = provider
    }
}
