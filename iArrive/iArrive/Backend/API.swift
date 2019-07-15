//
//  API.swift
//  iArrive
//
//  Created by Will Lam on 9/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class API {
    

    // MARK: HTTP POST Methods
    
    func postUsernamePassword (username: String, password: String, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?, _ isLogIn: Bool) -> ()) {
        let url = URL(string: "https://iarrive.apptech.com.hk/api/auth")!
        let headers: HTTPHeaders = [
            "Accept": "application/x-www-form-urlencoded",
            "forHTTPHeaderField": "Content-Type"
        ]
        let parameters: [String: Any] = [
            "email" : username,
            "password" : password
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value):
                    let receivedData = JSON(value)
                    if receivedData["success"].boolValue {
                        token = receivedData["token"].stringValue
                        completionHandler(receivedData, nil, true)
                    } else {
                        completionHandler(receivedData, nil, false)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(nil, error, false)
                }
        }
    }
    
    
//    func decodeTokenGetOrgID(_ token: String?) -> String? {
//        var token = token
//        let buwei = (4 - (token?.count ?? 0) % 4) % 4
//        for _ in 0..<buwei {
//            token = token ?? "" + ("=")
//        }
//        let data = Data(base64Encoded: token ?? "", options: .ignoreUnknownCharacters)
//        var err: Error?
//        var dic: [AnyHashable : Any]? = nil
//        do {
//            if let data = data {
//                dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable : Any]
//            }
//        } catch let err {
//        }
//        if err != nil {
//            return nil
//        } else {
//            let scope = dic?["scope"] as? [AnyHashable : Any]
//            return scope?["organization_id"] as? String
//        }
//        return nil
//    }

}
