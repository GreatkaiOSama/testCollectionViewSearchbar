//
//  GLConstants.swift
//  git app
//
//  Created by Henry Silva on 8/2/16.
//  Copyright © 2016 Henry Silva. All rights reserved.
//

import UIKit
class GLConstants: NSObject {
    
    
    
    //MARK: - Colors
    static let kColorBgNavigationBar = "#24292e"
    
    //MARK: - Strings
    static let kStringDefaultAtencionTitle = "Asertec"
    static let kStringDefaultErrorTitle = "Error"
    static let kStringDefaultErrorNoHayDatos = "No hay datos"
    static let kStringDefaultErrorNoHayDatosv2 = "Datos no encontrados"
    static let kStringDefaultLoadingMessage = "Cargando..."
    
    
    //MARK: - Url Base
    static let kURLDefaultRoot =  "https://github-trending-api.now.sh"
    
    //MARK: - Timeout default value
    @objc static let KTimeoutdefault : Double = 150.0
    
    //Error
    static let kErrorObjectConnection = NSError(domain: "GLConnectionError", code: 999, userInfo: nil)
    
    
    

}
