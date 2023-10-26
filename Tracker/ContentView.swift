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
    
    @State var client: Client = Client(name: "", packages: nil, location: nil)
    
    private func presentMapView(withClient: Client) {
        client = withClient
        isMapViewPresented = true
    }
    
    var body: some View {
        
        List(homeVM.clients) { client in
            
            VStack {
                Text(client.name ?? "")
            }
            
            .onTapGesture {
                presentMapView(withClient: client)
            }
        }
        .sheet(isPresented: $isMapViewPresented) {
            MapView(client: self.client)
                .presentationDetents([.medium, .large])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @StateObject static var homeVM = HomeViewModel(locationViewModel: LocationHandlerMVVM())
    
    static var previews: some View {
        ContentView()
            .environmentObject(homeVM)
    }
}
