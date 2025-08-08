//
//  LocationDetailView.swift
//  SwiftfulMapApp
//
//  Created by Alvaro Ordonez on 6/10/25.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var viewModel: LocationsViewModel
    //@Environment(\.presentationMode) var presentationMode
    let location: Location
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 20, x: 0, y: 10
                    )
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                //.background(Color.red)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

extension LocationDetailView {
    
    private var imageSection: some View {
        TabView {
            //strings are hashable so use \.self
            //ForEach(location.imageNames, id: \.self) { imageName in
                //Image(imageName)
            //}
            
            //Equivalent:
            ForEach(location.imageNames, id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
                //in video #8, around 9:15 mark, image is extended beyond sheet width when swiping through the tab view images.
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundStyle(.secondary)
                //old way:
                //.foregroundColor(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.description)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let url = URL(string: location.link) {
                Link("Read more on Wikipedia", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
        }
    }
    
    private var mapLayer: some View {
        Map(
            coordinateRegion: .constant(
                MKCoordinateRegion(
                    //center of location coordinates
                    center: location.coordinates,
                    //how zoomed in/out you are on map
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
            //adds a pin of the single location
            annotationItems: [location]) { location in
                MapAnnotation(coordinate: location.coordinates) {
                    LocationMapAnnotationView()
                        .shadow(radius: 10)
                }
            }
            //disables gestures
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
    }
    
    private var backButton: some View {
        Button {
            //presentationMode.wrappedValue.dismiss()
            //by setting this bound var(bound to the sheet that pops this window up modally) to nil, it dimisses this sheet. Recall when sheetLocation is nil, sheet is not shown. When set to a location it pops up.
            viewModel.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundStyle(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
        .environmentObject(LocationsViewModel())
}
