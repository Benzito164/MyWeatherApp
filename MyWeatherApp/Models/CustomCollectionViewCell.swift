//
//  CustomCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Beni Ibeh on 11/01/2019.
//  Copyright © 2019 Beni Ibeh. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.accessibilityValue = "locationLabel"
        return label
    }()
    
    let fullLocationName : UILabel = {
        let label = UILabel()
        label.text = "full location"
        label.accessibilityValue = "fullLocation"
        return label
    }()
    
    let temperatureLabel : UILabel = {
        let label = UILabel()
        label.text = "Add a "
        label.accessibilityValue = "temperatureLabel"
        return label
    }()
    
    var temperatureDescription : UILabel = {
        let label = UILabel()
        label.text = "Cloudy"
        label.accessibilityValue = "temperatureDesscription"
        return label
    }()
    
    var weatherSymbol : UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.accessibilityValue = "weatherSymbol"
        return image
    }()
    
    init(weatherIcon:UIImageView,weather:String,weatherLocation:String,temperature:String,weatherDescription:String,fullLocationNameText:String) {
        super.init(frame:UIScreen.main.bounds)
      backgroundColor = .brown
        weatherSymbol = weatherIcon
        temperatureLabel.text = temperature
        locationLabel.text = weatherLocation
        temperatureDescription.text = weatherDescription
        fullLocationName.text = fullLocationNameText
        self.setUpViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.brown
        self.setUpViews()
    }
    
    func setUpViews(){
      addSubview(temperatureLabel)
      addSubview(locationLabel)
      addSubview(weatherSymbol)
       weatherSymbol.setPositionOnView(top: topAnchor, left: leftAnchor, bottom: nil , right: nil, paddingTop: 0, leftPadding: 26, bottomPadding: 0, rightPadding: 0, width: 30, height: 30)
       temperatureLabel.setPositionOnView(top: weatherSymbol.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 1, leftPadding: 14, bottomPadding: 0, rightPadding: 0, width: 59, height: 15)
       locationLabel.setPositionOnView(top: temperatureLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 1, leftPadding:1, bottomPadding: 0, rightPadding: 0, width:0, height: 0)
      
      

        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
