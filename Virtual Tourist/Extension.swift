//
//  File.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Althobaiti on 13/11/1440 AH.
//  Copyright © 1440 Abdulrahman Althobaiti. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
