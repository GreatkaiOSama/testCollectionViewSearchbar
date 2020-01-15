//
//  CWebservice.swift
//  git app
//
//  Created by Henry Silva Olivo on 7/8/18.
//  Copyright © 2016 Henry Silva. All rights reserved.
//

import Foundation
enum MethodWs {
    case POST
    case PUT
    case GET
}

@objc protocol CWebserviceDelegate: AnyObject {
    @objc func returnExecutionWithSuccess(identifier : String ,retObject : [NSDictionary]?)
    @objc func returnExecutionWithError(identifier : String , retObject : [NSDictionary]?)
}

@objcMembers class CWebservice: NSObject {
    
    weak var delegate : CWebserviceDelegate?
    
    
    typealias WSCompletionBlock = (Data?, TypedError?) -> Void
    typealias WSCompletionFullBlock = (Data?,URLResponse?,URL?, TypedError?) -> Void
    typealias WSJSONCompletionBlock = (NSDictionary?, TypedError?) -> Void
    typealias WSJSONCompletionBlock2 = ([NSDictionary]?, TypedError?) -> Void
    
    
    static func generateURLSession(timeoutRqst: Double, timeoutRsc: Double) -> URLSession{
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeoutRqst
        sessionConfig.timeoutIntervalForResource = timeoutRsc
        sessionConfig.httpAdditionalHeaders = generateDefaultHeaders() as! [AnyHashable: Any]
        return URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    }
    
    
    static func generateDefaultHeaders() -> NSDictionary{
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        var serviceid = ""
        
        
        var pinlogin = ""
        
        
        var mail = ""
        var password = ""
        var session_id = ""
        
        var idplan = ""
        
        
        var cid = "0"
        
        
        var headers = Dictionary<String, AnyObject>()
        headers["DEVICE_ID"] = "" as AnyObject
        headers["SERVICE_ID"] = serviceid as AnyObject
        headers["PIN"] = pinlogin as AnyObject
        
        headers["FRAMEWORK"] = "iOS" as AnyObject
        
        headers["SESSION_ID"] = session_id as AnyObject
        headers["PASSWORD"] = password as AnyObject
        headers["MAIL"] = mail as AnyObject
        
        headers["BPPLAN"] = idplan as AnyObject
        headers["CID"] = cid as AnyObject
        
        headers["VERSION"] = appVersion as AnyObject?
        //headers["FRAMEWORK"] = "IOS" as AnyObject?//"iOS"
        //headers["MODEL"] = identifier as AnyObject?
        
        return headers as NSDictionary
    }
    
    static func generateDefaultURL(_ end: String) -> String{
        return GLConstants.kURLDefaultRoot + end
        //return "http://10.40.165.19/miclaro_app_dev_js/web/app_dev.php\(end)"
    }
    
    private static func encodeParameters(_ parameters: [String:String]) -> NSString{
        var string = ""
        
        let keys = Array(parameters.keys)
        for i in 0 ..< keys.count{
            if (i != 0 || i != parameters.keys.count){
                string += "&"
            }
            
            let key = keys[i]
            
            if let value = parameters[key]{
                string += key + "=" + value
            }
        }
        
        return string as NSString
    }
    
    private static func initSession(_ url: String,timeout: Double = GLConstants.KTimeoutdefault, completionBlock: @escaping WSCompletionBlock){
        let session = generateURLSession(timeoutRqst: timeout, timeoutRsc: timeout)
        
        var request = URLRequest(url: URL(string: url)!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "accept")
        session.dataTask(with: request as URLRequest, completionHandler: { (data, reponse, error)-> Void in
            if error == nil {
                completionBlock(data, nil)
            }else{
                completionBlock(data, error as? TypedError)
            }
            
            
        }).resume()
        
    }
    
    private static func initPostSession(_ url: String, parameters: [String:String],methodtype : MethodWs = MethodWs.POST, timeout : Double, completionBlock: @escaping WSCompletionBlock){
        let session = generateURLSession(timeoutRqst: timeout, timeoutRsc: timeout)
        //print("URL= \(url) METHOD= \(methodtype)")
        //print("params = \(parameters)")
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "\(methodtype)"//"POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        
        let bodyString = encodeParameters(parameters)
        
        if let dataencoding = bodyString.data(using: String.Encoding.utf8.rawValue) {
            request.httpBody = dataencoding
            //let stringparambody = String(decoding: request.httpBody!, as: UTF8.self)
            //print("REVERSAL BODY REQUEST = \(stringparambody)")
        }
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, reponse, error)-> Void in
            if error == nil {
                completionBlock(data, nil)
            }else{
                completionBlock(data, error as? TypedError)
            }
        }).resume()
        
    }
    
    
    private static func centralPost(url: String, parameters: [String:String], timeout: Double = GLConstants.KTimeoutdefault, completionBlock: WSJSONCompletionBlock?){
        if UIHelperSwift.HasConnection() {
            self.initPostSession(url,parameters : parameters, timeout: timeout) { (data, error) -> Void in
                UIHelperSwift.executeBlockInMainQueue {
                    if (error == nil && data != nil){
                        do{
                            let JSONData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                            if JSONData != nil {
                                completionBlock?(JSONData!, nil)
                            }else{
                                let error: TypedError = TypedError.other
                                completionBlock?(nil, error)
                            }
                        }catch {
                            let error: TypedError = TypedError.other
                            completionBlock?(nil, error)
                        }
                    }else{
                        completionBlock?(nil, error)
                    }
                }
                
            }
        }else{
            let error: TypedError = TypedError.NoInternetConnection
            completionBlock?(nil, error)
        }
    }
    
    private static func centralGet(url : String, timeout : Double = GLConstants.KTimeoutdefault, completionBlock: WSJSONCompletionBlock2?) {
        
        if UIHelperSwift.HasConnection() {
            
            self.initSession(url, timeout: timeout) { (data, error) -> Void in
                UIHelperSwift.executeBlockInMainQueue {
                    if (error == nil && data != nil){
                        do{
                            
                            let JSONData = try JSONSerialization.jsonObject(with: data!, options: []) as? [NSDictionary]
                            if JSONData != nil {
                                completionBlock?(JSONData!, nil)
                            }else{
                                let error: TypedError = TypedError.other
                                completionBlock?(nil, error)
                                
                            }
                        }catch {
                            let error: TypedError = TypedError.other
                            completionBlock?(nil, error)
                        }
                    }else if (error == nil && data == nil){//normalmente se cumpliria por timeout
                        let error: TypedError = TypedError.other
                        completionBlock?(nil, error)
                    }else{
                        completionBlock?(nil, error)
                    }
                }
            }
        }else{
            UIHelperSwift.executeBlockInMainQueue {
                let error: TypedError = TypedError.NoInternetConnection
                completionBlock?(nil, error)
            }
        }
    }
    
    
    
    
    func getListRepositorios(_ identifier: String = "0"){
        
        CWebservice.centralGet(url: CWebservice.generateDefaultURL("/repositories?since=daily")) { (data, error) in
            if let delegate = self.delegate {
                if error == nil && data != nil {
                    delegate.returnExecutionWithSuccess(identifier: identifier, retObject: data)
                }else{
                    delegate.returnExecutionWithError(identifier: identifier, retObject: nil )
                }
            }
        }
    }
}
