//
//  MainViewController.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase
import CoreLocation

final class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchbar: UISearchBar!
    @IBOutlet private weak var btnUser: UIButton!
    private let repoRestSearch = FoodRepository(api: APIService.share)
    private var restaurants: [Restaurant] = []
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configLocationManager()
    }
    
    deinit {
        logDeinit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func configLocationManager() {
        locationManager = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func configView() {
        searchbar.delegate = self
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: RestaurantCell.self)
        }
    }
    
    func fetchDataSearch(longitude: String, latitude: String) {
        repoRestSearch.fetchNearFood(longitude: longitude,
                                     latitude: latitude,
                                     offset: restaurants.count,
                                     term: "") { (result) in
                                        switch result {
                                        case .success(let response):
                                            guard let data = response?.restaurants else { return }
                                            if data.isEmpty { return }
                                            self.restaurants += data
                                            self.collectionView.reloadData()
                                        case .failure(error: let error):
                                            self.showError(message: error?.errorMessage)
                                        }
        }
    }

    @IBAction private func handleUserTapped(_ sender: Any) {
        let userVC = UserViewController.instantiate()
        navigationController?.pushViewController(userVC, animated: true)
    }
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

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = locationManager.location?.coordinate else { return }
        fetchDataSearch(longitude: locValue.longitude.description, latitude: locValue.latitude.description)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RestaurantCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setRestDetail(rest: restaurants[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == restaurants.count - 1 {
            guard let locValue = locationManager.location?.coordinate else { return }
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

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
