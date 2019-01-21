//
//  LocationManager.swift
//  MyWeatherApp
//
//  Created by Beni Ibeh on 12/01/2019.
//  Copyright © 2019 Beni Ibeh. All rights reserved.
//

import Foundation
class LocationManager {
    
    //MARK: - Variables 
    let locations = ["London","Paris","Liverpool","Lagos"]
    private var _locations = [String]()
    
    var userlocations:[String]{
        get {
            return _locations
        }
    }
    
    //MARK: - Methods
    func addLocation(location: String){
        if !doesLocationExistInArray(location: location){
             _locations.append(location)
        }
       
    }
    
    func deletelocationFromLocationArray(location: String){
        if doesLocationExistInArray(location: location){
            _locations.removeAll { $0 == location
            }
        }

    }
    
    func emptyLocationArray()  {
        _locations.removeAll()
    }
    
    func doesLocationExistInArray(location : String) -> Bool {
        return _locations.contains(location)
    }
}
