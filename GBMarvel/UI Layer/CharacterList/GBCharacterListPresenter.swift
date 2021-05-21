//
//  GBCharacterListPresenter.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation

protocol GBCharacterListPresenterRequestDelegate: class {
    @discardableResult func fetchCharacterListUsingPagination() -> Bool
}

protocol GBCharacterListPresenterResponseDelegate: class {
    func success(arrCharacters: [GBUILayerCharacterListItem])
    func failed(error: GBUILayerError)
}

struct GBUILayerCharacterListResponse {
    var result: Result<[GBUILayerCharacterListItem], GBUILayerError>
}

struct GBUILayerCharacterListItem {
    var charId: String
    var name: String
    var description: String
}

class GBCharacterListPresenter {
    
    weak var presenterResponseDelegate: GBCharacterListPresenterResponseDelegate?
    /// Number of characters to request in one call
    private let pageSize: UInt = 50 //max value allowed 100
    private var totalCharacters: UInt = 0
    private var arrCharacter: [GBUILayerCharacterListItem] = []
    var interactor: GBCharacterListInteractorRequestDelegate?
    /// Process only one request at a time
    private var inProgressRequest = false
}

// MARK: - GBCharacterListPresenterRequestDelegate
extension GBCharacterListPresenter: GBCharacterListPresenterRequestDelegate {
    
    @discardableResult func fetchCharacterListUsingPagination() -> Bool {
    
        // Block back to back request
        if inProgressRequest {
            return false
        }
        
        // Check whether all data is already fetched
        if  totalCharacters == 0 || arrCharacter.count < totalCharacters {
            inProgressRequest = true
            interactor?.fetchCharacterList(offset: UInt(arrCharacter.count), limit: pageSize)
            return true
        }
        return false
    }
}

// MARK: - GBCharacterListInteractorResponseDelegate
extension GBCharacterListPresenter: GBCharacterListInteractorResponseDelegate {
    
    func receivedCharacterList(response: GBDomainLayerCharacterListResponse) {
        inProgressRequest = false
        
        switch response.result {
        case .success(let data):
            totalCharacters = data.total
        default:
            break
        }
        
        if let del = presenterResponseDelegate {
            let data = convertDomainLayerModelToUILayerModel(response: response)
            
            switch data.result {
            case .success(let arr):
                arrCharacter.append(contentsOf: arr)
                del.success(arrCharacters: arr)
            case .failure(let error):
                del.failed(error: error)
            }
        }
    }
    
    /// Convert domain model to UI suitable model
    private func convertDomainLayerModelToUILayerModel(response: GBDomainLayerCharacterListResponse) -> GBUILayerCharacterListResponse {
        
        switch response.result {
        case .success(let data):
            var arrCharacter: [GBUILayerCharacterListItem] = []
            for item in data.arrCharacters {
                arrCharacter.append(GBUILayerCharacterListItem(charId: item.charId, name: item.name, description: item.description))
            }
            return GBUILayerCharacterListResponse(result: .success(arrCharacter))
            
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
            return GBUILayerCharacterListResponse(result: .failure(err))
        }
    }
}
