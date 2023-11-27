//
//  TrackerApp.swift
//  Tracker
//
//  Created by Federico Lupotti on 24/10/23.
//

import SwiftUI
import BackgroundTasks

@main
struct TrackerApp: App {
    
    @StateObject var homeVM = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeVM)
        }
    }
}
