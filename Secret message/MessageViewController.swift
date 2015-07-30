//
//  MessageViewController.swift
//  Secret message
//
//  Created by mohcine  on 7/29/15.
//  Copyright (c) 2015 mohcine . All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var tokenLabel: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    
    
    var token : String!
    
    var email : String!
    
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tokenLabel.numberOfLines = 0
        self.messageLabel.numberOfLines = 0
        self.emailLabel.numberOfLines = 0
        
        self.tokenLabel.text = "token: \r\n"+self.token
        
        self.emailLabel.text = "email : " + self.email
        
        self.messageRequest("http:/recruiting.api.fitle.com/secret")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func messageRequest(urlString : String) {
     
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //let userPasswordString = "username@gmail.com:password"
        
        let userPasswordString = "\(self.token):\(self.password) "
       
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)
        
        let authString = "Basic \(base64EncodedCredential)"
        
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        
        let session = NSURLSession(configuration: config)
        
        var running = false
        
        let url = NSURL(string:urlString)
        
        let task = session.dataTaskWithURL(url!) {
            (let data, let response, let error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                println(responseString)
                
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    
                    
                    if let message = parseJSON["message"] as? String {
                        
                        self.messageLabel.text = message
                        
                    }
                        
                    else {
                        
                        let errorString = (parseJSON["error"] as? String)!
                        
                        self.messageLabel.text = errorString
                        
                    }
                }
                
                
            }
            running = false
        }
        
        running = true
        task.resume()
        
        while running {
            println("waiting...")
            sleep(1)
        }
        
    }
    

}
