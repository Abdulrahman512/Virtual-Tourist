//
//  UdacityAPI.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Althobaiti on 11/11/1440 AH.
//  Copyright © 1440 Abdulrahman Althobaiti. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UdacityAPI {
    
    static func postSessionForLogin(with email: String, password: String, completion: @escaping ([String:Any]?, String? , Error?) -> ())
    {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil,nil,error)
                return
            }
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {return}
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                if data != nil {
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range)
                    
                    
                    if let dataResult = try! JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]{
                        completion(dataResult,nil,nil)
                    } else {
                        completion(nil,nil, error?.localizedDescription as? Error)
                    }
                    
                }
            } else {
                switch httpStatusCode {
                case 400:
                    completion(nil, "Bad Request", nil)
                    return
                case 401:
                    completion(nil, "Invalid Credentials", nil)
                    return
                case 403:
                    completion(nil, "Unauthorized", nil)
                    return
                case 405:
                    completion(nil, "HttpMethod Not Allowed", nil)
                    return
                case 410:
                    completion(nil, "URL Changed", nil)
                    return
                case 500:
                    completion(nil, "Server Error", nil)
                    return
                default:
                    completion(nil, "", error?.localizedDescription as? Error)
                }
            }
        }
        task.resume()
    }
    
    static func deleteSession(completion: @escaping (Error?) -> ())
    {
        var request = URLRequest(url: URL(string : "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        if let sharedStorageCookies = HTTPCookieStorage.shared.cookies {
            for cookie in sharedStorageCookies {
                if cookie.name == "XSRF-TOKEN" {
                    xsrfCookie = cookie
                }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    let range = (5..<data!.count)
                    let newData = data?.subdata(in: range)
                    print(String(data: newData!, encoding: .utf8)!)
                    completion(nil)
                } else {
                    completion(error)
                    return
                }
            }
            task.resume()
        }
    }
    
}
