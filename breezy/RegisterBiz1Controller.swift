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
    
    func checkValue(input: String?) -> String? {
        if let input = input {
            return input == "" ? nil : input
            // if its "" return nil, otherwise return input
        }
        return nil
    }
    
    func isValidString(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        // . is equla to any character
        // * any length 0 through whatever
        // ^ none of the folloiwng
        let stringRegEx = ".*[^A-Za-z0-9].*"
        
        let stringTest = NSPredicate(format:"SELF MATCHES %@", stringRegEx)
        
        return stringTest.evaluateWithObject(testStr)
    }
    
    func convertIntToString(input: Int?) -> String? {
        if let input = input {
            let newInput = String(input)
            return newInput == "" ? nil : newInput
            // if its "" return nil, otherwise return input
        }
        return nil
    }
    
    func removeSpaces(input: String?) -> String? {
        
        if let input = input {
            let newInput = input.stringByReplacingOccurrencesOfString(" ", withString: "")
            print("\(newInput)")
            return newInput == "" ? nil: newInput
        }
        return nil
    }
    
    func inputValidation() -> [String:String]?
    {
        var userInfo: [String:String]?
        if let firstName = checkValue(firstNameField.text)
        {
            if let title = checkValue(titleField.text)
            {
                if let zipCode = checkValue(zipTextField.text)
                {
                    if let employeeNumber = checkValue(employeeNumberTextField.text)
                    {
                        if let skills = removeSpaces(skillsTextField.text)
                        {
                            if let bizDesc = checkValue(bizDescriptionTextView.text)
                            {
                                userInfo = ["firstName": firstName, "title": title, "bizDesc":bizDesc, "employeeNumber": employeeNumber, "zipCode": zipCode, "skills": skills]
                                return userInfo!
                                
                            }
                        }
                    }
                }

            }
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
    
    
    
//    @IBAction func nextPressed(sender: AnyObject) {
//        
//        if let firstName = checkValue(firstNameField.text)
//        {
//            if let title = checkValue(titleField.text)
//            {
//                if let zipAddress = checkValue(zipTextField.text)
//                {
//                    if let employeeNumber = checkValue(employeeNumberTextField.text)
//                    {
//                        if let skills = removeSpaces(skillsTextField.text)
//                        {
//                            if let bizDesc = checkValue(bizDescriptionTextView.text)
//                            {
//                                let register2 = RegisterRequest2(firstName: firstName, title: title, zipCode: zipAddress, employeeNumber: employeeNumber, bizDesc: bizDesc, skills: skills) {
//                                    result in
//                                    
//                                    if case .Success (let user) = result {
//                                        self.userInfo = user.userInfo
//                                        print("EMAIL Is \(self.userInfo!["email"])")
//                                        print("SUCCESS")
//                                        dispatch_async(dispatch_get_main_queue()) {
//                                            self.performSegueWithIdentifier("profile", sender: nil)
//                                        }
//                                    }
//                                    else if case .Error(let reason) = result {
//                                        print(reason.message)
//                                    }
//                                }
//                                
//                                NetworkClient.instance.process(register2)
//                                
//                            }
//                        }
//                    }
//                }
//            }
//            
//        }
//        
//    }
    
    
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
