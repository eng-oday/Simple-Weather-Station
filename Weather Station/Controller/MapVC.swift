//
//  MapVC.swift
//  Weather Station
//
//  Created by Oday Dieg on 6/28/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON




protocol ReloadData {
    func ReloadDataInTableView()
}


extension Date {
    func DayOfTheWeek()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}


var weatherDataModel = WeatherDataModel() // Global Instance variable of class"weatherDataModel"


class MapVC: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate {
    
    
    let LocationManager = CLLocationManager()
    let Authorization = CLLocationManager.authorizationStatus()

    let RegionRedius: Double = 1000
    
      let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?cnt=10"
      let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
     var date : String = ""
    var latitude: String = ""
    var longitude: String = ""
    var Delegate: ReloadData?
    
    
    @IBOutlet weak var MapView: MKMapView!
    
    
    @IBAction func SetLocation(_ sender: Any) {
        if Authorization == .authorizedAlways || Authorization == .authorizedWhenInUse
        {
            GetUserLocation()
        }else
        {
            DisplayErrorToUser(ErrorTxt: "Please Give Me Acces To Your Location")
        }
        
    }
    
    @IBAction func SaveBtn(_ sender: Any) {
        
        let params:[String:String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
        
        getWeather(url: WEATHER_URL, parameters: params)
        
       
         
        dismiss(animated: true, completion: nil )
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapView.delegate = self
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        LocationManager.requestAlwaysAuthorization()
        LocationManager.startUpdatingLocation()

        DoubleTap()
      
    }
    
    
    
    
    func DoubleTap()
    {
        let Tapped = UITapGestureRecognizer(target: self, action: #selector (Droppin(sender:)))
        Tapped.numberOfTapsRequired = 1
        Tapped.delegate = self
        MapView.addGestureRecognizer(Tapped)
        
        
    }
    
    @objc func Droppin(sender:UITapGestureRecognizer )
    {
        RemovePin()
        
        let TouchPoint =  sender.location(in: MapView)
        let TouchPointCoordinate = MapView.convert(TouchPoint, toCoordinateFrom: MapView)
        
        let Annotation = DropablePin(coordinate: TouchPointCoordinate, Identifier: "MyLocationPin")
        
        MapView.addAnnotation(Annotation)
       
         latitude = String(TouchPointCoordinate.latitude)
         longitude = String(TouchPointCoordinate.longitude)
        
        print(latitude,"........",longitude)
        
        
    }
    
    
    
   
    
    func DisplayErrorToUser(ErrorTxt: String)
    {
        let Alert = UIAlertController.init(title: "Error", message: ErrorTxt, preferredStyle: .alert)
        let DismissButton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        Alert.addAction(DismissButton)
        self.present(Alert, animated: true, completion: nil)
    }
    
    
    
    func RemovePin()
    {
        for pin in MapView.annotations
        {
            MapView.removeAnnotation(pin)
        }
    }
    
    
func GetUserLocation()
{
    guard let Coordinate = LocationManager.location?.coordinate else {
        return
    }
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(Coordinate, RegionRedius * 2.0, RegionRedius * 2.0)
    
    MapView.setRegion(coordinateRegion, animated: true)
    
    }
    
    func getWeather(url:String, parameters:[String:String])
    {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
         let json = response.data
            
            do {
                let decoder = JSONDecoder()
                print("Next Step is decode")
                
                let WeatherData = try decoder.decode(weatherData.self, from: json!)
                
                print("Decode is done ")
                
                
                
                let CityName = WeatherData.city?.name
                  print("cityName: \(CityName!)")
                let CountryName = WeatherData.city?.country
                print("CountryName: \(CountryName!)")
                let CurrentTemp = Int((WeatherData.list![0].temp?.day)! - 273.15)
                print("CurrentTemp: \(CurrentTemp)")
                let CurrentDay = WeatherData.list![0].dt
                let tempOfMorning = Int((WeatherData.list![0].temp?.morn)! - 273.15)
                let tempOfEvening = Int((WeatherData.list![0].temp?.eve)! - 273.15)
                let tempOfNight = Int((WeatherData.list![0].temp?.night)! - 273.15)
                
                let currentCondition = WeatherData.list![0].weather[0].id
                weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: currentCondition!)
                
                 let currentdescription = WeatherData.list![0].weather[0].description
                            
               
                
                //Convert dt to date
                let unixConvertDate = Date(timeIntervalSince1970: Double(CurrentDay!))
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full
                dateFormatter.dateFormat = "EEEE"
                dateFormatter.timeStyle = .none
                self.date = unixConvertDate.DayOfTheWeek()
                print("CurrentDay = \(self.date)")
                
                
                
                let mycity = MyCity (context: context)
                
                mycity.cityName = CityName
                mycity.citytemp = Int64(CurrentTemp)
                mycity.countryName = CountryName
                mycity.currentDay = self.date
                mycity.morning = Int32(Double(tempOfMorning))
                mycity.evening = Int32(Double(tempOfEvening))
                mycity.night = Int32(Double(tempOfNight))
                mycity.desc = currentdescription
                mycity.condition = Int32(Int(currentCondition!))
                mycity.image = weatherDataModel.weatherIconName
                do
                {
                    ad.saveContext()
                    print("Data is Stored")
                }catch
                {
                    self.DisplayErrorToUser(ErrorTxt: "Can't Store Data")
                }
                
                self.Delegate?.ReloadDataInTableView()
                
            }catch
            {
                print("i cant get data")
                
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
  
}
