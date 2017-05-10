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
    
    let icons = [("bag", #imageLiteral(resourceName: "bag-grey")),
                 ("cake", #imageLiteral(resourceName: "cake-grey")),
                 ("car", #imageLiteral(resourceName: "car-grey")),
                 ("diamond", #imageLiteral(resourceName: "diamond-grey")),
                 ("gift", #imageLiteral(resourceName: "gift-grey") ),
                 ("cap", #imageLiteral(resourceName: "cap-grey")),
                 ("hospital", #imageLiteral(resourceName: "hospital-grey")),
                 ("music", #imageLiteral(resourceName: "music-grey")),
                 ("paw", #imageLiteral(resourceName: "paw-grey")),
                 ("plane", #imageLiteral(resourceName: "plane-grey")),
                 ("sunbed", #imageLiteral(resourceName: "sunbed-grey")),
                 ("cup", #imageLiteral(resourceName: "cup-grey"))] as [(String, UIImage)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconChoiceCell", for: indexPath) as! IconChoiceCell
        let event = icons[indexPath.row] as (name: String, image: UIImage)
        cell.iconView?.image = event.image
        return cell
    }
    
        // MARK - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = icons[indexPath.row] as (name: String, image: UIImage)
        guard let cell = self.iconChoiceCollectionView?.cellForItem(at: indexPath) as? IconChoiceCell else {
            return
        }
        
        cell.iconView?.image = UIImage(named: event.name + "-white")
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            guard let itemFormViewController = navController.viewControllers[navController.viewControllers.count - 2] as? ItemFormViewController else {
                return
            }
            let iconName = event.name
            itemFormViewController.itemFormView?.selectedIconName = iconName
            itemFormViewController.itemFormView?.selectedIconView?.image = UIImage(named: iconName + "-grey")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = self.iconChoiceCollectionView?.cellForItem(at: indexPath) as? IconChoiceCell else {
            return
        }
        cell.iconView?.image = UIImage(named: icons[indexPath.row].0 + "-grey")
    }
    
}

class IconChoiceCell: UICollectionViewCell {
    @IBOutlet var iconView: UIImageView?
}
