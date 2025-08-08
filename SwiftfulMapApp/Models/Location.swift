//
//  Location.swift
//  SwiftfulMapApp
//
//  Created by Alvaro Ordonez on 6/9/25.
//

import Foundation
import MapKit // for CLLocationCoordinate2D below

struct Location: Identifiable, Equatable {
    
    //let id: String = UUID().uuidString
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    
    //computed property, id field is required when conforming to Identifiable
    //we use name and city because the combo of each will distinguish one location from another
    var id: String {
        //name = "Colosseum"
        //cityName = "Rome:
        //id = "ColosseumRome"
        name + cityName
    }
    
    //Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    
}


