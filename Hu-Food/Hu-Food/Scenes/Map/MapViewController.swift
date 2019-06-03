//
//  MapViewController.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 6/1/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

// swiftlint:disable number_separator
import MapKit
import  CoreLocation

final class MapViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    var restaurants: Restaurant!
    let regionInMeters = 1000.0
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        addAnnotation()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        logDeinit()
    }
    
    func addAnnotation() {
        let restaurantPoint = MKPointAnnotation()
        restaurantPoint.title = restaurants.name
        restaurantPoint.coordinate = CLLocationCoordinate2D(latitude: restaurants.coordinates.latitude,
                                                            longitude: restaurants.coordinates.longitude)
        mapView.addAnnotation(restaurantPoint)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            showError(message: "Location Service is Disable")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            showError(message: "Denied Permisson!")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showError(message: "Location Service is Disable")
        @unknown default:
            showError(message: "Error")
        }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate = getRestaurentLocation(for: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        return request
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getRestaurentLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = restaurants.coordinates.latitude
        let longitude = restaurants.coordinates.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            return
        }
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] (response, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }
            guard let response = response else { return }
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    @IBAction private func handleDirectionTapped(_ sender: Any) {
        getDirections()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {
            checkLocationServices()
            return
        }
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: regionInMeters,
                                        longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        return renderer
    }
}

extension MapViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
