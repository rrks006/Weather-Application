//
//  HomeViewController.swift
//  Weather App
//
//  Created by Rituraj Singh on 5/23/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //details outlet
    @IBOutlet weak var details: UICollectionView!
    @IBOutlet weak var nextDays: UITableView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var cityWeather: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    var model: LocationForecast?
    var forecast: [Forecast] = []
    let degree = "°"
    
    let collectionViewFormatter = DateFormatter()
    let tableViewFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get model data
        model = LocationForecast.getData()
        collectionViewFormatter.dateFormat = "H:mm"
        tableViewFormatter.dateFormat = "EEEE"
        details.dataSource = self
        nextDays.dataSource = self
        
        //handle the case if the location has no name
        city.text = model?.location?.name ?? "???"
        cityWeather.text = model?.weather ?? "???"
        temperature.text = getCurrentTemperature() + LocationForecast.degreeSymbol
    }
    
    func getCurrentTemperature() -> String {
        var lastTemperature = "?"
        if let forecastList = model?.forecastForToday {
            let currentDate = Date()
            
            for forecast in forecastList {
                if forecast.date < currentDate {
                    lastTemperature = "\(forecast.temperature)"
                }
            }
        }
        
        return lastTemperature
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "showFavorites":
                guard let favVC: FavoritesViewController = segue.destination as? FavoritesViewController else {
                    return
                }
                favVC.receivedData = 42
            default:
                break;
            }
        }
    }
    
    @IBAction func unwindToHomeScreenWithSender(sender: UIStoryboardSegue) {
        if let favoritesVC = sender.source as? FavoritesViewController {
            model = LocationForecast()
            model?.location = favoritesVC.selectedItem
        }
    }
    
    // MARK: private
    fileprivate func getIcon(weather:String) -> UIImage? {
        return LocationForecast.getImageFor(weather:weather)
    }
    
    @IBAction func OnFavoritesTap(_ sender: Any) {
        performSegue(withIdentifier: "showFavorites", sender: sender)
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.forecastForToday?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WeatherViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherViewCell
        let forecast = (model?.forecastForToday?[indexPath.row])!
        cell.time?.text = collectionViewFormatter.string(from: forecast.date)
        cell.icon?.image = getIcon(weather: forecast.weather)
        cell.temperature?.text = "\(forecast.temperature)\(self.degree)"
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.forecastForNextDays?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DailyForecastViewCell = tableView.dequeueReusableCell(withIdentifier: "FullDayWeatherCell", for: indexPath) as! DailyForecastViewCell
        let dailyForecast = (model?.forecastForNextDays![indexPath.row])!
        cell.day?.text = tableViewFormatter.string(from: dailyForecast.date)
        cell.icon?.image = getIcon(weather: dailyForecast.weather)
        cell.temperature?.text = "\(dailyForecast.minTemp)\(degree) - \(dailyForecast.maxTemp)\(degree)"
        return cell
    }
    
    
}
