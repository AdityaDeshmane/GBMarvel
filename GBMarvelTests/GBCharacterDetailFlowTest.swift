//
//  GBCharacterDetailFlow.swift
//  GBMarvelTests
//
//  Created by Aditya Deshmane on 20/05/21.
//

import XCTest
@testable import GBMarvel

class GBCharacterDetailFlowTest: XCTestCase {

    var asyncExpectation: XCTestExpectation?
    var presenterRequestDelegate: GBCharacterDetailPresenterRequestDelegate?// Keeping strong reference as its forward request delegate
    let charId = "1017100"
    
    func testCharacterDetailFlow() throws {
        asyncExpectation = XCTestExpectation.init(description: "Received Character Detail API response")
        
        guard let expectation = asyncExpectation else {
            XCTFail("Fail")
            print("Couldnt not create expectation")
            return
        }
        
        let presenter = GBCharacterDetailPresenter()
        presenter.presenterResponseDelegate = self
        presenterRequestDelegate = presenter
        
        let interactor = GBCharacterDetailInteractor()
        presenter.interactor = interactor
        interactor.interactorResponseDelegate = presenter

        let domainConfigurator = GBDomainLayerCharacterDetailConfigurator()
        domainConfigurator.configure(interactor: interactor)
        
        print("Creating fetch request")
        presenterRequestDelegate?.fetchCharacterDetail(charId: charId)
        print("Setting expectation timeout 20 sec")
        wait(for: [expectation], timeout: 20)
    }
}

extension GBCharacterDetailFlowTest: GBCharacterDetailPresenterResponseDelegate {
    
    func success(charDetail: GBUILayerCharacterDetail) {
        print("GBMarvelCharacterDetailFlowTests: success")
        print("Response: character name: " + charDetail.name)
        print("----")

        asyncExpectation?.fulfill()
    }
    
    func failed(error: GBUILayerError) {
        print("GBMarvelCharacterDetailFlowTests: failed")
        print("Response: error: \(GBUILayerErrorUtility.shared.stringForError(error: error))")
        XCTFail("Fail")
        print("----")
    }
}
