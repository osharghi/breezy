//
//  Profile.swift
//  breezy
//
//  Created by Omid Sharghi on 12/16/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import UIKit

class Profile: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var companyField: UITextField!
    
    @IBOutlet weak var employeeNumberField: UITextField!
    
    @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    var userInfo: Dictionary<String, String>?
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        let customFont = UIFont(name: "Gill Sans", size: 14.0)
        let rightNavButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "backButtonTapped")
        rightNavButton.setTitleTextAttributes([NSFontAttributeName:customFont!], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = rightNavButton
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        if let userInfo = self.userInfo
        {
            self.nameField.text = userInfo["email"]
            self.nameField.borderStyle = UITextBorderStyle.None
            
            self.titleField.text = userInfo["title"]
            self.companyField.text = userInfo["company"]
            self.zipField.text = userInfo["zipcode"]
            self.employeeNumberField.text = userInfo["employeeNumber"]
            self.descriptionField.text = userInfo["bizDesc"]
            self.emailField.text = userInfo["email"]
            self.passwordField.text = "password"
            self.confirmPasswordField.text = "password"
            
            self.descriptionField.delegate = self
            self.descriptionField.layer.borderWidth = 0.5
            self.descriptionField.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        
        
        
    }


}
