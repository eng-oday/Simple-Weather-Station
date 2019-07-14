//
//  ChooseCityVC.swift
//  Weather Station
//
//  Created by Oday Dieg on 6/28/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit
import CoreData


var CityData = [MyCity]()
var Index: Int = 0 

class ChooseCityVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ReloadData {
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var TableView: UITableView!
    
    @IBAction func AddBtn(_ sender: Any) {
    }
    
    @IBAction func DeleteBtn(_ sender: Any) {
        DeleteData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        TableView.delegate = self
        TableView.dataSource = self
        TableView.separatorStyle = .none

        
       
    }
    
    
    func ReloadDataInTableView() {
         loadData()
        TableView.reloadData()
        print("data Is updated")
    }
    
    func loadData(with request: NSFetchRequest<MyCity> = MyCity.fetchRequest()) {
        
        do {
            
            CityData = try context.fetch(request)

        }
        catch {
            print("Error = \(error)")
        }
        
        TableView.reloadData()
    }
    
    
    func DeleteData()
    {
        
        for each in CityData
        {
            context.delete(each)
            
            ad.saveContext()
            TableView.reloadData()
        }
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CityData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTabelViewCell") as! CityTbelViewCell
        
           cell.CityNameLbl.text = CityData[indexPath.row].cityName
            cell.CityTempLbl.text = String(CityData[indexPath.row].citytemp)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Index = indexPath.row
        performSegue(withIdentifier: "GoToCell", sender: self)

    }
    
    
    
    
    // Swipe To REmove 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            context.delete(CityData[indexPath.row])
            ad.saveContext()
         
            CityData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToMap"
        {
        let SecondVc = segue.destination as! MapVC
        SecondVc.Delegate = self
        }
    }
    

}
extension ChooseCityVC: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0
        {
            loadData()
            
        }else
        {
            let request : NSFetchRequest<MyCity> = MyCity.fetchRequest()
            
            request.predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "cityName", ascending: true)]
            
            loadData(with: request)
            
        }
    }
    
    
}















