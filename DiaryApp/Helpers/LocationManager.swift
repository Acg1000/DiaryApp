//
//  LocationManager.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/23/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    weak var permissionsDelegate: LocationPermissionsDelegate?
    weak var delegate: LocationManagerDelegate?
    
    init(delegate: LocationManagerDelegate?, permissionsDelegate: LocationPermissionsDelegate?) {
        self.delegate = delegate
        self.permissionsDelegate = permissionsDelegate
        super.init()
        
        manager.delegate = self
    }
    
    static var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: return true
        default: return false
        }
    }
    
    func requestLocationAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.disallowedByUser
        } else if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    func requestLocation() {
        do {
            try requestLocationAuthorization()

        } catch LocationError.disallowedByUser {
            delegate?.failedWithError(LocationError.disallowedByUser)
        } catch LocationError.unableToFindLocation {
            delegate?.failedWithError(LocationError.unableToFindLocation)
        } catch LocationError.unknownError {
            delegate?.failedWithError(LocationError.unknownError)
        } catch {
            fatalError("\(error)")
        }
        
        manager.requestLocation()
    }
    
    func getPlacemark(from location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                let location = placemarks?[0]
                completionHandler(location)

            } else {
                completionHandler(nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionsDelegate?.authorizationSucceeded()
        } else {
            permissionsDelegate?.authorizationFailedWithStatus(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            delegate?.failedWithError(.unknownError)
            return
        }
        
        print(error.code)
        
        switch error.code {
        case .locationUnknown: delegate?.failedWithError(.unableToFindLocation)
        case .network: delegate?.failedWithError(.unableToFindLocation); print("network error")
        case .denied: delegate?.failedWithError(.disallowedByUser)
        default: return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            delegate?.failedWithError(.unableToFindLocation)
            return
        }
        
        getPlacemark(from: location) { placemark in
            guard let placemark = placemark else { return }
            
            let locationWithPlacemark = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, placemark: placemark)
            
            self.delegate?.obtainedLocation(locationWithPlacemark)

        }
    }
}

enum LocationError: Error {
    case unknownError
    case disallowedByUser
    case unableToFindLocation
}

protocol LocationPermissionsDelegate: class {
    func authorizationSucceeded()
    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus)
}

protocol LocationManagerDelegate: class {
    func obtainedLocation(_ location: Location)
    func failedWithError(_ error: LocationError)
}

