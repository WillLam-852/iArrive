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
    
    
    // API for getting organization information in auto-login mode (for Section B)
    func getOrganizationInformationAPI(completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?) -> ()) {
        let tokenHere = "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")
        let headers: HTTPHeaders = [
            "Authorization": tokenHere
        ]
        var uploadURL: String?
        if let object = UserDefaults.standard.string(forKey: "orgID") {
            uploadURL = baseURL + ("/organizations/\(object)")
        }
        Alamofire.request(uploadURL ?? "", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value):
                    let receivedData = JSON(value)
                    companyName = receivedData["name"].stringValue
                    orgID = receivedData["organization_id"].stringValue
                    self.updateCompanyInformation()
                    print("getOrganizationInformation JSON: ", receivedData)
                    completionHandler(receivedData, nil)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(nil, error)
                }
        }
    }
    
    
    // API for logging in (for section B)
    func LogInAPI(username: String, password: String, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?, _ isLogIn: Bool) -> ()) {
        let uploadURL = URL(string: baseURL + "/auth")!
        let parameters: [String: Any] = [
            "email" : username,
            "password" : password
        ]
        Alamofire.request(uploadURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value):
                    let receivedData = JSON(value)
                    companyName = receivedData["organization"]["name"].stringValue
                    orgID = receivedData["organization"]["organization_id"].stringValue
                    token = receivedData["token"].stringValue
                    self.updateCompanyInformation()
                    print("LogInAPI JSON: ", receivedData)
                    if receivedData["success"].boolValue {
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
    
    
    // API for sending face image data for staff registration (for section B1)
//    func recognizeFaceAPI (imageData: Data?, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?) -> ()) {
//        var uploadURL: String?
//        if let object = orgID {
//            uploadURL = baseURL + "/organizations/\(object)/faces/recognize" //@"https://ai.apptech.com.hk/face/recognizeFace";
//        }
//        let headers: HTTPHeaders = [
//            "Authorization": token!
//        ]
//        Alamofire.request(uploadURL ?? "", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
//            .responseJSON { (response) -> Void in
//                switch response.result {
//                case .success(let value):
//                    let receivedData = JSON(value)
//                    completionHandler(receivedData, nil)
//                case .failure(let error):
//                    print("Request failed with error: \(error)")
//                    completionHandler(nil, error)
//                }
//        }
//    }
    
    
    // API for sending face video for AI analysis, and returning a video URL (for section C1)
    func uploadVideoAPI(videoFileURL: URL, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?) -> ()) {
        let uploadURL = baseURL + "/organizations/\(orgID)/faces/video"
        let multipartFormDatas: (MultipartFormData) -> Void = { multipartFormData in
            multipartFormData.append(videoFileURL, withName: "video")
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        Alamofire.upload(multipartFormData: multipartFormDatas, usingThreshold: .init(), to: uploadURL, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { (response) -> Void in
                    switch response.result {
                    case .success(let value):
                        let receivedData = JSON(value)
                        print("uploadVideo JSON: ", receivedData)
                        completionHandler(receivedData, nil)
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        completionHandler(nil, error)
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionHandler(nil, error)
            }
        })
    }
    
    
    // API for creating face data in the server (for section C1)
    func createFaceAPI(parameters: Dictionary<String, Any>, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?) -> ()) {
        let uploadURL = baseURL + "/organizations/\(orgID)/faces/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        print("parameters: ", parameters)
        Alamofire.request(uploadURL , method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value):
                    let receivedData = JSON(value)
                    print("createFace JSON: ", receivedData)
                    completionHandler(receivedData, nil)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(nil, error)
                }
        }
    }
        
        
//        for i in imageArray{
//            var objectname = "picture" + String(count)
//            let image = i;
//            //Turn image into data
//            let imageData: NSData = UIImagePNGRepresentation(image as! UIImage)!
//            let params = ["objectname" : objectname, "bucketname" : bucketname!, "content_type" : "image/jpeg"]
//
//            let manager = AFHTTPSessionManager()
//            manager.POST(uploadUrl, parameters: params, constructingBodyWithBlock: { (AFMultipartFormData) in
//
//                AFMultipartFormData.appendPartWithFileData(imageData, name: "file", fileName: "image", mimeType: "image/jpeg")
//            }, progress: nil, success: { (s:NSURLSessionDataTask, response) in
//                print(response)
//            }) { (s:NSURLSessionDataTask?, e:NSError?) in
//                print(e)
//            }
//            count+=1
//        }
//
//        AF.request(uploadURL ?? "", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
//            .responseJSON { (response) -> Void in
//    }
//
//
//    func recognizeFace(_ imageData: Data?, withParameter para: [AnyHashable : Any]?, success: @escaping (_ responseObject: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
//
//        manager.post(uploadURL, parameters: nil, constructingBodyWithBlock: { formData in
//            formData.appendPart(withFileData: imageData, name: "image", fileName: "upload.jpg", mimeType: "image/jpeg")
//            //if para?["site_id"]
//            formData.appendPart(withForm: (String(format: "%lld", (para?["site_id"] as? NSNumber)?.int64Value)).data(using: .utf8), name: "site_id")

    
    
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
    
    
//    func processError(_ error: Error?, task: URLSessionDataTask?) -> Bool {
//        if (error as NSError?)?.userInfo[Alamofire.NSURLErrorFailingURLErrorKey] == nil {
//            return false
//        }
//        var json: [AnyHashable : Any]? = nil
//        do {
//            if let userInfo = (error as NSError?)?.userInfo[Alamofire.NSURLErrorFailingURLErrorKey] {
//                json = try JSONSerialization.jsonObject(with: userInfo, options: .mutableContainers) as? [AnyHashable : Any]
//            }
//        } catch {
//        }
//
//        if json != nil {
//            let error = json?["error"] as? String
//            if (error == "LOGIN_EXPIRE") || (error == "USER_DELETED") {
//                navigationController?.popToRootViewController(animated: true)
//                let defs = UserDefaults.standard
//                let dict = defs.dictionaryRepresentation()
//                for key in dict {
//                    if !(key == "LanguageCode") {
//                        defs.removeObject(forKey: key as? String ?? "")
//                    }
//                }
//                defs.synchronize()
//                UsefulTools.showAlertwithTitle(CustomLocalisedString("api_error", ""), withContent: CustomLocalisedString("api_error_message", ""), viewController: navigationController?.viewControllers[0], withComplection: nil)
//                return true
//            }
//        }
//        return false
//    }
    
    private func updateCompanyInformation() {
        UserDefaults.standard.set(companyName, forKey: "companyName")
        UserDefaults.standard.set(orgID, forKey: "orgID")
        UserDefaults.standard.set(token, forKey: "token")
    }
    

}
