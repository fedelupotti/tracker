//
//  MapView.swift
//  Tracker
//
//  Created by Federico Lupotti on 25/10/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject private var homeVM: HomeViewModel
    
    let client: Client
    
    var body: some View {
        Map() {
            Marker(client.name ?? "", systemImage: "box.truck", coordinate: client.coordinate)
        }
    }
}


struct Container: View {
    @State var client = Truck.mock.first?.clients?.first!
    var body: some View {
        MapView(client: client!)
    }
}


#Preview {
    Container()
}
