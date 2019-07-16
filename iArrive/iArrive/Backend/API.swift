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
    
    
    // API for logging in (for section B)
    func LogInAPI (username: String, password: String, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?, _ isLogIn: Bool) -> ()) {
        let uploadURL = URL(string: baseURL + "/auth")!
        let parameters: [String: Any] = [
            "email" : username,
            "password" : password
        ]
        AF.request(uploadURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value):
                    let receivedData = JSON(value)
                    if receivedData["success"].boolValue {
                        token = "Bearer " + receivedData["token"].stringValue
                        orgID = receivedData["organization"]["organization_id"].stringValue
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
    func recognizeFaceAPI (imageData: Data?, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?) -> ()) {
        var uploadURL: String?
        if let object = orgID {
            uploadURL = baseURL + "/organizations/\(object)/faces/recognize" //@"https://ai.apptech.com.hk/face/recognizeFace";
        }
        let headers: HTTPHeaders = [
            "Authorization": token!
        ]
        AF.request(uploadURL ?? "", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value):
                    let receivedData = JSON(value)
                    completionHandler(receivedData, nil)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(nil, error)
                }
        }
    }
    
    
    // API for sending face video for AI analysis, and returning a video URL (for section C1)
    func uploadVideo(videoFileURL: NSURL, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?) -> ()) {
        var uploadURL: String?
        if let object = orgID {
            uploadURL = baseURL + "/organizations/\(object)/faces/video"
        }
        let multipartFormDatas: (MultipartFormData) -> Void = { multipartFormData in
            multipartFormData.append(videoFileURL as URL, withName: "video")
        }
        let headers: HTTPHeaders = [
            "Authorization": token!
        ]
        AF.upload(multipartFormData: multipartFormDatas, usingThreshold: .init(), fileManager: .init(), to: uploadURL ?? "", method: .post, headers: headers, interceptor: nil)
            .responseJSON { (response) -> Void in
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
    }
    
    
    // API for creating face data in the server (for section C1)
    func createFace(parameters: Parameters, completionHandler: @escaping (_ responseObject: JSON?, _ error: Error?) -> ()) {
        var uploadURL: String?
        if let object = orgID {
            uploadURL = baseURL + "/organizations/\(object)/faces/"
        }
        let headers: HTTPHeaders = [
            "Authorization": token!
        ]
        print("parameters: ", parameters)
        AF.request(uploadURL ?? "", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
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

}
