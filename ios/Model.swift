//
//  Model.swift
//  ios
//
//  Created by Jorge Izquierdo on 24/01/15.
//  Copyright (c) 2015 izqui. All rights reserved.
//

import Foundation

class Item {
    
    let name: String
    let by: String
    let type: String
    let price: Double
    let image: String
    
    init(name: String, by:String, type: String, price: Double, image: String) {
        self.name = name
        self.type = type
        self.price = price
        self.image = image
        self.by = by
    }
}