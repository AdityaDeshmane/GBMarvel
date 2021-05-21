//
//  GBCharacterDetailPresenter.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 19/05/21.
//

import Foundation

protocol GBCharacterDetailPresenterRequestDelegate: class {
    func fetchCharacterDetail(charId: String)
}

protocol GBCharacterDetailPresenterResponseDelegate: class {
    func success(charDetail: GBUILayerCharacterDetail)
    func failed(error: GBUILayerError)
}

struct GBUILayerCharacterDetailResponse {
    var result: Result<GBUILayerCharacterDetail, GBUILayerError>
}

struct GBUILayerCharacterDetail {
    var charId: String
    var name: String
    var description: String
    var comics: UInt
    var series: UInt
    var stories: UInt
    var events: UInt
}

class GBCharacterDetailPresenter {
    weak var presenterResponseDelegate: GBCharacterDetailPresenterResponseDelegate?
    var interactor: GBCharacterDetailInteractorRequestDelegate?
}

// MARK: - GBCharacterDetailPresenterRequestDelegate
extension GBCharacterDetailPresenter: GBCharacterDetailPresenterRequestDelegate {
    
    func fetchCharacterDetail(charId: String) {
        interactor?.fetchCharacterDetail(charId: charId)
    }
}

// MARK: - GBCharacterDetailInteractorResponseDelegate
extension GBCharacterDetailPresenter: GBCharacterDetailInteractorResponseDelegate {
    
    func receivedCharacterDetail(response: GBDomainLayerCharacterDetailResponse) {

        if let del = presenterResponseDelegate {
            
            let data = convertDomainLayerModelToUILayerModel(response: response)
            switch data.result {
            case .success(let charDetail):
                del.success(charDetail: charDetail)
            case .failure(let error):
                del.failed(error: error)
            }
        }
    }
    
    ///Convert domain model to UI suitable model
    private func convertDomainLayerModelToUILayerModel(response: GBDomainLayerCharacterDetailResponse) -> GBUILayerCharacterDetailResponse {
        
        switch response.result {
        case .success(let data):
            let data = GBUILayerCharacterDetail(charId: data.charId,
                                                name: data.name,
                                                description: data.description,
                                                comics: data.comics,
                                                series: data.series,
                                                stories: data.stories,
                                                events: data.events)
            return GBUILayerCharacterDetailResponse(result: .success(data))
            
        case .failure(let error):
            var err: GBUILayerError = .unknown
            switch error {
            case .apiFailure:
                err = .apiFailure
            case .networkError:
                err = .networkError
            case .unknown:
                err = .unknown
            }
            return GBUILayerCharacterDetailResponse(result: .failure(err))
        }
    }
}
