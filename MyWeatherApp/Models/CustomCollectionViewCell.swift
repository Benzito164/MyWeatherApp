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
    
    let weatherSymbol : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Cloudy")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        setUpViews()
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
