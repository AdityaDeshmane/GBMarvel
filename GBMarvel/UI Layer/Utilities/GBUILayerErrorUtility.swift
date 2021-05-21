//
//  GBUILayerErrorUtility.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 19/05/21.
//

import Foundation

enum GBUILayerError: Error {
    case apiFailure
    case networkError
    case unknown
}

class GBUILayerErrorUtility {

    static let shared = GBUILayerErrorUtility()
    private init() {}
    
    /// Provides string for error.
    ///
    /// Provide localised string message for error case. Text are for end user display.
    ///
    /// - Parameters:
    ///   - error: The UI layer specific error
    func stringForError(error: GBUILayerError) -> String {
        var errorMessage = ""
        switch error {
        case .apiFailure:
            errorMessage = LocalisationKey.ErrorMessage.apiFailure
        case .networkError:
            errorMessage = LocalisationKey.ErrorMessage.network
        case .unknown:
            errorMessage = LocalisationKey.ErrorMessage.unknown
        }
        return errorMessage
    }
}
