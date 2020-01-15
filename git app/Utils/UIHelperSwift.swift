//
//  UIHelperSwift.swift
//  git app
//
//  Created by Henry Silva Olivo on 7/8/18.
//  Copyright © 2016 Henry Silva. All rights reserved.
//

import Foundation
import ReachabilitySwift
import UIKit


@objcMembers class UIHelperSwift: NSObject {
    
    static var reachability: Reachability?
    
    static public func HasConnection() -> Bool {
        return true
    }
    
    static func ReachabilityStatus(_ hostName: String? ) -> Bool {
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        var statusNetwork = false
        if reachability!.isReachableViaWiFi {
            statusNetwork = true
        }else if reachability!.isReachableViaWWAN {
            statusNetwork = true
        }else{
            statusNetwork = false
        }
        return statusNetwork
    }
    
    static func encodeURLString(_ urlString: String) -> String{
        return urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
    }
    
    static func decodeURLString(_ urlString: String) -> String{
        return urlString.removingPercentEncoding!
    }
    
    static func prepareurl(_ urlString: String) -> String{
        return encodeURLString(decodeURLString(urlString))
    }
    
    
    static func getMaxYsubviews(container: UIView) -> CGFloat{
        var valMaxy = CGFloat(0)
        for viewin in container.subviews {
            if valMaxy == 0 {
                valMaxy = viewin.frame.maxY
            }else{
                if viewin.frame.maxY > valMaxy {
                    valMaxy = viewin.frame.maxY
                }
                
            }
            
        }
        return valMaxy
    }
    
    
    
    @objc static func encodeParametersSwift(mutablerequest: NSMutableURLRequest, params: NSMutableDictionary){
        let bodyString = encodeParameters(params)
        mutablerequest.httpBody = Data(bytes: bodyString.utf8String!, count: bodyString.length)
    }
    
    @objc static func encodeParameters(_ parameters: NSMutableDictionary) -> NSString{
        var string = ""
        
        let keys = Array(parameters.allKeys)
        for i in 0 ..< keys.count{
            if (i != 0 || i != parameters.allKeys.count){
                string += "&"
            }
            
            let key = keys[i]
            
            if let value = parameters[key]{
                string += "\(key)" + "=" + "\(value)"
            }
        }
        
        return string as NSString
    }
    
    @objc static func ifDeviceisiPhoneX() -> Bool{
      
        var iphoneX = false
        if #available(iOS 11.0, *) {
            /*if let mainWindow = UIApplication.shared.delegate?.window {
                if (mainWindow?.safeAreaInsets.top)! > CGFloat(0) {
                    iphoneX = true
                }
            }*/
            if let delg = UIApplication.shared.delegate, let mainWindow = delg.window, let w2 = mainWindow {
                if w2.safeAreaInsets.top > CGFloat(20) && w2.safeAreaInsets.bottom > 0 {
                    iphoneX = true
                }
            }
        }
        
        return iphoneX
    }
    @objc static func executeBlockInMainQueue(_ block: @escaping () -> Void){
        DispatchQueue.main.async { () -> Void in
            block();
        }
    }
    
    @objc static func sampleAlertController(title: String = "",message: String = "",arraytextbtns : NSArray?,vc : UIViewController, _block: @escaping (Int) -> Void) {
        let alertctr = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        // para mantener botones del alert de forma dinamica
        if let inarraytextbtns = arraytextbtns  {
            if inarraytextbtns is [String] {
                var index = 0
                for textsbtn in inarraytextbtns as! [String]{
                    let act1 = UIAlertAction.init(title: textsbtn, style: .default) { (action) in
                        if let indexaction = alertctr.actions.index(of: action) {
                            _block(indexaction);
                        }else{
                            _block(0);//si por alguna razon no puede devolver el indice entonces retorna 0
                        }
                        
                        
                    }
                    
                    alertctr.addAction(act1)
                    
                    index += 1
                }
            }
            
        }else{
            let act1 = UIAlertAction.init(title: "OK", style: .default) { (action) in
                _block(0);
            }
            alertctr.addAction(act1)
            
        }
       
        
        vc.present(alertctr, animated: true, completion: nil)
    }
    
    
    @objc static func isValidEmail(str:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }
    
    
    
    @objc static func getPresentVersionApp() -> String{
        //consulta directamente del plist
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        return appVersion
    }
    
    //reemplazo de print normal para validar que solo se muestren los logs cuando se ejecute el simulador
    static func Dprint(_ items: Any...) {
        #if targetEnvironment(simulator)
            print(items)
        #else
        //UIHelperSwift.Dprint("...")
        //UIHelperSwift.Dprint(items)
        #endif
        
    }
    
    @objc static func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

}
