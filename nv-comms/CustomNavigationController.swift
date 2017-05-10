//
//  NavigationController.swift
//  nv-comms
//
//  Created by Denis Quaid on 24/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController {
    
    enum navBarTheme {
        case light
        case lightBlackText
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    func setNavBar(theme: navBarTheme) {
        switch theme {
        case .light :
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = true
            self.view.backgroundColor = UIColor.clear
            self.navigationBar.backgroundColor = UIColor.clear
            self.navigationBar.tintColor = UIColor.white
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        case .lightBlackText:
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = true
            self.view.backgroundColor = UIColor.clear
            self.navigationBar.backgroundColor = UIColor.clear
            self.navigationBar.tintColor = UIColor.black
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        }
        
        
    }
}
