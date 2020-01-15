//
//  GeneralViewController.swift
//  git app
//
//  Created by Henry Silva Olivo on 1/15/20.
//  Copyright © 2020 hsilva. All rights reserved.
//


import UIKit
import JGProgressHUD

class GeneralViewController: UIViewController {
    
    var hud : JGProgressHUD?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    
    }
    
    
    func showLoadingProgress(){
        
        UIHelperSwift.executeBlockInMainQueue {
            if let loadv = self.hud{
                loadv.dismiss(animated: false)
                loadv.removeFromSuperview()
                self.hud = nil
            }
            self.hud = JGProgressHUD(style: .dark)
            self.hud!.textLabel.text = "Cargando.."
            self.hud!.show(in: self.view)
        }
        
    }

    func hideLoadingProgress(){
        UIHelperSwift.executeBlockInMainQueue {
            if let loadv = self.hud {
                loadv.dismiss(animated: false)
                loadv.removeFromSuperview()
                self.hud = nil
            }
        }
        
    }
}


