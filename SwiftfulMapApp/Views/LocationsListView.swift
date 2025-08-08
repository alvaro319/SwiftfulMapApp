//
//  LocationsListView.swift
//  SwiftfulMapApp
//
//  Created by Alvaro Ordonez on 6/9/25.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var viewModel: LocationsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.locations) { location in
                
                Button {
                    viewModel.listRowPressUpdateNewLocation(location: location)
                } label: {
                    //using an extension and need to pass in a location so we call a function that returns a View
                    listRowView(location: location)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

extension LocationsListView {
    
    private func listRowView(location: Location) -> some View {
        HStack {
            //show the first image of each location
            if let imageName =
                location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .cornerRadius(10)
            }
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                Text(location.cityName)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            //.background(Color.red)//to check width of row
        }
    }
}

#Preview {
    LocationsListView()
        .environmentObject(LocationsViewModel())
}
