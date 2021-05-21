//
//  GBCharacterListInteractor.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation

protocol GBCharacterListInteractorRequestDelegate: class {
    func fetchCharacterList(offset: UInt, limit: UInt)
}

protocol GBCharacterListInteractorResponseDelegate: class {
    func receivedCharacterList(response: GBDomainLayerCharacterListResponse)
}

struct GBDomainLayerCharacterListItem {
    var charId: String
    var name: String
    var description: String
}

struct GBDomainLayerCharacterListData {
    var arrCharacters: [GBDomainLayerCharacterListItem]
    var limit: UInt
    var offset: UInt
    var total: UInt
}

struct GBDomainLayerCharacterListResponse {
    var result: Result<GBDomainLayerCharacterListData, GBDomainLayerError>
}

class GBCharacterListInteractor {
    weak var interactorResponseDelegate: GBCharacterListInteractorResponseDelegate?
    var providerRequestDelegate: GBCharacterListProviderRequestDelegate?// Keeping strong reference as its forward request delegate
}

// MARK: - GBCharacterListInteractorRequestDelegate
extension GBCharacterListInteractor: GBCharacterListInteractorRequestDelegate {
    
    func fetchCharacterList(offset: UInt, limit: UInt) {
        providerRequestDelegate?.fetchCharacterList(offset: offset, limit: limit)
    }
}

// MARK: - GBCharacterListProviderResponseDelegate
extension GBCharacterListInteractor: GBCharacterListProviderResponseDelegate {
    
    func receivedCharacterList(response: GBDataLayerCharacterListResponse) {

        if let del = interactorResponseDelegate {
            del.receivedCharacterList(response: convertDataLayerModelToDomainLayerModel(response: response))
        }
    }
    
    private func convertDataLayerModelToDomainLayerModel(response: GBDataLayerCharacterListResponse) -> GBDomainLayerCharacterListResponse {
        
        switch response.result {
        
        case .success(let data):
            
            var arrCharacters: [GBDomainLayerCharacterListItem] = []
            
            for item in data.arrayCharacters {
                arrCharacters.append(GBDomainLayerCharacterListItem(charId: item.charId,
                                                                    name: item.name,
                                                                    description: (item.description.isEmpty ? "-" : item.description)))// Provide text "-" if no description available
            }
            
            let result = GBDomainLayerCharacterListData(arrCharacters: arrCharacters, limit: data.limit, offset: data.offset, total: data.total)
                
            return GBDomainLayerCharacterListResponse(result: .success(result))
            
        case .failure(let err):
            
            var domainErr: GBDomainLayerError = .unknown
            
            switch err {
            case .networkError:
                domainErr = .networkError
            case .apiFailure, .apiInvalid, .parseFail:
                domainErr = .apiFailure
            default:
                domainErr = .unknown
            }
            
            return GBDomainLayerCharacterListResponse(result: .failure(domainErr))
        }
    }
}
