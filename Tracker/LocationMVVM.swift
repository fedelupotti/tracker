//
//  LocationMVVM.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import Foundation
import CoreLocation
import Combine

final class LocationHandlerMVVM: NSObject {
    
    // MARK: - Public properties
    private let locationManager = CLLocationManager()
    
    @Published private(set) var enteredRegion: CLRegion = CLRegion()
    @Published private(set) var exitedRegion: CLRegion = CLRegion()
    @Published private(set) var locationAuthorizationChanged = false
    
    // MARK: - Private properties
    private(set) var userLocation: CLLocation?
    private(set) var locationActive = false
    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Private methods
    private func stopMonitoringRegions() {
        let monitoredRegions = locationManager.monitoredRegions
        for region in monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    private func reportLocationAuthorizationChange() {
        // User defaults to check if location services authorization changed
        let status = getCLAuthorizationStatusString()
        let currentPrecisionLocationStatus = hasPresicionLocationEnable()
        
        if currentPrecisionLocationStatus && (status == "authorizedWhenInUse" || status == "authorizedAlways") {
            startUpdatingLocation()
            locationAuthorizationChanged = true
        }
        
        
    }
    
    // MARK: - Public methods
    func setupLocationHandler() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
        locationManager.distanceFilter = .leastNonzeroMagnitude
    }
    
    func startMonitoringRegions(regions: [CLCircularRegion]) {
        regions.forEach { region in
            locationManager.startMonitoring(for: region)
        }
    }
    
    func stopMonitoringRegions(regions: [CLCircularRegion]) {
        regions.forEach { region in
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func stop() {
        stopMonitoringRegions()
        locationActive = false
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func hasLocationServicesEnabled() -> Bool {
        switch getCLAuthorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    func getCLAccuracyAuthorization() -> CLAccuracyAuthorization? {
        if #available(iOS 14.0, *) {
            return locationManager.accuracyAuthorization
        } else {
            return nil
        }
    }
    
    // Returns the app localization authorization
    func getCLAuthorizationStatus() -> CLAuthorizationStatus {
        authorizationStatus
    }
    
    func locationAuthorizationChangedHandled() {
        locationAuthorizationChanged = false
    }
    
    func hasPresicionLocationEnable() -> Bool {
        switch getCLAccuracyAuthorization() {
        case .reducedAccuracy, .none:
            return false
        case .fullAccuracy:
            return true
        @unknown default:
            return false
        }
    }
    
    // Returns the device global localization authorization
    func areGlobalLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func getCLAuthorizationStatusString() -> String {
        switch authorizationStatus {
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .denied:
            return "denied"
        case .restricted:
            return "restricted"
        case .notDetermined:
            return "notDetermined"
        @unknown default:
            return "notDetermined"
        }
    }
}

extension LocationHandlerMVVM: CLLocationManagerDelegate {
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        self.userLocation = userLocation
        if !locationActive {
            locationActive = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        reportLocationErrorToMixPanel(error: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        enteredRegion = region
        print(region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        exitedRegion = region
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        reportMonitoringRegionErrorToMixPanel(schoolID: region?.identifier ?? "", error: error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            // Fallback on earlier versions
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        reportLocationAuthorizationChange()
    }
}

class MonitorHandler: ObservableObject, Identifiable {
    
    private let manager: CLLocationManager
    
    var monitor: CLMonitor?
    
    private let monitorNameID = "TrackerAppID"
    
    @Published var idsInside: [String] = []
    
    init() {
        self.manager = CLLocationManager()
        self.manager.requestWhenInUseAuthorization()
    }
    
    func startMonitoringConditions(clients: [Client]) {
        Task {
            if monitor == nil  {
                monitor = await CLMonitor(monitorNameID)
            }
            for identifier in await monitor?.identifiers ?? [""] {
                await monitor?.remove(identifier)
            }
            for client in clients {
                let condition = getCircularGeographicCondition(client: client)
                await monitor?.add(condition, identifier: client.id.uuidString)
            }
            
            for try await event in await monitor!.events {
                
                if event.state == .satisfied {
                    idsInside.append(event.identifier)
                } else {
                    idsInside.removeAll(where: { $0 == event.identifier })
                }
            }
        }
    }
    
    private func getCircularGeographicCondition(client: Client) -> CLMonitor.CircularGeographicCondition {
        return CLMonitor.CircularGeographicCondition(
            center: client.coordinate,
            radius: CLLocationDistance(client.radius)
        )
    }
}
