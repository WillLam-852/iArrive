//
//  API.swift
//  iArrive
//
//  Created by Will Lam on 9/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

/*

import AFNetworking

class API {
    
    private var manager: AFHTTPSessionManager?
    private var userDefaults: UserDefaults?
    private var navigationController: UINavigationController?

    init() {
        manager = AFHTTPSessionManager()
        userDefaults = UserDefaults.standard
    }

    static var sharedAPIInstance: API?
    
    class func sharedAPI() -> API {
        // `dispatch_once()` call was converted to a static variable initializer
        sharedAPIInstance = API.init()
        return sharedAPIInstance!
    }

//+ (instancetype) sharedAPI {
//    static API *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//    instance = [[API alloc] init];
//    });
//    return instance;
//}
    func getBaseUrl() -> String? {
        return "https://iarrive.apptech.com.hk"
    }
    
    func setNavigationControllerFor(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func authenticationNormal(_ parameter: NSDictionary?, success: (_ response: NSDictionary?) -> Void, failure: (_ error: Error?) -> Void) {
        let uploadURL = getBaseUrl() ?? "" + ("/api/auth")
        manager?.post(uploadURL, parameters: parameter, progress: nil, success: { task, responseObject in
            success(responseObject?.copy())
        }, failure: { task, error in
            failure(error)
        })
    }
        
//-(void)authenticationNormal:(NSDictionary *)parameter success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure
//{
//    NSString *uploadURL = [[self getBaseUrl] stringByAppendingString:@"/api/auth"];
//
//
//
//    [_manager POST:uploadURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success([responseObject copy]);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//        }];
//}
//
    
    func recognizeFace(_ imageData: Data?, withParameter para: [AnyHashable : Any]?, success: @escaping (_ responseObject: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/faces/recognize")
        } //@"https://ai.apptech.com.hk/face/recognizeFace";
        
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        manager?.post(uploadURL!, parameters: nil, constructingBodyWith: { formData in
            formData.appendPart(withFileData: imageData, name: "image", fileName: "upload.jpg", mimeType: "image/jpeg")
            //if para?["site_id"]
            formData.appendPart(withForm: (String(format: "%lld", (para?["site_id"] as? NSNumber)?.int64Value)).data(using: .utf8), name: "site_id")
        }, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
    
//-(void)recognizeFace:(NSData *)imageData withParameter:(NSDictionary *)para success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/faces/recognize",[_userDefaults objectForKey:@"orgId"]];//@"https://ai.apptech.com.hk/face/recognizeFace";
//
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    [_manager POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
//        if(para[@"site_id"]) {
//        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%lld", [para[@"site_id"] longLongValue]] dataUsingEncoding:NSUTF8StringEncoding] name:@"site_id"];
//        }
//        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//    }
    
    func massRecognizeFace(_ imageData: Data?, withParameter para: [AnyHashable : Any]?, success: @escaping (_ response: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/faces/mass_recognize")
        }
        
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        manager?.post(uploadURL!, parameters: nil, constructingBodyWith: { formData in
            formData.appendPart(withFileData: imageData, name: "image", fileName: "upload.jpg", mimeType: "image/jpeg")
            //if para?["site_id"]
            formData.appendPart(withForm: (String(format: "%lld", (para?["site_id"] as? NSNumber)?.int64Value)).data(using: .utf8), name: "site_id")
        }, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
//
//    - (void)massRecognizeFace: (NSData *)imageData withParameter:(NSDictionary *)para success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/faces/mass_recognize",[_userDefaults objectForKey:@"orgId"]];
//
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    [_manager POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
//        if(para[@"site_id"]) {
//        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%lld", [para[@"site_id"] longLongValue]] dataUsingEncoding:NSUTF8StringEncoding] name:@"site_id"];
//        }
//        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}

    func createCheck(_ parameter: [AnyHashable : Any]?, success: @escaping (_ response: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        manager?.requestSerializer = AFJSONRequestSerializer()
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        
        var uploadURL: String?
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/staffs/\(String(describing: parameter?["staff_id"]))/checks")
        }
        manager?.post(uploadURL!, parameters: parameter, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
//-(void)createCheck:(NSDictionary *)parameter success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/staffs/%@/checks",[_userDefaults objectForKey:@"orgId"],parameter[@"staff_id"]];
//    [_manager POST:uploadURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}

    func createStaff(_ parameter: [AnyHashable : Any]?, success: @escaping (_ response: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        manager?.requestSerializer = AFJSONRequestSerializer()
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/staffs/")
        }
        manager?.post(uploadURL!, parameters: parameter, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
//-(void)createStaff:(NSDictionary *)parameter success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/staffs/",[_userDefaults objectForKey:@"orgId"]];
//    [_manager POST:uploadURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}
//
    func createFace(_ parameter: [AnyHashable : Any]?, success: @escaping (_ response: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        manager?.requestSerializer = AFJSONRequestSerializer()
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/faces/")
        }
        manager?.post(uploadURL!, parameters: parameter, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
//-(void)createFace:(NSDictionary *)parameter success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/faces/",[_userDefaults objectForKey:@"orgId"]];
//    [_manager POST:uploadURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}

    func uploadImage(_ imageData: Data?, success: @escaping (_ responseObject: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/faces/image")
        }
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        manager?.post(uploadURL!, parameters: nil, constructingBodyWith: { formData in
            formData.appendPart(withFileData: imageData!, name: "image", fileName: "upload.jpg", mimeType: "image/jpeg")
        }, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
//-(void)uploadImage:(NSData *)imageData success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/faces/image",[_userDefaults objectForKey:@"orgId"]];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    [_manager POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}

    func uploadVideo(_ videoFileURL: URL?, success: @escaping (_ responseObject: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/faces/video")
        }
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        manager?.post(uploadURL!, parameters: nil, constructingBodyWith: { formData in
            do {
                try formData.appendPart(withFileURL: videoFileURL, name: "video")
            } catch {
            }
        }, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
//-(void)uploadVideo:(NSURL *)videoFileURL success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/faces/video",[_userDefaults objectForKey:@"orgId"]];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    [_manager POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileURL:videoFileURL name:@"video" error:nil];
//        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}
//
    func getAllStaff(inOrganization parameter: [AnyHashable : Any]?, withSuccess success: @escaping (_ responseObject: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/staffs/")
        }
        manager?.get(uploadURL!, parameters: parameter, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
//
//-(void)getAllStaffInOrganization:(NSDictionary *)parameter withSuccess:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/staffs/",[_userDefaults objectForKey:@"orgId"]];
//    [_manager GET:uploadURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}

    func getOrganizationInformation(_ success: @escaping (_ responseObject: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)")
        }
        manager?.get(uploadURL!, parameters: nil, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            failure(error)
        })
    }

//-(void)getOrganizationInformation:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error) )failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@",[_userDefaults objectForKey:@"orgId"]];
//    [_manager GET:uploadURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//        }];
//}
//
    func getSites(_ parameter: [AnyHashable : Any]?, success: @escaping (_ responseObject: [AnyHashable : Any]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let token = "Bearer " + (userDefaults?.object(forKey: "token") as? String ?? "")
        manager?.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        var uploadURL: String? = nil
        if let object = userDefaults?.object(forKey: "orgId") {
            uploadURL = getBaseUrl() ?? "" + ("/api/organizations/\(object)/sites/")
        }
        manager?.get(uploadURL!, parameters: parameter, progress: nil, success: { task, responseObject in
            success(responseObject)
        }, failure: { task, error in
            if !self.processError(error, task: task) {
                failure(error)
            }
        })
    }
    
//-(void)getSites:(NSDictionary *)parameter success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure
//{
//    NSString  *token = [@"Bearer " stringByAppendingString:[_userDefaults objectForKey:@"token"]];
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    NSString *uploadURL =[[self getBaseUrl] stringByAppendingFormat:@"/api/organizations/%@/sites/",[_userDefaults objectForKey:@"orgId"]];
//    [_manager GET:uploadURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if(![self processError:error task:task]) {
//        failure(error);
//        }
//        }];
//}

    func processError(_ error: Error?, task: URLSessionDataTask?) -> Bool {
        if (error as NSError?)?.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] == nil {
            return false
        }
        var json: [AnyHashable : Any]? = nil
        do {
            if let userInfo = (error as NSError?)?.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] {
                json = try JSONSerialization.jsonObject(with: userInfo, options: .mutableContainers) as? [AnyHashable : Any]
            }
        } catch {
        }
        
        if json != nil {
            let error = json?["error"] as? String
            if (error == "LOGIN_EXPIRE") || (error == "USER_DELETED") {
                navigationController?.popToRootViewController(animated: true)
                let defs = UserDefaults.standard
                let dict = defs.dictionaryRepresentation()
                for key in dict {
                    if !(key.key == "LanguageCode") {
                        defs.removeObject(forKey: key.key)
                    }
                }
                defs.synchronize()
                UsefulTools.showAlertwithTitle(CustomLocalisedString("api_error", ""), withContent: CustomLocalisedString("api_error_message", ""), viewController: navigationController?.viewControllers[0], withComplection: nil)
                return true
            }
        }
        return false
    }
//-(BOOL)processError:(NSError *)error task:(NSURLSessionDataTask *)task {
//    if(!error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
//        return false;
//    }
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:nil];
//
//    if(json) {
//        NSString *error = json[@"error"];
//        if ([error isEqualToString:@"LOGIN_EXPIRE"] || [error isEqualToString:@"USER_DELETED"]) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//            NSDictionary* dict = [defs dictionaryRepresentation];
//            for(id key in dict) {
//                if(![key isEqualToString:@"LanguageCode"])
//                [defs removeObjectForKey:key];
//            }
//            [defs synchronize];
//            [UsefulTools showAlertwithTitle:CustomLocalisedString(@"api_error", @"") withContent:CustomLocalisedString(@"api_error_message", @"") viewController:self.navigationController.viewControllers[0] withComplection:nil];
//            return true;
//        }
//    }
//    return false;
//}
//
//@end
//

}

 */
