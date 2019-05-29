//
//  MainViewController.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase
import UIKit
import CoreLocation
import MapKit

final class MainViewController: UIViewController, CLLocationManagerDelegate {
    private let repoRestSearch = RepoFoodIplm(api: APIService.share)
    private var restDetailSearch: [RestSearchDetail] = []
    private var reviews: [Reviews] = []
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    deinit {
        logDeinit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func configView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "RestCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "Cell")
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
    }
    
    func fetchDataSearch(longitude: String, latitude: String) {
        repoRestSearch.fetchNearFood(longitude: longitude,
                                     latitude: latitude,
                                     offset: self.restDetailSearch.count) { (result) in
            switch result {
            case .success(let response):
                guard let data = response?.restSearchDetail else { return }
                self.restDetailSearch += data
                self.collectionView.reloadData()
            case .failure(let error):
                self.showError(message: error?.errorMessage)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        fetchDataSearch(longitude: locValue.longitude.description, latitude: locValue.latitude.description)
    }
    
    @IBAction func touchInformation(_ sender: Any) {
        let userVc = UserViewController.instantiate()
        self.navigationController?.pushViewController(userVc, animated: true)
    }
    
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restDetailSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! RestCollectionViewCell
        cell.setRestDetail(rest: restDetailSearch[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == restDetailSearch.count - 1 {
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            fetchDataSearch(longitude: locValue.longitude.description, latitude: locValue.latitude.description)
        }
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2 - 10, height: view.frame.size.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 5, left: 5, bottom: 5, right: 5)
    }
}
