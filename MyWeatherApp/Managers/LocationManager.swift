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
    private var _locations : [String] {
        get{
          return UserDefaults.standard.object(forKey: keyName) as? [String] ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyName)
        }
    }
    private let keyName = "LocationsArray"
    
    var userlocations:[String]{
        get {
            return  _locations
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
           saveUserDefaults()
        }

    }
    
    func emptyLocationArray()  {
        _locations.removeAll()
    }
    
    func doesLocationExistInArray(location : String) -> Bool {
        return _locations.contains(location)
    }
    
    fileprivate func saveUserDefaults(){
        UserDefaults.standard.set(_locations, forKey: keyName)
    }
    
    fileprivate func getUserDefaults() -> [String]{
     _locations =  UserDefaults.standard.object(forKey: keyName) as? [String] ?? [String]()
        return _locations
    }
}
