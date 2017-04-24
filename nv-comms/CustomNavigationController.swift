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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
