//
//  LocationMapAnnotationView.swift
//  SwiftfulMapApp
//
//  Created by Alvaro Ordonez on 6/10/25.
//

import SwiftUI

struct LocationMapAnnotationView: View {
    
    let accentColor = Color("AccentColor")
    
    var body: some View {
        VStack {
            Image(systemName: "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(accentColor)
                .cornerRadius(36)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(accentColor)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -10)//pushes it up 3
                //by adding padding, we ensure that the arrow doesn't cover the location on the map, instead, pointy part will directly point to location.
                .padding(.bottom, 40)

        }
        //.background(Color.blue)
    }
}

#Preview {
    ZStack {
        Color.black
        LocationMapAnnotationView()
    }
    
}
