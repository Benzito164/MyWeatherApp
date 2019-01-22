//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Beni Ibeh on 10/01/2019.
//  Copyright © 2019 Beni Ibeh. All rights reserved.
//

import UIKit
import SDWebImage
import GooglePlaces


var savedLocation = [CustomCollectionViewCell]()

class CollectionViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    //MARK:- Variables
    let cellId = "cellId"
    let headerId = "headerId"
    var selectedLocation: CustomCollectionViewCell?
    lazy var searchBar:UISearchBar = UISearchBar()
    var cellID =  "cell"
    
    let searchButton : UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.setImage(UIImage(named: "search"), for: .normal)
        button.addTarget(self, action: #selector(displaySearchScreen), for: .touchUpInside)
        return button
    }()
    
    let tableView: UITableView = UITableView()
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addSubview(searchButton)
        collectionView.addSubview(searchBar)
        searchButton.setPositionOnView(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: collectionView.bottomAnchor, right: collectionView.rightAnchor, paddingTop: 600, leftPadding: 150, bottomPadding: 20, rightPadding: 20, width: 60, height: 60)
        searchButton.makeCircle(view: searchButton)
        searchButton.backgroundColor = .clear
        let locationManager = LocationManager()
        let weatherInfo = WeatherDataManager()
        weatherInfo.getWeatherForLocation(locationsArray:locationManager.userlocations, completionHandler: reloadCollectionView)
        collectionView.backgroundColor  = .gray
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        reloadCollectionView()
        setUpGestureRecogniser()

    }
    
    @objc func displaySearchScreen(){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Location"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = self
        tableView.frame = CGRect(x:0, y: 100, width: width, height: height/2)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isOpaque = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .gray
        tableView.allowsSelection = true
        collectionView.isHidden = true
        view.addSubview(tableView)
        collectionView.willRemoveSubview(searchBar)
        view.addSubview(searchBar)
        tableView.setPositionOnView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 90, leftPadding: 5, bottomPadding: -290, rightPadding: 5, width: 20, height: 100)
        searchBar.setPositionOnView(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 37, leftPadding: 10, bottomPadding: 200, rightPadding: -15, width: 20, height: 50)
        view.backgroundColor = .gray
        tableView.reloadData()
    }
    
        func placeAutocomplete(place: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(place, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    self.filtered.append((result.attributedFullText.string))
                    self.tableView.reloadData()
                }
            }
        })
    }
}
//MARK: - UI Collection Views Methods
extension CollectionViewController{
    
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
        if savedLocation.count == 1  {
            displayWeatherForHeader(header: header, location: savedLocation[0])
        }
        else if selectedLocation != nil {
            displayWeatherForHeader(header: header, location: (selectedLocation)!)
        }
        if savedLocation.count == 0 {
            header.locationLabel.text = "Please Add a location"
            header.weatherSymbol.image = UIImage()
            header.temperatureLabel.text = ""
        }
        return header
    }
    fileprivate func displayWeatherForHeader(header:CustomCollectionViewHeader,location: CustomCollectionViewCell){
        header.locationLabel.text = location.locationLabel.text
        header.temperatureDescription.text = location.temperatureDescription.text
        header.temperatureLabel.text = location.temperatureLabel.text
        header.weatherSymbol.image = location.weatherSymbol.image
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
        cell.makeCircle(view: cell)
        return cell
    }
}
//MARK: - UI Search delegate Methods
extension CollectionViewController : UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        filtered.removeAll()
        data.removeAll()
        searchBar.removeFromSuperview()
        tableView.removeFromSuperview()
        collectionView.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        placeAutocomplete(place: searchBar.text!)
        tableView.reloadData()
        searchBar.isLoading = false
        view.endEditing(true)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print(searchText)

        searchBar.isLoading = true
        if searchText.count == 0{
            searchActive = false
            searchBar.isLoading = false
            filtered.removeAll()
            tableView.reloadData()
        }
        if searchText.count >= 3{
        placeAutocomplete(place: searchText)
        }
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cityList = [String]()
        let city = String(filtered[indexPath.item].dropLast(4))
        cityList.append(city)
         view.endEditing(true)
        let locationManager = LocationManager()
        locationManager.addLocation(location: city)
        let weatherInfo = WeatherDataManager()
        weatherInfo.getWeatherForLocation(locationsArray:cityList, completionHandler: reloadCollectionView)
        searchBarCancelButtonClicked(searchBar)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
        return filtered.count
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UITableViewCell;
        cell.backgroundColor = .gray
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        }
        return cell;
    }
}

//MARK: - UI Gesture Recogniser Set up and Method.
extension CollectionViewController : UIGestureRecognizerDelegate{
    
    public func setUpGestureRecogniser(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }
        
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let index = indexPath {
            let cell = self.collectionView.cellForItem(at: index) as! CustomCollectionViewCell
            savedLocation.remove(at: (indexPath?.row)!)
            let locationManager = LocationManager()
            locationManager.deletelocationFromLocationArray(location: cell.locationLabel.text ?? "")
            collectionView.reloadData()
        } else {
            print("Could not find index path")
        }
    }
}

