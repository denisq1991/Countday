//
//  String+ImagePath.swift
//  nv-comms
//
//  Created by Denis Quaid on 12/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func loadImageFromPath() -> UIImage? {
        let tempDirectory = NSTemporaryDirectory()
        let imagePath = ("\(tempDirectory)\(self).png")
        let image = UIImage(contentsOfFile: imagePath)
        if image == nil {
            print("missing image at: \(imagePath)")
        }
        return image
    }
}
