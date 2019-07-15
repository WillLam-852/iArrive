//
//  API.swift
//  iArrive
//
//  Created by Will Lam on 9/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import Alamofire


class API {

    // MARK: HTTP POST Methods
    func postUsernamePassword(username: String, password: String) {
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
            .responseJSON { response in
                print("JSON Response: ", response)
            }
            .responseData { response in
                print("Data Response: ", response)
            }
            .responseString { response in
                print("String Response: ", response)
        }
    }

}
