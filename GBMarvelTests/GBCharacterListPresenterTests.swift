//
//  GBCharacterListPresenterTests.swift
//  GBMarvelTests
//
//  Created by Aditya Deshmane on 21/05/21.
//

import XCTest
@testable import GBMarvel


class GBCharacterListPresenterTests: XCTestCase {

    let presenter = GBCharacterListPresenter()
    let viewMock = GBCharacterListViewControllerMock()
    override func setUp() {
        presenter.interactor = GBCharacterListInteractorMock()
        presenter.presenterResponseDelegate = viewMock
    }
    
    /// Presenter to ViewController model conversion test
    func testfetchCharacterListPresenterResponse() {
        let item =  GBDomainLayerCharacterListItem(charId: "1111", name: "OneOne", description: "The one")
        let data =  GBDomainLayerCharacterListData(arrCharacters: [item], limit: 1, offset: 1, total: 1)
        let response = GBDomainLayerCharacterListResponse(result: .success(data))
        presenter.receivedCharacterList(response: response)
        
        if let mockViewController = presenter.presenterResponseDelegate as? GBCharacterListViewControllerMock {
            
            if let success = mockViewController.successValue, let character = success.first {
                XCTAssertEqual(character.charId, "1111")
                XCTAssertEqual(character.name, "OneOne")
                XCTAssertEqual(character.description, "The one")
            } else {
                XCTFail("Fail")
            }
        }
    }
    
    /// Interactor to Presenter response check
    func testfetchCharacterListInteractorResponse() throws {
        presenter.fetchCharacterListUsingPagination()
        
        let mockInteractor = presenter.interactor as? GBCharacterListInteractorMock
        if let response =  mockInteractor?.response {
            switch response.result {
            case .success(let data):
                XCTAssertEqual(data.arrCharacters.first?.charId, "1111")
            case .failure:
                XCTFail("Fail")
            }
        } else {
            XCTFail("Fail")
        }
    }
}

class GBCharacterListInteractorMock: GBCharacterListInteractorRequestDelegate, GBCharacterListInteractorResponseDelegate {

    var response: GBDomainLayerCharacterListResponse?

    func fetchCharacterList(offset: UInt, limit: UInt) {
        
        let item =  GBDomainLayerCharacterListItem(charId: "1111", name: "OneOne", description: "The one")
        let data =  GBDomainLayerCharacterListData(arrCharacters: [item], limit: 1, offset: 1, total: 1)
        let response = GBDomainLayerCharacterListResponse(result: .success(data))
        self.receivedCharacterList(response: response)
    }

    func receivedCharacterList(response: GBDomainLayerCharacterListResponse) {
        self.response = response
    }
}

class GBCharacterListViewControllerMock: GBCharacterListPresenterResponseDelegate {
    
    var successValue: [GBUILayerCharacterListItem]?
    var errorValue: GBUILayerError?
    
    func success(arrCharacters: [GBUILayerCharacterListItem]) {
        successValue = arrCharacters
    }
    
    func failed(error: GBUILayerError) {
        errorValue = error
    }
}
