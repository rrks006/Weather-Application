//
//  LocationForecast.swift
//  Weather App
//
//  Created by Rituraj Singh on 5/23/21.
//

import Foundation
import UIKit

public struct Location: Codable {
    var city: City
    var timezone: Int = -5 * 3600
    
    init(city: City) {
        self.city = city
    }
    
    var name: String {
        get {
            return city.name
        }
    }
    var timeZone:Int = 0
    var temperature:String = "-"
}

//get list of all possible locations
extension Country {
    static public func getHardcodedData() -> [Country] {
        
        var countries:[Country] = []
        
        //add some european countries
        let germany = Country(name:"Germany")
        
        germany.cities += [City(name: "Berlin")]
        germany.cities += [City(name: "Hamburg")]
        germany.cities += [City(name: "Munich")]
        germany.cities += [City(name: "Cologne")]
        
        countries.append(germany)
        
        let italy = Country(name: "Italy")
        
        italy.cities += [City(name:"Rome")]
        italy.cities += [City(name:"Milan")]
        italy.cities += [City(name:"Naples")]
        italy.cities += [City(name:"Venice")]
        
        countries.append(italy)
        
        let france = Country(name:"France")
        
        france.cities += [City(name:"Paris")]
        france.cities += [City(name:"Marseille")]
        france.cities += [City(name:"Lyon")]
        
        countries.append(france)
        
        let uk = Country(name:"United Kingdom")
        
        uk.cities += [City(name:"London")]
        uk.cities += [City(name:"Birmingham")]
        uk.cities += [City(name:"Leeds")]
        uk.cities += [City(name:"Glasgow")]
        
        countries.append(uk)
        
        let spain = Country(name:"Spain")
        
        spain.cities += [City(name:"Madrid")]
        spain.cities += [City(name:"Barcelona")]
        spain.cities += [City(name:"Valencia")]
        
        countries.append(spain)
        
        return countries
    }
}


public class Forecast {
    var date: Date
    var weather: String = "undefined"
    var temperature = 100
    
    public init(date: Date, weather: String, temperature: Int) {
        self.date = date
        self.weather = weather
        self.temperature = temperature
    }
}

public class DailyForecast: Forecast {
    var isWholeDay = false
    var minTemp = 100
    var maxTemp = 100
}

public class LocationForecast {
    var location: Location?
    var weather: String?
    public static let degreeSymbol = "°"
    
    var forecastForToday: [Forecast]?
    var forecastForNextDays: [DailyForecast]?
    
    // create dummy data, to render on the UI
    static func getData() -> LocationForecast {
        let aMinute = 60
        let location = Location(city: City.NewYork)
        let forecast = LocationForecast()
        
        forecast.location = location
        forecast.weather = "Sunny"
        let weathers = ["sunny", "rain", "snow", "cloudy", "partly_cloudy"]
        
//        let today = Date().today()
        
        var detailedForecast:[Forecast] = []
        
        for i in 0...23 {
            detailedForecast.append(Forecast(date: Date().addingTimeInterval(TimeInterval(60 * aMinute * i)), weather: weathers.randomElement()!, temperature: 25 + Int.random(in: 1...2)))
        }
        forecast.forecastForToday = detailedForecast
        
        var nextDaysForecast:[DailyForecast] = []
        
        for i in 1...6 {
            let day = DailyForecast(date: Date().addingTimeInterval(TimeInterval(3600 * 24 * i)), weather: weathers.randomElement()! ,temperature: 25 + Int.random(in: 1...4))
            day.isWholeDay = true
            day.minTemp = 20 + Int.random(in: 1...4)
            day.maxTemp = 25 + Int.random(in: 1...4)
            nextDaysForecast.append(day)
        }
        
        forecast.forecastForNextDays = nextDaysForecast
        
        return forecast
    }
    
    static func getImageFor(weather:String) -> UIImage {
        switch weather.lowercased() {
             case "sunny":
                return #imageLiteral(resourceName: "sunny")
             case "rain":
                fallthrough
             case "rainy":
                 return #imageLiteral(resourceName: "rain")
             case "snow":
                 return #imageLiteral(resourceName: "snow")
             case "cloudy":
                 return #imageLiteral(resourceName: "cloudy")
             case "partly_cloudy":
                 return #imageLiteral(resourceName: "partly_cloudy")
             default:
                 return #imageLiteral(resourceName: "sunny")
        }
    }
}

extension Date {

   func today(format : String = "dd-MM-yyyy") -> String{
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = format
      return formatter.string(from: date)
   }
}

