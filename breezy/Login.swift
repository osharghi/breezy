//
//  Login.swift
//  breezy
//
//  Created by Omid Sharghi on 12/17/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    var userInfo: Dictionary<String,String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customFont = UIFont(name: "Gill Sans", size: 14.0)
        let leftNavButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "backButtonTapped")
        leftNavButton.setTitleTextAttributes([NSFontAttributeName:customFont!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = leftNavButton
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Do any additional setup after loading the view.
    }
    
    func backButtonTapped() {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func checkValue(input: String?) -> String? {
        if let input = input {
            return input == "" ? nil : input
            // if its "" return nil, otherwise return input
        }
        return nil
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        if let email = checkValue(emailField.text)
        {
            if let password = checkValue(passwordField.text)
            {
                print("Email and password \(email) \(password)")
                let login = loginRequest(email: email, password: password)
                    {
                    result in
                    
                    if case .Success (let user) = result
                    {
                        self.userInfo = user.userInfo
                        print("EMAIL Is \(self.userInfo!["email"])")
                        print("SUCCESS")
                        dispatch_async(dispatch_get_main_queue())
                        {
                            self.performSegueWithIdentifier("login", sender: nil)
                        }
                    }
                    else if case .Error(let reason) = result {
                        print(reason.message)
                    }
                }
                NetworkClient.instance.process(login)
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if let results = self.userInfo
        {
            let destinationVC = segue.destinationViewController as! Profile
            destinationVC.userInfo = results
            
        }
        
    }
    
}


