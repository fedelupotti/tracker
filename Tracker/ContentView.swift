//
//  ContentView.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        
        List {
            ForEach(homeVM.clients) { client in
                VStack {
                    Text(client.name ?? "")
                }
            }
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
