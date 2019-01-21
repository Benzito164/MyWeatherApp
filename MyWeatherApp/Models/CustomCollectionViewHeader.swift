//
//  CustomCollectionViewHeader.swift
//  MyWeatherApp
//
//  Created by Beni Ibeh on 11/01/2019.
//  Copyright © 2019 Beni Ibeh. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewHeader: UICollectionViewCell {
    
    var locationLabel : UILabel = {
        let label = UILabel()
        label.text = "Anfield"
        return label
    }()
    
    var temperatureLabel : UILabel = {
        let label = UILabel()
        label.text = "23°C"
        return label
    }()
    
    var weatherSymbol : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        setUpViews()
    }
    
    
    
    func setUpViews(){
        addSubview(weatherSymbol)
        addSubview(temperatureLabel)
        addSubview(locationLabel)
        weatherSymbol.setPositionOnView(top: topAnchor, left: leftAnchor, bottom: nil , right: nil, paddingTop: 0, leftPadding: -2, bottomPadding: 0, rightPadding: 0, width: 45, height: 45)
        locationLabel.setPositionOnView(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 100, height: 100)
        temperatureLabel.setPositionOnView(top:topAnchor, left: leftAnchor, bottom: locationLabel.bottomAnchor , right: rightAnchor, paddingTop: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 100, height: 100)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}