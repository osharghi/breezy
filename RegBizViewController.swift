//
//  RegBizViewController.swift
//  breezy
//
//  Created by Omid Sharghi on 11/24/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import UIKit

class RegBizViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    @IBOutlet weak var businessField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func nextPressed(sender: AnyObject) {
        
        if let userInfo: [String:String] = inputValidation()
        {
            print("\(userInfo)")
            let register = RegisterRequest1a(userDict: userInfo){
                result in
                
                if case . Success = result {
                    //                print(user.userID)
                    print("Success")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("next1", sender: nil)
                    }
                }
                    //            else if case . Error(let reason) = result {
                else if case . Error = result {
                    print("error")
                    
                }
            }
            NetworkClient.instance.process(register)
        }
    }
    
    func inputValidation() -> [String:String]?
    {
        var userInfo: [String:String]?
        
        do{
            if let business = try isValidString(businessField.text)
            {
                do {
                    if let email = try isValidEmail1(emailField.text)
                    {
                        do {
                            if try passwordsMatch1(passwordField.text, input2: password2Field.text)
                            {
                                do {
                                    if let password = try isValidPassword1(passwordField.text)
                                    {
                                        
                                        print("\(business)")
                                        userInfo = ["email": email, "password": password, "business": business]
                                        return userInfo
                                    }
                                }
                                catch let error
                                {
                                    //Password validation error
                                    print(error)
                                    errorLabel.text = "Invalid Password."
                                }
                                
                            }
                        }
                        catch let error
                        {
                            //Password match error
                            print(error)
                            errorLabel.text = "Passwords do not match."
                        }
                    }
                }
                catch let error
                {
                    //Email Error
                    print(error)
                    errorLabel.text = "Please enter a valid email"
                }
            }
        }
        catch let error
        {
            //business name error
            print(error)
            errorLabel.text = "Please enter a business name."
        }
        
        return nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
