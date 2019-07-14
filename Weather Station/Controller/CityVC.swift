//
//  CityVC.swift
//  Weather Station
//
//  Created by Oday Dieg on 7/14/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit

class CityVC: UIViewController {
    
    @IBOutlet weak var imageConditionIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cityAndCountryNameLabel: UILabel!
    @IBOutlet weak var mornTempLabel: UILabel!
    @IBOutlet weak var evenTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var fixedMorningLb: UILabel!
    @IBOutlet weak var fixedEveningLb: UILabel!
    @IBOutlet weak var fixedNightLb: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityAndCountryNameLabel.text = "\(CityData[Index].cityName!), \(CityData[Index].countryName!)"
        
        dayLabel.text = "Today is \(CityData[Index].currentDay!)"
        
        tempLabel.text = "\(CityData[Index].citytemp)°"
        
        mornTempLabel.text = "\(CityData[Index].morning)°"
        
        evenTempLabel.text = "\(CityData[Index].evening)°"
        
        nightTempLabel.text = "\(CityData[Index].night)°"
        
        descLabel.text = CityData[Index].desc
        
        imageConditionIcon.image = UIImage(named: CityData[Index].image ?? "")
        
        
    }
    @IBAction func CloseCityVc(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
