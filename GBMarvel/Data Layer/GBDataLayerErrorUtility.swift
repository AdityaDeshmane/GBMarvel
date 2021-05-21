//
//  GBDataLayerErrorUtility.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation

enum GBDataLayerError: Error {
    case apiFailure
    case apiInvalid
    case parseFail
    case networkError
    case unknown
}
