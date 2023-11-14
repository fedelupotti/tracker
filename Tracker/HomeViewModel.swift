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
    
    var monitorHandler: MonitorHandler
    
    @Published private(set) var clients: [Client] = []
    
    private var disposables = Set<AnyCancellable>()

    
    init() {
        self.monitorHandler = MonitorHandler()
        
        startMonitoringRegion()
        upDateStatusForRegion()
    }
    
//    func startMonitoringRegion() {
//        guard let lat = Truck.mock.first?.clients?.first?.location?.first! else { return }
//        guard let long = Truck.mock.first?.clients?.first?.location?.last! else { return }
//        guard let clientID = Truck.mock.first?.clients?.first?.id else { return }
//        
//        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: 10.0, identifier: clientID.uuidString)
//        locationVM.startMonitoringRegions(regions: [region])
//        
//        clients = Truck.mock.first!.clients!
//    }
    
    func startMonitoringRegion() {
        guard let clients = Truck.mock.first?.clients else { return }
        self.clients = clients
        monitorHandler.startMonitoringConditions(clients: clients)
    }
    
    func upDateStatusForRegion() {
        monitorHandler.$idsInside
            .receive(on: DispatchQueue.main)
            .print()
            .sink(receiveValue: { [weak self] idsInside in
                self?.update(idsInside: idsInside)
            })
            .store(in: &disposables)
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
