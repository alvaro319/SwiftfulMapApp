//
//  LocationsViewModel.swift
//  SwiftfulMapApp
//
//  Created by Alvaro Ordonez on 6/9/25.
//

import Foundation
//import these:
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    
    //All loaded locations
    @Published var locations: [Location]
    
    //Nick called this mapLocation in hit tutorial video
    @Published var currentMapLocation: Location {
        //whenever this currentMapLocation has been updated to another location,
        //we also want to update the MapRegion within currentMapLocation
        didSet {
            updateMapRegion(location: currentMapLocation)
        }
    }
    
    //initialize to blank location
    //@Published var mapRegion: MapCameraPosition//MKCoordinateRegion()
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    //determines how zoomed in user is to the map
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //show list of locations
    @Published var showLocationList: Bool = false
    
    //Show location detail via sheet
    //if we were to default it to a location then it would show a location,
    //therefore, need to set it to nil so we define it as a Location optional
    //if not nil, sheet will pop up
    @Published var sheetLocation: Location? = nil
    
    init() {
        //get all locations
        let locations = LocationsDataService.locations
        self.locations = locations
        
        //get the first location
        self.currentMapLocation = locations.first!//shouldn't do this but since hardcoded....
        
        //initialize to blank map
        //self.mapRegion = .region(MKCoordinateRegion())
        //self.mapRegion = MKCoordinateRegion()
        
        //mapRegion is the publishing var used to update the map shown on the LocationsView
        self.updateMapRegion(location: currentMapLocation)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            self.mapRegion = MKCoordinateRegion(
                                //coordinates will be placed in center of the map
                                center: currentMapLocation.coordinates,
                                //how zoomed in/out you want to be
                                span: mapSpan
                            )
           
//            self.mapRegion = MapCameraPosition.region(
//                MKCoordinateRegion(
//                    //coordinates will be placed in center of the map
//                    center: currentMapLocation.coordinates,
//                    //how zoomed in/out you want to be
//                    span: mapSpan
//                )
//            )
        }//end withAnimation
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            //showLocationList = !showLocationList
            showLocationList.toggle()
        }
    }
    
    //called showNextLocation in playlist video
    func listRowPressUpdateNewLocation(location: Location) {
        withAnimation(.easeInOut) {
            //update the current map location with the selected listRow location
            self.currentMapLocation = location
            showLocationList = false//make the list row disappear once user selects row
        }
    }
    
    func nextButtonPressed() {
        //Get current map location index
        let currentIndex = locations.firstIndex { location in
            //returns the index when a match is found
            return location == currentMapLocation
        }
        
        //equivalent:
        //let currIndex = locations.firstIndex(where: {$0 == currentMapLocation})
        
        //currentIndex above can be nil, let's check to make sure
        guard let currIndex = currentIndex  else {
            return
        }
        
        var nextIndex: Int = 0
        //let lastLocationsIndex = locations.indices.endIndex - 1
        
        //if currIndex is the last index, restart first index, else
        //move to the next index.
        if currIndex == (locations.count - 1) {
            nextIndex = 0
        } else {
            nextIndex = currIndex + 1
        }
        
        //make sure a location exists as the nextIndex, if so,
        //update to the new location
        if locations.indices.contains(nextIndex)
        {
            let nextLocation = locations[nextIndex]
            //this will update the current location with the next location
            listRowPressUpdateNewLocation(location: nextLocation)
        }
        
    }
}
