//
//  HomeViewModel.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import Foundation
import CoreLocation
import Combine

class HomeViewModel: ObservableObject {
    
//    var monitorHandler: MonitorHandler
    var locationHandler: LocationHandlerMVVM
    
    @Published private(set) var clients: [Client] = []
    @Published var locationSelected: CLLocation = CLLocation()
    
    private var disposables = Set<AnyCancellable>()
    
    let locations: [CLLocation] = [
        CLLocation(latitude: -31.610775994463438, longitude: -60.6738229637158),
        CLLocation(latitude: -31.610766857481998, longitude: -60.67366203117579),
        CLLocation(latitude: -31.61077142597282, longitude: -60.67327579307979),
        CLLocation(latitude: -31.610387671961725, longitude: -60.67303975868778)
    ]

    
    init() {
//        self.monitorHandler = MonitorHandler()
        
//        startMonitoringRegion()
//        upDateStatusForRegion()
        self.locationHandler = LocationHandlerMVVM()
        self.startMonitoringRegion()
        
        self.updateDistance()
        
        
        
    }
    
    func startMonitoringRegion() {
        guard let lat = Truck.mock.first?.clients?.first?.location?.first! else { return }
        guard let long = Truck.mock.first?.clients?.first?.location?.last! else { return }
        guard let clientID = Truck.mock.first?.clients?.first?.id else { return }
        
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: 100.0, identifier: clientID.uuidString)
        locationHandler.startMonitoringRegions(regions: [region])
        
        clients = Truck.mock.first!.clients!
    }
    
//    func startMonitoringRegion() {
//        guard let clients = Truck.mock.first?.clients else { return }
//        self.clients = clients
//        monitorHandler.startMonitoringConditions(clients: clients)
//    }
//    
//    func upDateStatusForRegion() {
//        monitorHandler.$idsInside
//            .receive(on: DispatchQueue.main)
//            .print()
//            .sink(receiveValue: { [weak self] idsInside in
//                self?.update(idsInside: idsInside)
//            })
//            .store(in: &disposables)
//    }
    
    func updateDistance() {
        locationHandler.$userLocation
            .receive(on: DispatchQueue.main)
            .print()
            .sink(receiveValue: { [weak self] _ in
                self?.selectNearCoordinates()
            })
            .store(in: &disposables)
    }
    
    func selectNearCoordinates() {
        var nearCoordinates: CLLocation = locations.first!
        var distance = locationHandler.userLocation?.distance(from: nearCoordinates)
        
        for location in locations {
            let newDistance = locationHandler.userLocation?.distance(from: location)
            if (newDistance?.magnitude ?? 0) < (distance?.magnitude ?? 0) {
                distance = newDistance
                nearCoordinates = location
            }
        }
        locationSelected = nearCoordinates
        addNearDistance(distance?.magnitude ?? 0)
    }
    
    func addNearDistance(_ distance: Double) {
        var client = self.clients.first!
        client.distance.append(distance)
        clients[0] = client
        
    }
    
    func update(idsInside: [String]) {
        var updatedClients: [Client] = []
        for var client in clients {
            if idsInside.contains(client.id.uuidString) {
                client.isInGeofence = true
                client.status = .inZone
            } else {
                client.status = .watingToBeSelectedForDelivering
                client.isInGeofence = false
            }
            updatedClients.append(client)
        }
        self.clients = updatedClients
    }
    
    func changeToDeliveredStatus(client: Client) {
        guard let clientIndexToUpdate = self.clients.firstIndex(where: { $0.id == client.id }) else { return }
        clients[clientIndexToUpdate].status = .alreadyDelivered
    }
    
    func startNewDeliveryFor(_ client: Client) {
        guard let clientIndexToUpdate = self.clients.firstIndex(where: { $0.id == client.id }) else { return }
        clients[clientIndexToUpdate].status = .selectedToDeliver
    }
    
    
    
}
