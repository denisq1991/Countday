//
//  IconChooserViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 28/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

class IconChooserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var iconChoiceCollectionView: UICollectionView?
    var selectedIcon: UIImage?
    
    let icons = [#imageLiteral(resourceName: "bag"), #imageLiteral(resourceName: "cake"), #imageLiteral(resourceName: "car"), #imageLiteral(resourceName: "diamond"), #imageLiteral(resourceName: "giftbox"), #imageLiteral(resourceName: "graduate"), #imageLiteral(resourceName: "hospital"), #imageLiteral(resourceName: "music"), #imageLiteral(resourceName: "paw"), #imageLiteral(resourceName: "plane"), #imageLiteral(resourceName: "trophy")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconChoiceCell", for: indexPath) as! IconChoiceCell
        cell.iconView?.image = icons[indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.iconChoiceCollectionView?.cellForItem(at: indexPath) as? IconChoiceCell else {
            return
        }
        cell.backgroundColor = UIColor.blue
        self.selectedIcon = cell.iconView?.image
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = self.iconChoiceCollectionView?.cellForItem(at: indexPath) as? IconChoiceCell else {
            return
        }
        cell.backgroundColor = UIColor.clear
    }

}

class IconChoiceCell: UICollectionViewCell {
    @IBOutlet var iconView: UIImageView?
}
