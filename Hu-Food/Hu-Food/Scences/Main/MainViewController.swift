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
    @IBOutlet weak var collectionView: UICollectionView!
    private let repoRestSearch = RepoFoodIplm(api: APIService.share)
    private var restDetailSearch: [RestSearchDetail] = []
    private var reviews: [Reviews] = []
    var locationManager: CLLocationManager!
    private var limit: Int = 20
    private var startIndex: Int = 0
    @IBOutlet weak var searchbar: UISearchBar!
    
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
                                     offset: self.restDetailSearch.count,
                                     term: "") { (result) in
            let data = result.restSearchDetail
            self.restDetailSearch += data
            self.collectionView.reloadData()
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
        let searchVC = SearchViewController.instantiate()
        self.navigationController?.viewControllers = [searchVC]
        searchBar.resignFirstResponder()
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        searchVC.location.updateValue(locValue.latitude.description, forKey: "latitude")
        searchVC.location.updateValue(locValue.longitude.description, forKey: "longitude")
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restDetailSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath) as? RestCollectionViewCell
            else {
                fatalError("DequeueReusableCell failed while casting")
        }
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
        return CGSize(width: view.frame.size.width / 2 - 10, height: view.frame.size.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 5, left: 5, bottom: 5, right: 5)
    }
}
