//
//  Location.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/23/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//  FUNCTION: Sets up the location struct for keeping location

import Foundation
import CoreLocation

struct Location {
    let latitude: Double
    let longitude: Double
    let locality: String?
    let name: String?
}
