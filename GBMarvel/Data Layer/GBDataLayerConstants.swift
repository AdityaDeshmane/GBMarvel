//
//  GBDataLayerConstants.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation


struct GBDataLayerConstants {
    
    private init() { }

    /// Base network service constants
    struct GBDataNetworkConstants {
        
        private init() { }
        
        static let baseURL = "https://gateway.marvel.com:443/v1/public"
        static let publicKey = "71ea64df233c86ed9b1772091e93727f"
        static let privateKey = "7ab65681429d88bea7773468a0ed6d94a4495b54"
        static let reachabilityURL = "www.apple.com"
    }
    
    /// API path strings suffixes
    struct GBDataURLConstants {
        
        private init() { }

        static let characterList = "characters"
        static let characterDetail = "characters/"
    }
    
  
    
}
