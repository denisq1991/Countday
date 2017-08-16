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
    
    var item: NSManagedObject?
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var alarmView: UIImageView!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var daysToGoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDisplayLabel: UILabel!
    
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
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
        if let image = self.title?.loadImageFromPath() {
            self.imageBackground.image = image
            customNavigationController.setNavBar(theme: .light)
        } else {
            self.daysToGoLabel.textColor = UIColor.black
            self.daysLeft.textColor = UIColor.black
            customNavigationController.setNavBar(theme: .lightBlackText)
        }
        
        guard let dayOfTheWeek = date.dayOfWeek() else {
            print("Couldn't find day of the week for date \(String(describing: self.date?.stringForDate()))")
            return
        }
        
        let alarmColour = alarmActive ? "-yellow" : "-white"
        self.alarmView.image = UIImage(named: "bell" + alarmColour)
        self.iconView.image = UIImage(named: iconName + "-white")
        self.daysToGoLabel.text = self.date?.daysFromToday().range(of:"-") != nil ? "days ago" : "days to go!"
        self.daysLeft.text = self.date?.daysFromToday().replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        self.dayOfTheWeekLabel.text = "(" + dayOfTheWeek + ")"
        self.configureWeatherIcon(forDate: date)
    }
    
    private func configureWeatherIcon(forDate date: Date) {
        
        let weatherAPI = OWMWeatherAPI(apiKey: "37be4c8a6b11f53b9c0164b9ee1748b3")
        weatherAPI?.setTemperatureFormat(kOWMTempCelcius)
        
        weatherAPI?.forecastWeather(byCityName: "London", withCallback: { (error: Error?, result: [AnyHashable : Any]?) in
            if error != nil {
                print("Error parsing weather, error \(error!.localizedDescription)")
                return
            }
            
            let daysAway = date.daysFromToday()
            
            // The API returns multiples of hours so we have to transform to days ourselves
            let placeInArrayDict: [String: Int] = ["1" : 4,"2" : 12,"3" : 20,"4" : 28,"5" : 36]
            if let place = placeInArrayDict[daysAway],
                let resultDict = result as? [String: Any],
                let forecastList = resultDict["list"] as? [[String: Any]] {
                
                let forecastForDay = forecastList[place]
                guard let forecastDate = forecastForDay["dt_txt"] as? String,
                    let weatherForDay = forecastForDay["weather"] as? [[String: Any]],
                    let conditionsForDay = weatherForDay[0]["main"] as? String else {
                        ("Error finding conditons for the day")
                        return
                }
                
                let imageName = conditionsForDay.lowercased().replacingOccurrences(of: " ", with: "-")
                self.iconView.image = UIImage(named: imageName)
                self.weatherDisplayLabel.isHidden = false
                self.weatherDisplayLabel.text = conditionsForDay
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemFormViewController = segue.destination as! ItemFormViewController
        itemFormViewController.currentItem = self.item
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.imageBackground.image = nil
    }
    
}
