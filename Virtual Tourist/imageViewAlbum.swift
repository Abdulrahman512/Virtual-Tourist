//
//  File.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Althobaiti on 11/11/1440 AH.
//  Copyright © 1440 Abdulrahman Althobaiti. All rights reserved.
//

import Foundation
import UIKit


class imageViewAlbum : UIImageView {
    var _photo: Photo?
    let imageCache = NSCache<AnyObject, AnyObject>()
    func loadFrom(photo: Photo) {
     
        if _photo != nil {
            guard _photo?.creationDate != photo.creationDate else {return}
        }
        
        self.image = nil
        _photo = photo
        
        if let img = _photo?.getImg() {
            self.image = img
            return
        }
        
        ai.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            guard let imgData = try? Data(contentsOf: photo.imgURL!) else {return}
            
            DispatchQueue.main.async {
                self.ai.stopAnimating()
                photo.img = imgData
                self.image = photo.getImg()
                try? DataController.shared.viewContext.save()
            }
        }
    }
    
    lazy var ai: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.color = .black
        ai.hidesWhenStopped = true
        
        addSubview(ai)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ai.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return ai
        
    }()
    
}
