//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Beni Ibeh on 10/01/2019.
//  Copyright © 2019 Beni Ibeh. All rights reserved.
//

import UIKit
import SDWebImage
var savedLocation = [CustomCollectionViewCell]()
class CollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let headerId = "headerId"
    
    var selectedLocation: CustomCollectionViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = LocationManager()
        let locations = locationManager.locations
        let weatherInfo = WeatherDataManager()
        weatherInfo.getWeatherForLocation(locationsArray:locations)
    collectionView.backgroundColor  = .white
    collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
     public  func reloadCollectionView(){
        collectionView.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLocation = savedLocation[indexPath.item]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width , height: width)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CustomCollectionViewHeader

                    header.locationLabel.text = selectedLocation?.locationLabel.text
                    header.temperatureLabel.text = selectedLocation?.temperatureLabel.text
                    header.weatherSymbol.image = selectedLocation?.weatherSymbol.image
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3)/4
        return CGSize(width: width, height: width)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if savedLocation.count == 0 {
            return 1
        }
        return savedLocation.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCollectionViewCell
        if savedLocation.count == 1{
                 cell.locationLabel.text = savedLocation[indexPath.item].locationLabel.text
                 cell.temperatureLabel.text = savedLocation[indexPath.item].temperatureLabel.text
                 cell.weatherSymbol.image = savedLocation[indexPath.item].weatherSymbol.image
        }
        if savedLocation.count > 1{
            cell.locationLabel.text = savedLocation[indexPath.item].locationLabel.text
            cell.temperatureLabel.text = savedLocation[indexPath.item].temperatureLabel.text
            cell.weatherSymbol.image = savedLocation[indexPath.item].weatherSymbol.image
        }

  
        return cell
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }

}

