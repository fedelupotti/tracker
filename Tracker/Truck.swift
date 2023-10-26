//
//  Truck.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import Foundation
import CoreLocation

struct Truck: Identifiable {
    let id = UUID()
    let clients: [Client]?
    
//    let location: CLLocation?
}

struct Package: Identifiable {
    let id = UUID()
    let description: String?
    
    var trackDelivered: Bool = false
    var clientReceived: Bool = false
    var isBeingDelivering: Bool = false
}

struct Client: Identifiable {
    let id = UUID()
    let name: String?
    let packages: [Package]?
    let location: [Double]?
    
    var coordinate: CLLocationCoordinate2D {
        guard let lat = location?.first, let long = location?.last else { return CLLocationCoordinate2D() }
        
        let latDegrees = CLLocationDegrees(floatLiteral: lat)
        let longDegrees = CLLocationDegrees(floatLiteral: long)
        let cordinate = CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
        return cordinate
    }
}

extension Truck {
    static let mock = [
        Truck(clients: [
            Client(name: "Juan", packages: [
                Package(description: "Caja chica")],
                   location: [-31.5672922949216, -60.6409563788899])
        ])
    ]
}
