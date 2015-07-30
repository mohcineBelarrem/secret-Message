//
//  ViewController.swift
//  Secret message
//
//  Created by mohcine  on 7/29/15.
//  Copyright (c) 2015 mohcine . All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    
    var token : String = ""
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func login(sender: AnyObject) {
        
        
        self.loginRequest("http:/recruiting.api.fitle.com/user/token")
        
        self.view.endEditing(true)
        
        println("jetton: " + self.token)
        
    }
    
    @IBAction func register(sender: AnyObject) {
        
        self.createRequest("http:/recruiting.api.fitle.com/user/create")
        
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "loginSegue" {
            
            let mvc = segue.destinationViewController as! MessageViewController
            
            mvc.token = self.token
            mvc.email = self.emailField.text
            
        }
    }
    
    func loginRequest(url : String) {
        
        let myUrl = NSURL(string: url)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        // Compose a query string
        let postString = "email=\(emailField.text)&password=\(passwordField.text)"
        
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
                        
                        self.token = token
                        
                        self.performSegueWithIdentifier("loginSegue", sender: self)
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
    
    
    



func createRequest(url : String) {
    
    let myUrl = NSURL(string: url)
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL:myUrl!)
    request.HTTPMethod = "POST"
    
    // Compose a query string
    let postString = "email=\(emailField.text)&password=\(passwordField.text)"
    
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
                    
                   self.resultLabel.text = "account successfuly created"
                }
                    
                else {
                    
                    let errorString = (parseJSON["error"] as? String)!
                    
                     self.resultLabel.text = errorString
                    
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




}//end of class






// old request method
//
//func registerRequest(params : Dictionary<String, String>, url : String) {
//    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
//    var session = NSURLSession.sharedSession()
//    request.HTTPMethod = "POST"
//
//    var err: NSError?
//    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//        println("Response: \(response)")
//        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//        println("Body: \(strData)")
//        var err: NSError?
//        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
//
//        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
//        if(err != nil) {
//            println(err!.localizedDescription)
//            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("Error could not parse JSON: '\(jsonStr)'")
//        }
//        else {
//            // The JSONObjectWithData constructor didn't return an error. But, we should still
//            // check and make sure that json has a value using optional binding.
//            if let parseJSON = json {
//                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
//
//
//                if let token = parseJSON["token"] as? String {
//
//                    self.resultLabel.text = "account created Succesfuly"
//                    println("success")
//                }
//
//                else {
//
//                    self.resultLabel.text = parseJSON["error"] as? String
//                    println("account already existing")
//                }
//
//
//
//            }
//            else {
//                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
//                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                //println("Error could not parse JSON: \(jsonStr)")
//            }
//        }
//    })
//
//    task.resume()
//}
//
//
//
