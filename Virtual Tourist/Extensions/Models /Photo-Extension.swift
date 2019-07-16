//
//  Photo-Extension.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Althobaiti on 12/11/1440 AH.
//  Copyright © 1440 Abdulrahman Althobaiti. All rights reserved.
//


import Foundation
import UIKit

extension Photo {
    
    func set(img: UIImage) {
        self.img = img.pngData()
    }
    
    func getImg() -> UIImage? {
        return (img == nil) ? nil : UIImage(data: img!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}
