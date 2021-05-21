//
//  GBCharacterListProvider.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation
import SwiftyJSON

protocol GBCharacterListProviderRequestDelegate: class {
    func fetchCharacterList(offset: UInt, limit: UInt)
}

protocol GBCharacterListProviderResponseDelegate: class {
    func receivedCharacterList(response: GBDataLayerCharacterListResponse)
}

struct GBDataLayerCharacterListItem {
    /// Unique Id for character
    var charId: String
    /// Character name
    var name: String
    /// Description of the character
    var description: String
}

struct GBDataLayerCharacterListData {
    /// Characters
    var arrayCharacters: [GBDataLayerCharacterListItem]
    /// Number of characters to fetched
    var limit: UInt
    /// Fetched from index
    var offset: UInt
    /// Total characters available
    var total: UInt
}

struct GBDataLayerCharacterListResponse {
    /// Custom result with character array or error
    var result: Result<GBDataLayerCharacterListData, GBDataLayerError>
}

/// Request and response keys
private struct GBParamConstants {
    private init() { }
    static let offset = "offset"
    static let limit = "limit"
    static let data = "data"
    static let total = "total"
    static let results = "results"
    static let id = "id"
    static let name = "name"
    static let description = "description"
}

class GBCharacterListProvider {
    weak var delegate: GBCharacterListProviderResponseDelegate?
    private var networkService: GBNetworkService?
}

extension GBCharacterListProvider: GBCharacterListProviderRequestDelegate {
    
    func fetchCharacterList(offset: UInt, limit: UInt) {

        networkService = GBNetworkService()
        let params = [GBParamConstants.offset: String(offset), GBParamConstants.limit: String(limit)]
        let request = GBRequest(type: .get,
                                path: GBDataLayerConstants.GBDataURLConstants.characterList,
                                params: params)
        networkService?.processRequest(request: request) { (response) in

            if let del = self.delegate {
                
                switch response.result {
                case .success(let data):
                    del.receivedCharacterList(response: self.parseRespose(data: data))
                case .failure(let err):
                    /*
                     409    Limit greater than 100.
                     409    Limit invalid or below 1.
                     409    Invalid or unrecognized parameter.
                     409    Empty parameter.
                     409    Invalid or unrecognized ordering parameter.
                     409    Too many values sent to a multi-value list filter.
                     409    Invalid value passed to filter.
                     */
                    let response = GBDataLayerCharacterListResponse(result: .failure(err))
                    del.receivedCharacterList(response: response)
                }
                
            
            }
        }
    }
    
    private func parseRespose(data: Any?) -> GBDataLayerCharacterListResponse {
        
        var characterItems: [GBDataLayerCharacterListItem] = []
        
        guard let json: [String: SwiftyJSON.JSON] = data as? [String: JSON] else {
            return GBDataLayerCharacterListResponse(result: .failure(.parseFail))
        }
        
        let limit = json[GBParamConstants.data]?[GBParamConstants.limit].uIntValue ?? 0
        let offset = json[GBParamConstants.data]?[GBParamConstants.offset].uIntValue ?? 0
        let total = json[GBParamConstants.data]?[GBParamConstants.total].uIntValue ?? 0

        if let itemArray = json[GBParamConstants.data]?[GBParamConstants.results].array {
            for dict in itemArray {
                characterItems.append(GBDataLayerCharacterListItem(charId: dict[GBParamConstants.id].stringValue,
                                                                   name: dict[GBParamConstants.name].stringValue,
                                                                   description: dict[GBParamConstants.description].stringValue))
            }
        }
        
        let result = GBDataLayerCharacterListData(arrayCharacters: characterItems, limit: limit, offset: offset, total: total)
        return GBDataLayerCharacterListResponse(result: .success(result))
    }
}
