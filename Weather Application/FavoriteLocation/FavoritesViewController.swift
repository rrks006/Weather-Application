//
//  FavoritesViewController.swift
//  Weather Application
//
//  Created by Rituraj Singh on 5/29/21.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favorites:[Location] = []
    let formatter = DateFormatter()
    public var receivedData: Int?
    var selectedItem: Location?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "H:mm"
        loadFavorites()
        
        if favorites.count == 0 {
            var loc = Location.init(city: City.NewYork)
            loc.timeZone = -5 * 3600
            favorites.append(loc)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func saveFavorites(favorites: [Location]) {
        let encoded = try? JSONEncoder().encode(favorites)
        let documentDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documentDirectoryPathString + "/favorites.json"
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: encoded, attributes: nil)
        } else {
            if let file = FileHandle(forWritingAtPath: filePath) {
                file.write(encoded!)
            }
        }
    }
    
    @IBAction func OnAddLocationTap(_ sender: Any) {
        performSegue(withIdentifier: "showPlaces", sender: sender)
    }
    
    func loadFavorites() {
        let documentDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documentDirectoryPathString + "/favorites.json"
        if FileManager.default.fileExists(atPath: filePath) {
            if let file = FileHandle(forReadingAtPath: filePath) {
                let data = file.readDataToEndOfFile()
                let favs = try? JSONDecoder().decode([Location].self, from: data)
                favorites = favs!
            }
        }
    }
    
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == favorites.count {
            // To do: open a new view conroller
        } else {
            let selectedItem = favorites[indexPath.row]
            // pick this location and save all location
            print("Location: \(favorites[indexPath.row].name)")
            saveFavorites(favorites: favorites)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index < favorites.count {
            let location = favorites[index]
            let cell: FavoriteViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! FavoriteViewCell
            cell.city.text = location.city.name
            cell.temperature.text = location.temperature + LocationForecast.degreeSymbol
            let date = Date()

            formatter.timeZone = TimeZone(secondsFromGMT: location.timeZone)
            print("NY date: \(formatter.string(from: date))")
            cell.time.text = formatter.string(from: date)
            return cell
            
        }
        //last cell is a static one
        let cell:StaticViewCell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell", for: indexPath) as! StaticViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count + 1
    }
}
