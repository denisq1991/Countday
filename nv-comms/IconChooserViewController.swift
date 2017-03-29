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
    
    let icons = [("bag", #imageLiteral(resourceName: "bag")),
                 ("cake", #imageLiteral(resourceName: "cake")),
                 ("car", #imageLiteral(resourceName: "car")),
                 ("diamond", #imageLiteral(resourceName: "diamond")),
                 ("giftbox", #imageLiteral(resourceName: "giftbox")),
                 ("graduate", #imageLiteral(resourceName: "graduate")),
                 ("hospital", #imageLiteral(resourceName: "hospital")),
                 ("music", #imageLiteral(resourceName: "music")),
                 ("paw", #imageLiteral(resourceName: "paw")),
                 ("plane", #imageLiteral(resourceName: "plane")),
                 ("trophy", #imageLiteral(resourceName: "trophy"))] as [(String, UIImage)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconChoiceCell", for: indexPath) as! IconChoiceCell
        let eventType = icons[indexPath.row] as (name: String, image: UIImage)
        cell.iconView?.image = eventType.image
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.iconChoiceCollectionView?.cellForItem(at: indexPath) as? IconChoiceCell else {
            return
        }
        cell.backgroundColor = UIColor.blue
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            guard let viewController = navController.viewControllers[navController.viewControllers.count - 2] as? ItemFormViewController else {
                return
            }
            let eventType = icons[indexPath.row] as (name: String, image: UIImage)
            let iconName = eventType.name
            viewController.itemFormView?.selectedIconView?.backgroundColor = UIColor.blue
            viewController.itemFormView?.selectedIconView?.image = UIImage(named: iconName)
            viewController.itemFormView?.selectedIconName? = iconName
        }
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
