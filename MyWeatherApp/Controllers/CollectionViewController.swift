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
import Foundation


var savedLocation = [CustomCollectionViewCell]()

class CollectionViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    //MARK:- Variables
    let cellId = "cellId"
    let headerId = "headerId"
    var selectedLocation: CustomCollectionViewCell?
    lazy var searchBar:UISearchBar = UISearchBar()
    var cellID =  "cell"
    let tableView: UITableView = UITableView()
    var searchActive : Bool = false
    let locationManager = LocationManager()
    let weatherInfo = WeatherDataManager()
    
    let searchButton : UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.accessibilityIdentifier = "locationSearchButton"
        button.setImage(UIImage(named: "search"), for: .normal)
        button.addTarget(self, action: #selector(displaySearchScreen), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    let restartButton : UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.accessibilityIdentifier = "restartButton"
        button.setImage(UIImage(named: "SettingsIcon"), for: .normal)
        button.addTarget(self, action: #selector(restoreAppToDefault), for: .touchUpInside)
        return button
    }()
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    override var prefersStatusBarHidden: Bool{
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViewAndButtons()
        print(locationManager.userlocations.count)
        weatherInfo.getWeatherForLocation(locationsArray:locationManager.userlocations, completionHandler: reloadCollectionView)
        reloadCollectionView()
        setUpDeleteLocationGestureRecogniser()
    }
    
    func setUpCollectionViewAndButtons(){
        [searchBar,searchButton,restartButton].forEach {view.addSubview($0)}
       let leftPaddingValue =  (UIScreen.main.bounds.width/2) - 25
        searchButton.setPositionOnView(top: nil, left: collectionView.safeAreaLayoutGuide.leftAnchor, bottom: collectionView.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, leftPadding: leftPaddingValue, bottomPadding: -60, rightPadding: 0, width: 50, height: 50)
        restartButton.setPositionOnView(top:view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right:collectionView.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, leftPadding: 0, bottomPadding: 0, rightPadding: -10, width: 30, height: 30)
        searchButton.makeCircle()
        searchButton.backgroundColor = .clear
        collectionView.backgroundColor  = .gray
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    @objc func restoreAppToDefault (){
        let alert = UIAlertController(title: "Reset App?", message:"All your saved locations will be deleted", preferredStyle: .actionSheet)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { (dismiss) in
            savedLocation.removeAll()
            self.locationManager.removeAllLocations()
            self.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertInfo) in

        }
        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        present(alert, animated: true, completion: nil)

    }
    
    @objc func displaySearchScreen(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Location"
        searchBar.sizeToFit()
        searchBar.accessibilityValue = "UISearchBar"
        searchBar.accessibilityIdentifier = "UISearchBar"
        searchBar.isTranslucent = false
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = self
        searchBar.backgroundColor = .gray
        tableView.backgroundColor = .gray
        tableView.frame = CGRect(x:0, y: 100, width: 0, height: 0)
        tableView.dataSource = self
        tableView.accessibilityValue = "locationResultTable"
        tableView.delegate = self
        tableView.isOpaque = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.allowsSelection = true
        collectionView.isHidden = true
        view.addSubview(tableView)
        collectionView.willRemoveSubview(searchBar)
        view.addSubview(searchBar)
        searchBar.setPositionOnView(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 7, leftPadding: 10, bottomPadding: 0, rightPadding: -15, width: 0, height: 45)
        tableView.setPositionOnView(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, leftPadding: 5, bottomPadding: -20, rightPadding: -15, width: 0, height: 0)
        view.backgroundColor = .gray
        tableView.reloadData()
        shouldHideButtonsOnCollectionViewScreen(hide: true)
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
            header.locationLabel.text = ""
            header.weatherSymbol.image = UIImage()
            header.temperatureLabel.text = "Please Add a location"
            header.temperatureDescription.text = ""
            
        }
        return header
    }
    
    fileprivate func displayWeatherForHeader(header:CustomCollectionViewHeader,location: CustomCollectionViewCell){
        header.locationLabel.text = location.fullLocationName.text
        header.temperatureDescription.text = location.temperatureDescription.text
        header.temperatureLabel.text = (location.temperatureLabel.text?.components(separatedBy: ".").first)!+"°C"
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
            displayWeatherForCollectionView(cell: cell, savedLocation: savedLocation[indexPath.item])
        }
        if savedLocation.count > 1{
              displayWeatherForCollectionView(cell: cell, savedLocation: savedLocation[indexPath.item])
        }
        cell.makeCircle()
        return cell
    }
    
    fileprivate func displayWeatherForCollectionView(cell:CustomCollectionViewCell, savedLocation:CustomCollectionViewCell){
        cell.locationLabel.text = savedLocation.locationLabel.text
        cell.locationLabel.accessibilityIdentifier = "weatherCellid"
        cell.temperatureLabel.text = (savedLocation.temperatureLabel.text?.components(separatedBy: ".").first)!+"°C"
        cell.weatherSymbol.image = savedLocation.weatherSymbol.image
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
        searchBar.isLoading = false
        searchBar.text = ""
        collectionView.isHidden = false
        shouldHideButtonsOnCollectionViewScreen(hide: false)
        
    }
    
    func shouldHideButtonsOnCollectionViewScreen(hide:Bool){
       searchButton.isHidden =  hide
       restartButton.isHidden = hide
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        placeAutocomplete(place: searchBar.text!)
        tableView.reloadData()
        searchBar.isLoading = false
        searchBar.text = ""
        view.endEditing(true)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
        let city = filtered[indexPath.item]
        let test = city.dropLast(5)
        print(test)
        cityList.append(city)
         view.endEditing(true)
        let locationManager = LocationManager()
        locationManager.addLocation(location: city)
        let weatherInfo = WeatherDataManager()
        weatherInfo.getWeatherForLocation(locationsArray:locationManager.userlocations, completionHandler: reloadCollectionView)
        searchActive = false;
        filtered.removeAll()
        data.removeAll()
      searchBar.removeFromSuperview()
      tableView.removeFromSuperview()
      collectionView.isHidden = false
      searchBar.isLoading = false
      searchBar.text = ""
      shouldHideButtonsOnCollectionViewScreen(hide: false)
    }
    //"Weather Type: Rainy Clouds \nTemp: 79°C"
//     func displayweatherInfoInActionSheet(weatherInformation:String,weatherImage:UIImage){
//        let alert = UIAlertController(title: "Weaather Info", message:weatherInformation, preferredStyle: .actionSheet)
//        let alertDismissAction = UIAlertAction(title: "Dismiss", style: .destructive) { (dismiss) in
//            self.searchActive = false;
//            self.filtered.removeAll()
//            self.data.removeAll()
//            self.searchBar.removeFromSuperview()
//            self.tableView.removeFromSuperview()
//            self.searchBar.isLoading = false
//            self.searchBar.text = ""
//            self.collectionView.isHidden = false
//        }
//        let alertAddAction = UIAlertAction(title: "Add Location", style: .default) { (alertInfo) in
//            self.searchBar.removeFromSuperview()
//            self.tableView.removeFromSuperview()
//            self.collectionView.isHidden = false
//            self.searchBar.isLoading = false
//            self.searchBar.text = ""
//        }
//        alert.addAction(alertAddAction)
//        alert.addAction(alertDismissAction)
//        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
//        imgViewTitle.image = UIImage(named:"Sun")
//        alert.view.addSubview(imgViewTitle)
//        present(alert, animated: true, completion: nil)
//
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.backgroundColor = .gray
        cell.accessibilityIdentifier = "weatherCell"
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
            cell.accessibilityIdentifier = "weatherCell"
            cell.textLabel?.accessibilityIdentifier = "textLabelIndentifier"
            cell.accessibilityValue = "accesibityValue"
            cell.textLabel?.accessibilityValue = "textLabelacessValue"
        }
        return cell;
    }
}

//MARK: - UI Gesture Recogniser Set up and Method.
extension CollectionViewController : UIGestureRecognizerDelegate{
    
    public func setUpDeleteLocationGestureRecogniser(){
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
        
        if let _ = indexPath {
            let locationToBeDeleted = savedLocation[(indexPath?.row)!].fullLocationName.text
            let locationManager = LocationManager()
            locationManager.deletelocationFromLocationArray(location: locationToBeDeleted ?? "")
            savedLocation.remove(at: (indexPath?.row)!)
            collectionView.reloadData()
        } else {
            print("Could not find index path")
        }
    }
}

