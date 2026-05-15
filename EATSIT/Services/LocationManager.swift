//
//  LocationManager.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {

    // MARK: - Properties

    private let locationManager = CLLocationManager()

    // MARK: - Published Properties

    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    // MARK: - Initialization

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Methods

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {

            manager.requestLocation()
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        userLocation = locations.last
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error: \(error.localizedDescription)")
    }
}
