//
//  GLGeneralNavigationController.swift
//  git app
//
//  Created by Henry Silva Olivo on 1/15/20.
//  Copyright © 2020 hsilva. All rights reserved.
//

import UIKit
//import UIColor_Hex_Swift

class GLGeneralNavigationController: UINavigationController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.isNavigationBarHidden = true
        
        UINavigationBar.appearance().barStyle = UIBarStyle.black
        
        
        //Color elements, images ,buttons,etc
        UINavigationBar.appearance().tintColor = UIColor.white
        
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().barTintColor = UIColor.darkGray//UIColor(GLConstants.kColorBgNavigationBar)
        UINavigationBar.appearance().alpha = 1
        //UINavigationBar.appearance().addshadow()
        
        /*let image = UIImage.init(color: UIColor(GLConstants.kColorNavigationBar), size: CGSize.init(width: 320, height: 44))
        UINavigationBar.appearance().setBackgroundImage(image!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        */
        if let _ = self.interactivePopGestureRecognizer{
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
