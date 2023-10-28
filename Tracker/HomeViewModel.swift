//
//  HomeViewModel.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import Foundation
import CoreLocation

class HomeViewModel: ObservableObject {
    
    private var locationVM: LocationHandlerMVVM
    
    @Published private(set) var clients: [Client] = []
    
    init(locationViewModel: LocationHandlerMVVM) {
        self.locationVM = locationViewModel
        
        locationViewModel.setupLocationHandler()
        startMonitoringRegion()
    }
    
    func startMonitoringRegion() {
        guard let lat = Truck.mock.first?.clients?.first?.location?.first! else { return }
        guard let long = Truck.mock.first?.clients?.first?.location?.last! else { return }
        guard let clientID = Truck.mock.first?.clients?.first?.id else { return }
        
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: 10.0, identifier: clientID.uuidString)
        locationVM.startMonitoringRegions(regions: [region])
        
        clients = Truck.mock.first!.clients!
        
        
    }
    
    
}
