//
//  ApiCall.swift
//  RestfulApiCalling
//
//  Created by Lalit Kant on 2/15/17.
//  Copyright © 2017 Lalit Kant. All rights reserved.
//

import UIKit

class ApiCall: NSObject {
    
    // MARK: Call any service method
    
     /** You can cerate your own methods to call from any other class. You can change parameters as well. **/
    @objc func methodTocallservice(info: String ,completion: @escaping (_ result: [String:AnyObject]) -> Void) {
        
        let urlString = String.init(format: "%@", WEB_URL_STRING)
        var data = Data()
        do{
            let finalDict  = NSMutableDictionary()
            
            // In below code you can change Key/value as per response you get from server

            finalDict.setValue("", forKey: "Key1")
            
            finalDict.setValue("", forKey: "Value1")
            
            // Converting Dictionary to String
            
            let newdata = try JSONSerialization.data(withJSONObject:finalDict , options: [])
            let newdataString = String(data: newdata, encoding: String.Encoding.utf8)!
            
            data = newdataString.data(using: .utf8)!
            
        }
        catch let error as NSError {
            print(error)
        }
        
        self.callService(urlString: urlString, httpMethod: "POST", data: data) { (response) in
            
            // In below code you can change Key as per response you get from server
            let mainData = response["meta"] as! NSDictionary
            var code = Int()
            
            // In below code you can change Key as per response you get from server

            code = mainData["code"]  as! Int
            if code != 200
            {
                var errorResponse = [String : AnyObject]()
                errorResponse["Error"] = "Issue" as AnyObject?
                completion(errorResponse)
            }
            else
            {
                completion(response)
            }
        }
    }

    
    // MARK: Call all web service method
    
    @objc func callService ( urlString : String, httpMethod: String , data: Data , completion: @escaping (_ result: [String:AnyObject]) -> Void)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        // Set the method to POST
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the POST/put body for the request
        request.httpBody = data
        request.setValue(String.init(format: "%i", (data.count)), forHTTPHeaderField: "Content-Length")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if data == nil
            {
                var errorResponse = [String : AnyObject]()
                errorResponse["Error"] = "Issue" as AnyObject?
                completion(errorResponse)
            }
            else
            {
                if  let utf8Text = String(data: data! , encoding: .utf8) {
                    completion(self.convertStringToDictionary(text: utf8Text)! as! [String : AnyObject])
                }
                else
                {
                    var errorResponse = [String : AnyObject]()
                    errorResponse["Error"] = "Issue" as AnyObject?
                    completion(errorResponse)
                }
            }
        })
        task.resume()
    }

    /*
     * Below here are all methods the classes use to communicate with webservice
     */
    
    @objc func convertStringToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary as! [String : AnyObject]? as NSDictionary?
            } catch let error as NSError {
                var errorResponse = [String : AnyObject]()
                errorResponse["Error"] = "Issue" as AnyObject?
                print(error)
                return errorResponse as NSDictionary?
            }
        }
        return nil
    }
    
    
}
