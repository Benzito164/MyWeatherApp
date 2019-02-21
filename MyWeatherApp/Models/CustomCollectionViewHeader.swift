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
        label.text = "Add a Location"
        label.textColor = .white
        label.accessibilityIdentifier = "locationLabelIdentifier"
        return label
    }()
    
    var temperatureLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        return label
    }()
    
    var temperatureDescription : UILabel = {
        let label = UILabel()
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
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
        backgroundColor = .gray
        setUpViews()
    }
    
    
    
    func setUpViews(){
        addSubview(weatherSymbol)
        addSubview(temperatureLabel)
        addSubview(locationLabel)
        addSubview(temperatureDescription)
        weatherSymbol.setPositionOnView(top: nil, left: nil, bottom: temperatureDescription.topAnchor , right: nil, paddingTop: 0, leftPadding: 120, bottomPadding: 0, rightPadding: 0, width: 85, height: 65)
        temperatureDescription.setPositionOnView(top: nil, left: nil, bottom: temperatureLabel.topAnchor, right: nil, paddingTop: 0, leftPadding: 120, bottomPadding: -20, rightPadding: 0, width: 190, height: 45)
        temperatureLabel.setPositionOnView(top:nil, left: nil, bottom: locationLabel.topAnchor , right: nil, paddingTop: 0, leftPadding: 120, bottomPadding: -20, rightPadding: 0, width: 190, height: 50)
        locationLabel.setPositionOnView(top: nil, left: nil, bottom: bottomAnchor, right:nil, paddingTop: 0, leftPadding: 120, bottomPadding: -30, rightPadding: 0, width: 290, height: 50)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
