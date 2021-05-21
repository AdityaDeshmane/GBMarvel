//
//  GBMarvelTests.swift
//  GBMarvelTests
//
//  Created by Aditya Deshmane on 18/05/21.
//

import XCTest
@testable import GBMarvel

class GBCharacterListFlowTests: XCTestCase {
    
    var asyncExpectation: XCTestExpectation?
    var presenterRequestDelegate: GBCharacterListPresenterRequestDelegate?// Keeping strong reference as its forward request delegate
    
    func testCharacterListFlow() throws {
        asyncExpectation = XCTestExpectation.init(description: "Received CharacterList API response")
        
        guard let expectation = asyncExpectation else {
            XCTFail("Fail")
            print("Couldnt not create expectation")
            return
        }
        
        let presenter = GBCharacterListPresenter()
        presenter.presenterResponseDelegate = self
        presenterRequestDelegate = presenter
        
        let interactor = GBCharacterListInteractor()
        presenter.interactor = interactor
        interactor.interactorResponseDelegate = presenter

        let domainConfigurator = GBDomainLayerCharacterListConfigurator()
        domainConfigurator.configure(interactor: interactor)
        
        print("Creating fetch request")
        presenterRequestDelegate?.fetchCharacterListUsingPagination()
        print("Setting expectation timeout 20 sec")
        wait(for: [expectation], timeout: 20)
    }
}

extension GBCharacterListFlowTests: GBCharacterListPresenterResponseDelegate {
    
    func success(arrCharacters: [GBUILayerCharacterListItem]) {
        print("GBMarvelCharacterListFlowTests: success")
        print("Response: character list count:  \(arrCharacters.count)")
        print("----")
        asyncExpectation?.fulfill()
    }
    
    func failed(error: GBUILayerError) {
        print("GBMarvelCharacterListFlowTests: failed")
        print("Response: error: \(GBUILayerErrorUtility.shared.stringForError(error: error))")
        XCTFail("Fail")
        print("----")
    }
}
