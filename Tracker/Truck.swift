//
//  Truck.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import Foundation

struct Truck: Identifiable {
    let id = UUID()
    let clients: [Client]?
    let location: [Double]?
    
}

struct Package: Identifiable {
    let id = UUID()
    let description: String?
    let trackDelivered: Bool?
    let clientReceived: Bool?
}

struct Client: Identifiable {
    let id = UUID()
    let name: String?
    let packages: [Package]?
    let location: [Double]?
}
