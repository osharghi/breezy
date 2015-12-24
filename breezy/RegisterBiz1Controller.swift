//
//  RegisterBiz1Controller.swift
//  breezy
//
//  Created by Allahe Sharghi on 11/11/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import UIKit

class RegisterBiz1Controller: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!

    @IBOutlet weak var titleField: UITextField!
    
    
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var employeeNumberTextField: UITextField!
    
    @IBOutlet weak var skillsTextField: UITextField!
    
    @IBOutlet weak var bizDescriptionTextView: UITextView!
    
    var userInfo: Dictionary<String, String>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        bizDescriptionTextView.textColor = UIColor.lightGrayColor()
        bizDescriptionTextView.text = "Write a paragraph describing the history of your business, your mission, and what you're all about."
        bizDescriptionTextView.delegate = self
        bizDescriptionTextView.layer.borderWidth = 0.5
        bizDescriptionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inputValidation() -> [String:String]?
    {
        var userInfo: [String:String]?
        do
        {
            if let firstName = try validateName(firstNameField.text)
            {
                do
                {
                    if let title = try validateTitle(titleField.text)
                    {
                        do
                        {
                            if let zipCode = try validateZip(zipTextField.text)
                            {
                                do
                                {
                                    if let employeeNumber = try validateEmployeeNumber(employeeNumberTextField.text)
                                    {
                                        do
                                        {
                                            if let skills = try validateSkills(skillsTextField.text)
                                            {
                                                do
                                                {
                                                    if let bizDesc = try validateBizDesc(bizDescriptionTextView.text)
                                                    {
                                                        userInfo = ["firstName": firstName, "title": title, "bizDesc":bizDesc, "employeeNumber": employeeNumber, "zipCode": zipCode, "skills": skills]
                                                        return userInfo!
                                                        
                                                    }
                                                }
                                                catch let error
                                                {
                                                    //BizDesc error
                                                    print(error)
                                                }
                                            }
                                        }
                                        catch let error
                                        {
                                            //Skills error
                                            print(error)
                                        }
                                    }
                                }
                                catch let error
                                {
                                    //Employee # error
                                    print(error)
                                }
                            }
                        }
                        catch let error
                        {
                            //Zip error
                            print(error)
                        }
                    }
                }
                catch let error
                {
                    //Title error
                    print(error)
                }
            }
        }
        catch let error
        {
            //Name Error
            print(error)
        }
        
        return nil
    }
    

    @IBAction func nextPressed(sender: AnyObject) {
        
        if let userInfo: [String:String] = inputValidation()
        {
            print("\(userInfo)")
            let register = RegisterRequest2a(userInfo:userInfo){
                result in
                
                if case . Success (let user) = result {
                    print("Success")
                    self.userInfo = user.userInfo
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("profile", sender: nil)
                    }
                }
                else if case . Error = result {
                    print("error")
                }
            }
            NetworkClient.instance.process(register)
        }
    }
    


    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView.textColor == UIColor.lightGrayColor()
        {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
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
