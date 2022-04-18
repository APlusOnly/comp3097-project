//
//  Restaurant.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-07.
//

import Foundation

class Restaurant {
    var name: String
    var address: String
    var cuisine: String
    var description: String
    var phonenumber: String
    var rating: Double
    var tags: [String]
    
    init(name: String, address: String, cuisine: String, description: String, phonenumber: String, rating: Double, tags: [String]) {
        self.name = name
        self.address = address
        self.cuisine = cuisine
        self.description = description
        self.phonenumber = phonenumber
        self.rating = rating
        self.tags = tags
    }
}
