//
//  Service.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 18/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit
import SystemConfiguration

class Service {
    let apiKey = "L6ywXGcACUQmQslp8s4GpCZgTY45-bg1nHt8k_in"
    let lookupUrl = "https://www.buycott.com/api/v4/products/lookup"
    
    // setup urlresuest
    func urlRequest(url : URL, method: String, parameters : [String:Any]?, timeoutInterval : Double, headers: [String:String]) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeoutInterval
        // adding the header
        for header in headers {
            request.setValue(header.key, forHTTPHeaderField: header.value)
        }
        // adding body
        if parameters != nil {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            } catch {
                return nil
            }
        }
        return request
    }
    
    // async urlsession
    func urlSession(request : URLRequest, completion : @escaping(Data?) ->Void) {
        URLSession.shared.dataTask(with: request){
            (data, response, err) in
            
            if response == nil {
                completion(nil)
            } else {
                print(" response : ",response!)
            }
            if data != nil {
                completion(data)
            }
            
            if err != nil {
                print(" urlSession err : ", err.debugDescription)
                completion(nil)
            }
        }.resume()
    }
    
    func LookupBarcode(barcode : String, completion : @escaping (Data?) -> Void){
        let url = URL(string : self.lookupUrl + "?barcode=" + barcode + "&access_token=" + self.apiKey)
        let request = urlRequest(url: url!, method: "GET", parameters: nil, timeoutInterval: 10, headers: ["Content-Type":"application/json"])
        urlSession(request: request!) {
            (data) in
            if data != nil {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
}
