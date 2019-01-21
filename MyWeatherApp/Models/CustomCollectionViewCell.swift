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
        label.text = "Liverpool"
        return label
    }()
    
    let temperatureLabel : UILabel = {
        let label = UILabel()
        label.text = "23°C"
        return label
    }()
    
    var weatherSymbol : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"Rain")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
   init(weatherIcon:UIImageView,weather:String,weatherLocation:String,temperature:String) {
        super.init(frame:UIScreen.main.bounds)
      backgroundColor = .brown
        weatherSymbol = weatherIcon
        temperatureLabel.text = temperature+"°C"
        locationLabel.text = weatherLocation
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
        locationLabel.setPositionOnView(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        temperatureLabel.setPositionOnView(top: topAnchor, left: leftAnchor, bottom: locationLabel.bottomAnchor , right: rightAnchor, paddingTop: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 10, height: 10)
        weatherSymbol.setPositionOnView(top: topAnchor, left: leftAnchor, bottom: nil , right: nil, paddingTop: 0, leftPadding: -2, bottomPadding: 0, rightPadding: 0, width: 30, height: 30)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
