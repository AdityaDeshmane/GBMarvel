//
//  GBLocalisationConstants.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 18/05/21.
//

import Foundation


struct LocalisationKey {
    private init() { }
    
    // MARK: - Localisation Key Structs per View Controller
    struct MarvelCharacterList {
        private init() { }
        static let title = "marvel_list_title".localizedString()
        static let footerTitle = "marvel_list_footer_title".localizedString()
    }
    
    struct MarvelCharacterDetail {
        private init() { }
        static let title = "marvel_detail_title".localizedString()
        static let loadingTitle = "marvel_detail_loading_title".localizedString()
        static let name = "marvel_detail_name".localizedString()
        static let description = "marvel_detail_description".localizedString()
        static let comics = "marvel_detail_comics".localizedString()
        static let series = "marvel_detail_series".localizedString()
        static let stories = "marvel_detail_stories".localizedString()
        static let events = "marvel_detail_events".localizedString()
    }
    
    // MARK: - Localisation Key Struct for common utility
    struct ErrorMessage {
        private init() { }
        static let network = "network".localizedString()
        static let apiFailure = "api_failure".localizedString()
        static let unknown = "unknown".localizedString()
    }
    
    struct GenericTexts {
        private init() { }
        static let ok = "ok".localizedString()
    }
}
