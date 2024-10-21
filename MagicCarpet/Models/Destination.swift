//
//  Destination.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import Foundation

struct Destination: Identifiable, Decodable {
    let id: Int
    let city: String
    let state: String
    let country: String
    let imgURL: String
}

struct DestinationResponse: Decodable {
    let request: [Destination]
}

struct MockData {
    
    static let destination = [sampleDestination, sampleDestination, sampleDestination]
    
    static let sampleDestination = Destination(id: 0, city: "San Francisco", state: "California", country: "United States", imgURL: "https://upload.wikimedia.org/wikipedia/commons/7/74/San_Francisco_Skyline_-_Illustration.jpg")
    
    static let howTo = ["Must-see Attractions", "Great Food", "Hidden Gems", "Nightlife Tours", "Art Museums", "Shopping", "Iconic Landmarks"]
}
