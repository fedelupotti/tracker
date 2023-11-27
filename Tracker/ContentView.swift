//
//  ContentView.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State private var isMapViewPresented = false
    
    @State private var client: Client? = nil
    
    @State private var downloadAmount = 0.0
    
    @State private var showProgressView = false
    
    private func presentMapView(withClient: Client) {
        client = withClient
        isMapViewPresented = true
    }
    
    private func colorForCoordenates() -> Color {
        if homeVM.locationSelected == homeVM.locations[0] {
            return .red
        }
        else if homeVM.locationSelected == homeVM.locations[1] {
            return .blue
        }
        else if homeVM.locationSelected == homeVM.locations[2] {
            return .green
        }
        else if homeVM.locationSelected == homeVM.locations[3] {
            return .orange
        }
        return .black
    }
        
    var body: some View {
        
        List(homeVM.clients.first?.distance ?? [], id: \.self) { distance in
            Text("\(distance) meters")
        }
        .listRowSpacing(15)
        
        
        .sheet(item: $client) { client in
            MapView(clientSelected: client) { onCommitClient in
                homeVM.changeToDeliveredStatus(client: onCommitClient)
            }
            .presentationDetents(
                client.isInGeofence ? [.large, .medium] : [.medium, .large]
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State static var homeVM = HomeViewModel()
    
    static var previews: some View {
        ContentView()
            .environmentObject(homeVM)
    }
}
