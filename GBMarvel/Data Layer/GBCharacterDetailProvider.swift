//
//  GBCharacterDetailProvider.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 19/05/21.
//

import Foundation
import SwiftyJSON

protocol GBCharacterDetailProviderRequestDelegate: class {
    func fetchCharacterDetail(charId: String)
}

protocol GBCharacterDetailProviderResponseDelegate: class {
    func receivedCharacterDetail(response: GBDataLayerCharacterDetailResponse)
}

struct GBDataLayerCharacterDetailData {
    /// Unique Id for character
    var charId: String
    /// Character name
    var name: String
    /// Description of the character
    var description: String
    /// Comics count
    var comics: UInt
    /// Series count
    var series: UInt
    /// Stories count
    var stories: UInt
    /// Events count
    var events: UInt
}

struct GBDataLayerCharacterDetailResponse {
    /// Custom result with character detail
    var result: Result<GBDataLayerCharacterDetailData, GBDataLayerError>
}

/// Request and response keys
private struct GBParamConstants {
    private init() { }
    static let characterId = "characterId"
    static let data = "data"
    static let results = "results"
    static let id = "id"
    static let name = "name"
    static let description = "description"
    static let series = "series"
    static let comics = "comics"
    static let stories = "stories"
    static let events = "events"
    static let available = "available"
}

class GBCharacterDetailProvider {
    weak var delegate: GBCharacterDetailProviderResponseDelegate?
    private var networkService: GBNetworkService?
}

extension GBCharacterDetailProvider: GBCharacterDetailProviderRequestDelegate {
    
    func fetchCharacterDetail(charId: String) {

        networkService = GBNetworkService()
        let request = GBRequest(type: .get,
                                path: GBDataLayerConstants.GBDataURLConstants.characterDetail+charId,
                                params: nil)
        networkService?.processRequest(request: request) { (response) in

            if let del = self.delegate {
                
                switch response.result {
                case .success(let data):
                    del.receivedCharacterDetail(response: self.parseRespose(data: data))
                case .failure(let err):
                    /*
                     404    Character not found.
                     */
                    let response = GBDataLayerCharacterDetailResponse(result: .failure(err))
                    del.receivedCharacterDetail(response: response)
                }
                
            
            }
        }
    }
    
    private func parseRespose(data: Any?) -> GBDataLayerCharacterDetailResponse {
                
        guard let json: [String: SwiftyJSON.JSON] = data as? [String: JSON] else {
            return GBDataLayerCharacterDetailResponse(result: .failure(.parseFail))
        }
        
        var responseData: GBDataLayerCharacterDetailData?
        
        if let itemArray = json[GBParamConstants.data]?[GBParamConstants.results].array {
            for dict in itemArray {
                let charId = dict[GBParamConstants.id].stringValue
                let name = dict[GBParamConstants.name].stringValue
                let description = dict[GBParamConstants.description].stringValue
                let comics = dict[GBParamConstants.comics][GBParamConstants.available].uIntValue
                let series = dict[GBParamConstants.series][GBParamConstants.available].uIntValue
                let stories = dict[GBParamConstants.stories][GBParamConstants.available].uIntValue
                let events = dict[GBParamConstants.events][GBParamConstants.available].uIntValue
                
                responseData = GBDataLayerCharacterDetailData(charId: charId,
                                                              name: name,
                                                              description: description,
                                                              comics: comics,
                                                              series: series,
                                                              stories: stories,
                                                              events: events)
                break
            }
        }
        
        if let response =  responseData {
            return GBDataLayerCharacterDetailResponse(result: .success(response))
        } else {
            return GBDataLayerCharacterDetailResponse(result: .failure(.apiFailure))
        }
    }
}
