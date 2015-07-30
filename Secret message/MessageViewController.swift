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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tokenLabel.numberOfLines = 0
        self.tokenLabel.text = "token: \r\n"+self.token
        
        self.emailLabel.text = "email : " + self.email
        
        //self.messageRequest("http:/recruiting.api.fitle.com/secret")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func messageRequest(url : String) {
        
        let myUrl = NSURL(string: url)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        // Compose a query string
        let postString = "token=\(self.token)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    
                    
                    if let token = parseJSON["token"] as? String {
                        
                    }
                        
                    else {
                        
                        let errorString = (parseJSON["error"] as? String)!
                        
                        println(errorString)
                        
                    }
                    
                    
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    //println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        
        
        task.resume()
        
    }

    
    

}
