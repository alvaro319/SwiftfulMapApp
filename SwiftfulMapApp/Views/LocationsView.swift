//
//  LocationsView.swift
//  SwiftfulMapApp
//
//  Created by Alvaro Ordonez on 6/9/25.
//

import SwiftUI
import MapKit


struct LocationsView: View {
    
    //moved to SwiftfulMapAppApp
    /*
    //@StateObject private var viewModel = LocationsViewModel()
     */
    
    @EnvironmentObject private var viewModel: LocationsViewModel
    let maxWidthForIpad: CGFloat = 700
    
    //moved inside viewModel
    /*
//    @State private var mapRegion =
//        MapCameraPosition.region(
//            MKCoordinateRegion(
//                //coordinates will be placed in center of the map
//                center: CLLocationCoordinate2DMake(41.8902, 12.4922),
//                //how zoomed in/out you want to be
//                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            )
//        )
     */
    
    var body: some View {
        ZStack {
            mapLayer
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                //button at the top showing the location and cityName
                //along with the listView of the other locations
                header //see extension below
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                Spacer()
                
                //shows location preview at the bottom with
                //Learn More and Next button
                locationsPreviewStack
            }
        }
        //when Learn More button pressed this, viewModel.sheetLocation is set to the current location, therefore, sheet pops up due to sheetLocation being a binding variable
        .sheet(item: $viewModel.sheetLocation, onDismiss: nil) { location in
            if #available(iOS 18.0, *) {
                LocationDetailView(location: location)
                    .presentationSizing(.page)
            } else {
                // Fallback on earlier versions
            }
//                .presentationDetents([.large])
//                .presentationDragIndicator(.visible)
                
        }
        
    }
}

extension LocationsView {
    
    private var mapLayer: some View {
        
        //Map(position: $viewModel.mapRegion)
                    
        Map(coordinateRegion: $viewModel.mapRegion,
            annotationItems: viewModel.locations) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(viewModel.currentMapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        viewModel.listRowPressUpdateNewLocation(location: location)
                    }
            }
        }
    }
    
    //This has syntax of private var variableName: some View
    //no parameter is passed in here.
    private var header: some View {
        VStack {
            
            Button {
                //when button is clicked, showLocationList is toggled
                viewModel.toggleLocationsList()
            } label: {
                Text(viewModel.currentMapLocation.name + ", " + viewModel.currentMapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    //see Equatable protocol added to Location struct
                    .animation(.none, value: viewModel.currentMapLocation)
                    //.background(Color.red)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding()
                            .rotationEffect(
                                Angle(degrees: viewModel.showLocationList ? 180 : 0)
                            )
                    }
            }
            
            if viewModel.showLocationList {
                LocationsListView()
            }
            
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y:15)
    }
    
    private var locationsPreviewStack: some View {
        ZStack {
            
            ForEach(viewModel.locations) {location in
                
                if (viewModel.currentMapLocation == location) {
                    LocationPreviewView(location: location)
                        .shadow(
                            color: Color.black.opacity(0.3),
                            radius: 20
                        )
                        .padding()
                        //uncomment the .backgrounds below to see why we added two frames
                        //See video #8 for some context
                        .frame(maxWidth: maxWidthForIpad)
                        //.background(Color.orange)
                        .frame(maxWidth: .infinity)
                        //.background(Color.green)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading))
                        )
                }//end if
            }//end ForEach
        }//end ZStack
    }//end locationsPreviewStack
    
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
}
