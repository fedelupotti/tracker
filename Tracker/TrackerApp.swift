//
//  TrackerApp.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import SwiftUI

@main
struct TrackerApp: App {
    
    @StateObject var homeVM = HomeViewModel(locationViewModel: LocationHandlerMVVM())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeVM)
        }
    }
}
