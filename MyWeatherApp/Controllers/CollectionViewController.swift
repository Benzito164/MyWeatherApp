//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Beni Ibeh on 10/01/2019.
//  Copyright © 2019 Beni Ibeh. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let headerId = "headerId"
    var savedLocation = [CustomCollectionViewCell]()
    var selectedLocation: CustomCollectionViewCell?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    collectionView.backgroundColor  = .white
    collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
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
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCollectionViewCell
        savedLocation.append(cell)
        return cell
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }

}

