//
//  GBNetworkBase.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Network

enum GBRequestType: Int {
    case get = 1
    case post = 2
}

/// Request
struct GBRequest {
    var type: GBRequestType
    var path: String
    var params: [String: Any]?
}

/// Response
struct GBBaseResponse {
    var result: Result<Any?, GBDataLayerError>
}

struct GBNetworkService {
    
    func processRequest(request: GBRequest, completion: @escaping ((_ response: GBBaseResponse) -> Void)) {
        
        guard let url = URL(string: constructUrlFor(request: request)) else {
            DispatchQueue.main.async {
                completion(GBBaseResponse(result: .failure(.apiInvalid)))
            }
            return
        }
        
        if let networkManager = NetworkReachabilityManager(host: GBDataLayerConstants.GBDataNetworkConstants.reachabilityURL), networkManager.isReachable ==  false {
            print("GBNetworkService: url: Network not reachable")
            DispatchQueue.main.async {
                completion(GBBaseResponse(result: .failure(.networkError)))
            }
            return
        }

        print("GBNetworkService: url: " + url.absoluteString)
        
        AF.request(url, method: .get).responseJSON { (response) in

            switch response.result {
            case .success(let data):
                let json = JSON(data)
                print("GBNetworkService: success ")
                DispatchQueue.main.async {
                    completion(GBBaseResponse(result: .success(json.dictionaryValue)))
                }
                
            case .failure(let error):
                print("GBNetworkService: failure : error: \(error)")
                DispatchQueue.main.async {
                    completion(GBBaseResponse(result: .failure(.apiFailure)))
                }
            }
        }
    }
    
    private func constructUrlFor(request: GBRequest) -> String {
        
        /*
         ts - a timestamp (or other long string which can change on a request-by-request basis)
         hash - a md5 digest of the ts parameter, your private key and your public key (e.g. md5(ts+privateKey+publicKey)
         
         For example, a user with a public key of "1234" and a private key of "abcd" could construct a valid call as follows: http://gateway.marvel.com/v1/public/comics?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150 (the hash value is the md5 digest of 1abcd1234)
         */
        
        let ts = String(NSDate().timeIntervalSince1970)
        let combined = ts + GBDataLayerConstants.GBDataNetworkConstants.privateKey + GBDataLayerConstants.GBDataNetworkConstants.publicKey
        let md5 = combined.md5Value
        
        var paramString = ""
        if let parameters = request.params {
            for (key, value) in parameters {
                paramString += "&\(key)=\(value)"
            }
        }
        switch request.type {
        case .get:
            return GBDataLayerConstants.GBDataNetworkConstants.baseURL + "/" + request.path + "?" + "ts=" + ts + "&apikey=" + GBDataLayerConstants.GBDataNetworkConstants.publicKey  + "&hash=" + md5 + paramString

        case .post:
            return ""
        }
    }
}
