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
        locationManager.addLocation(location: "Exeter")
        locationManager.addLocation(location: "Manchester")
      //let locations = locationManager.locations
        let weatherInfo = WeatherDataManager()
        weatherInfo.getWeatherForLocation(locationsArray:locationManager.userlocations, completionHandler: reloadCollectionView)
        collectionView.backgroundColor  = .gray
    collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    reloadCollectionView()
        displaySearchScreen()
    }
    
    @objc func displaySearchScreen(){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Location"
        //searchBar.backgroundColor = .blue
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
        tableView.setPositionOnView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 90, leftPadding: 5, bottomPadding: -300, rightPadding: 5, width: 20, height: 100)
        searchBar.setPositionOnView(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 37, leftPadding: 10, bottomPadding: 200, rightPadding: -15, width: 20, height: 50)
        view.backgroundColor = .gray
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
        
        return header
    }
    fileprivate func displayWeatherForHeader(header:CustomCollectionViewHeader,location: CustomCollectionViewCell){
        header.locationLabel.text = location.locationLabel.text
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
}
//MARK: - UI Search delegate Methods
extension CollectionViewController : UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      //  searchActive = true;
        print("line 155")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        print("line 160")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        print("line 165")
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
        print("line 170")
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

//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text as NSString
//            let range = tmp.range(of:searchText, options: NSString.CompareOptions.caseInsensitive)
//            return range.location != NSNotFound
//        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var city = [String]()
        city.append(filtered[indexPath.item])
         view.endEditing(true)
        let weatherInfo = WeatherDataManager()
        weatherInfo.getWeatherForLocation(locationsArray:city, completionHandler: reloadCollectionView)
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
        } else {
          //  filtered.append("")
           // cell.textLabel?.text = filtered[indexPath.row];
        }
        
        return cell;
    }
}



