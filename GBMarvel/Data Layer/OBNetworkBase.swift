//
//  OBNetworkBase.swift
//  OBMarvel
//
//  Created by Aditya Deshmane on 15/05/21.
//

import Foundation
import Alamofire
import SwiftyJSON

enum OBResponseStatus: Int {
    case success = 1
    case failure = 2
}

protocol OBResponse {
    var status: OBResponseStatus { get set }
    var error: Error? { get set }
}

struct OBBaseResponse: OBResponse {
    var status: OBResponseStatus
    var data: Any?
    var error: Error?
}

enum OBRequestType: Int {
    case get = 1
    case post = 2
}

struct OBNetworkService {
    
    let baseURL = "https://gateway.marvel.com:443/v1/public"
    private let apikey = "apikey=71ea64df233c86ed9b1772091e93727f"

    private func constructUrlFor(strPath: String, type: OBRequestType) -> String {
        switch type {
        case .get:
            return baseURL + "/" + strPath + "?" + apikey

        case .post:
            return baseURL + "/" + strPath + apikey
        }
    }
    
    func processRequest(path: String, requestType: OBRequestType, completion: @escaping ((_ response: OBBaseResponse) -> Void)) {
        
        guard let url = URL(string: constructUrlFor(strPath: path, type: requestType)) else {
            let error =  NSError(domain: "com.ob.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(OBBaseResponse(status: .failure, data: "", error: error))
            return
        }
        
        print("OBNetworkBase: url: " + url.absoluteString)
        
        AF.request(url, method: .get).responseJSON { (response) in

            switch response.result {
            case .success(let data):
                let json = JSON(data)
                print("OBNetworkBase: success : response: \(json)")
                completion(OBBaseResponse(status: .success, data: json, error: nil))
                
            case .failure(let error):
                print("OBNetworkBase: failure : error: \(error)")
                completion(OBBaseResponse(status: .failure, data: nil, error: error))
            }
        }
    }
}
