//
//  File.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Althobaiti on 13/11/1440 AH.
//  Copyright © 1440 Abdulrahman Althobaiti. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension Pin {
    
    var coordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        } get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
    func compare(to coordinate: CLLocationCoordinate2D) -> Bool {
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
    }
}
