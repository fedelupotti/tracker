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
        
    var body: some View {
        List(homeVM.clients) { client in
            
            VStack {

                HStack {
                    Text(client.name ?? "")
                    Spacer()
                    Image(systemName: client.isInGeofence ? "lock.open" : "lock")
                        .animation(.easeInOut, value: client.isInGeofence)
                    
                }
                
                .onTapGesture {
                    presentMapView(withClient: client)
                }
                .onChange(of: client.isInGeofence) {
                    if client.isInGeofence == true {
                        presentMapView(withClient: client)
                    }
                }
                
                ProgressAnimation(status: client.status)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
            }
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
