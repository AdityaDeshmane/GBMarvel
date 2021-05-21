//
//  GBCharacterDetailInteractor.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 19/05/21.
//

import Foundation

protocol GBCharacterDetailInteractorRequestDelegate: class {
    func fetchCharacterDetail(charId: String)
}

protocol GBCharacterDetailInteractorResponseDelegate: class {
    func receivedCharacterDetail(response: GBDomainLayerCharacterDetailResponse)
}

struct GBDomainLayerCharacterDetailData {
    var charId: String
    var name: String
    var description: String
    var comics: UInt
    var series: UInt
    var stories: UInt
    var events: UInt
}

struct GBDomainLayerCharacterDetailResponse {
    var result: Result<GBDomainLayerCharacterDetailData, GBDomainLayerError>
}

class GBCharacterDetailInteractor {
    weak var interactorResponseDelegate: GBCharacterDetailInteractorResponseDelegate?
    var providerRequestDelegate: GBCharacterDetailProviderRequestDelegate?// Keeping strong reference as its forward request delegate
}

// MARK: - GBCharacterDetailInteractorRequestDelegate
extension GBCharacterDetailInteractor: GBCharacterDetailInteractorRequestDelegate {
    
    func fetchCharacterDetail(charId: String) {
        providerRequestDelegate?.fetchCharacterDetail(charId: charId)
    }
}

// MARK: - GBCharacterDetailProviderResponseDelegate
extension GBCharacterDetailInteractor: GBCharacterDetailProviderResponseDelegate {
    
    func receivedCharacterDetail(response: GBDataLayerCharacterDetailResponse) {

        if let del = interactorResponseDelegate {
            del.receivedCharacterDetail(response: convertDataLayerModelToDomainLayerModel(response: response))
        }
    }
    
    private func convertDataLayerModelToDomainLayerModel(response: GBDataLayerCharacterDetailResponse) -> GBDomainLayerCharacterDetailResponse {
        
        switch response.result {
        
        case .success(let data):
            let result = GBDomainLayerCharacterDetailData(charId: data.charId,
                                                          name: data.name,
                                                          description: (data.description.isEmpty ? "-" : data.description),
                                                          comics: data.comics,
                                                          series: data.series,
                                                          stories: data.stories,
                                                          events: data.events)
            return GBDomainLayerCharacterDetailResponse(result: .success(result))
            
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
            
            return GBDomainLayerCharacterDetailResponse(result: .failure(domainErr))
        }
    }
}
