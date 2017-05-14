//
//  ItemDetailsViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 25/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import OpenWeatherMapAPI

class ItemDetailsViewController: UIViewController {
    
    enum weatherEnum: String
    {
        case fewClouds = "few clouds"
        case scatteredClouds = "scattered clouds"
        case brokenClouds = "broken clouds"
        case showerRain = "shower rain"
        case rain = "rain"
        case thunderstorm = "thunderstorm"
        case snow = "snow"
        case mist = "mist"
    }
    
    var item: NSManagedObject?
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var alarmView: UIImageView!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var daysToGoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDisplayLabel: UILabel!
    
    @IBOutlet weak var weatherIconView: UIImageView!
    var date: Date?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        guard let title = self.item?.value(forKeyPath: "title") as? String else {
            print("Couldn't find a title for this item")
            return
        }
        
        guard let date = self.item?.value(forKeyPath: "date") as? Date else {
            return
        }
        self.date = date
        self.weatherDisplayLabel.isHidden = true
        
        let weatherAPI = OWMWeatherAPI(apiKey: "37be4c8a6b11f53b9c0164b9ee1748b3")
        weatherAPI?.setTemperatureFormat(kOWMTempCelcius)
        
        weatherAPI?.forecastWeather(byCityName: "London", withCallback: { (error: Error?, result: [AnyHashable : Any]?) in
            if error != nil {
                print("Error parsing weather, error \(error!.localizedDescription)")
                return
            }
            
            let daysAway = self.date!.daysFromToday()
            let placeInArrayDict: [String: Int] = ["1" : 4,"2" : 12,"3" : 20,"4" : 28,"5" : 36]
            guard let place = placeInArrayDict[daysAway] else {
                return
            }
            
            // data from the API
            guard let resultDict = result as? [String: Any],
                let forecastList = resultDict["list"] as? [[String: Any]],
                let forecastForDay = forecastList[place] as? [String: Any],
                let forecastDate = forecastForDay["dt_txt"] as? String,
                let weatherForDay = forecastForDay["weather"] as? [[String: Any]],
                let conditionsForDay = weatherForDay[0]["main"] as? String else {
                    return
            }
            
            
            // get the date of this item
            guard let eventDate = self.item?.value(forKeyPath: "date") as? Date else {
                return
            }
            
            let anEnum = weatherEnum(rawValue: conditionsForDay.lowercased())
            
            self.weatherDisplayLabel.isHidden = false
            self.weatherDisplayLabel.text = "\(conditionsForDay) for \(forecastDate)"
            
        })
        
        self.title =  title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let customNavigationController = self.navigationController as? CustomNavigationController,
            let date = self.item?.value(forKeyPath: "date") as? Date,
            let alarmActive = self.item?.value(forKeyPath: "notificationActive") as? Bool,
            let iconName = self.item?.value(forKeyPath: "iconName") as? String else {
                return
        }
        
        self.date = date
        self.dateLabel.text = date.stringForDate()
        
        if let image = self.title?.loadImageFromPath() {
            self.imageBackground.image = image
            customNavigationController.setNavBar(theme: .light)
        } else {
            self.daysToGoLabel.textColor = UIColor.black
            self.daysLeft.textColor = UIColor.black
            customNavigationController.setNavBar(theme: .lightBlackText)
        }
        
        let alarmColour = alarmActive ? "-yellow" : "-white"
        self.alarmView.image = UIImage(named: "bell" + alarmColour)
        self.iconView.image = UIImage(named: iconName + "-white")
        self.daysToGoLabel.text = self.date?.daysFromToday().range(of:"-") != nil ? "days ago" : "days to go!"
        self.daysLeft.text = self.date?.daysFromToday().replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemFormViewController = segue.destination as! ItemFormViewController
        itemFormViewController.currentItem = self.item
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.imageBackground.image = nil
    }
    
}
