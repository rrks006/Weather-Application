//
//  Location.swift
//  Weather Application
//
//  Created by Rituraj Singh on 5/29/21.
//

import Foundation


class Country: Codable {
    var name = "No Name"
    var cities:[City] = []
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, cities: [City]) {
        self.name = name
        self.cities = cities
    }
    
    
}

class City: Codable {
    var name = "No Name"
    init(name: String) {
        self.name = name
    }
    
    static var NewYork: City = {
        return City(name: "New York")
    } ()
}
