//
//  SwiftfulMapAppApp.swift
//  SwiftfulMapApp
//
//  Created by Alvaro Ordonez on 6/9/25.
//

import SwiftUI

@main
struct SwiftfulMapAppApp: App {
    
    @StateObject private var viewModel = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            
            //anything in the LocationsView() or a child of this view will have reference to
            //the environment object
            LocationsView()
                .environmentObject(viewModel)
        }
    }
}
