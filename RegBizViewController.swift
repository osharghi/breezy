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
    
    enum Reason: ErrorType {
        
        case InvalidEmail
        case InvalidPassword
        case InvalidPasswordMatch
        case InvalidBusiness
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func validateUsername(input: String?) -> String? {
        if let input = input {
            if input.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 10 {
                return nil
            }
            return input
        }
        return nil
    }
    
    func isValidEmail(testStr:String) -> Bool {
//        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
//         let emailRegEx = "^[.]+@[.]+\\.[A-Za-z]{2}[A-Za-z]*"

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    func isValidString(input: String?) throws -> String? {
        if let input = input {
            if input != ""
            {
                return input
//            return input == "" ? nil : input
            // if its "" return nil, otherwise return input
            }
            else {
                throw Reason.InvalidBusiness
            }
        }
        return nil
    }
    
    func isValidEmail1(input:String?) throws-> String? {
        if let input = input{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if (emailTest.evaluateWithObject(input))
            {
                return input
            }
            else
            {
                throw Reason.InvalidEmail
            }
        }
        return nil
    }
    
    func isValidPassword(testStr:String) -> Bool {
        let passwordRegEx = ".{5,32}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(testStr)
    }
    
    func isValidPassword1(input:String?) throws -> String? {
        if let input = input
        {
            let passwordRegEx = ".{5,32}"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
            if (passwordTest.evaluateWithObject(input)){
                return input
            }
            else {
                throw Reason.InvalidPassword
            }
        }
        return nil
    }
    
    func passwordsMatch() throws -> Bool
    {
        if passwordField.text == password2Field.text
        {
            return true
        }
        else
        {
            throw Reason.InvalidPasswordMatch
        }

    }
    
//    func inputValidation() -> [String:String]?
//    {
//        var userInfo: [String:String]?
//
//        do{
//            let business = try isValidString(businessField.text)
//        }
//        catch let error
//        {
//            //business name error
//            print(error)
//        }
//        
//        do {
//            let email = try isValidEmail1(emailField.text)
//        }
//        catch let error
//        {
//            //Email Error
//            print(error)
//        }
//        
//
//        do {
//            try passwordsMatch()
//        }
//        catch let error
//        {
//            //Password match error
//            print(error)
//        }
//        
//                                
//        do {
//            if let password = try isValidPassword1(passwordField.text)
//            {
//
//                print("\(business)")
//                userInfo = ["email": email, "password": password, "business": business]
//                return userInfo
//            }
//        }
//        catch let error
//        {
//            //Password validation error
//            print(error)
//        }
//        
//        return nil
//    }
    
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
                            if try passwordsMatch()
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
                                }
                                
                            }
                        }
                        catch let error
                        {
                            //Password match error
                            print(error)
                        }
                    }
                }
                catch let error
                {
                    //Email Error
                    print(error)
                }
            }
        }
        catch let error
        {
            //business name error
            print(error)
        }
        
        return nil
    }
    
    
    
//    func inputValidation() -> [String:String]
//    {
//        var userInfo: [String:String]?
//        
//        if let business = checkValue(businessField.text)
//        {
//            if let email = checkValue(emailField.text) {
//                if isValidEmail(email)
//                {
//                    if passwordField.text == password2Field.text
//                    {
//                        if let password = checkValue(passwordField.text)
//                        {
//                            if isValidPassword(password)
//                            {
//                                print("\(business)")
//                                userInfo = ["email": email, "password": password, "business": business]
//                                return userInfo!
//                            }
//                            else
//                            {
//                                print("passwords not valid")
//                                
//                            }
//                        }
//                    }
//                    else
//                    {
//                        print("passwords do not match")
//                    }
//                }
//                else
//                {
//                    print("not valid email")
//                }
//            }
//        }
//        return userInfo!
//    }
    
    
    
//    
//
//    @IBAction func next1Pressed(sender: AnyObject) {
//        
//        if let business = checkValue(businessField.text)
//        {
//        if let email = checkValue(emailField.text) {
//            if isValidEmail(email)
//            {
//                if passwordField.text == password2Field.text
//                {
//                    if let password = checkValue(passwordField.text)
//                    {
//                        if isValidPassword(password)
//                        {
//                            print("\(business)")
//                            
//                            
//                            let register = RegisterRequest1(email: emailField.text!, password: passwordField.text!, business: businessField.text!) {
//                                result in
//                                //            if case . Success(let user) = result {
//                                if case . Success = result {
//                                    //                print(user.userID)
//                                    print("Success")
//                                    dispatch_async(dispatch_get_main_queue()) {
//                                        self.performSegueWithIdentifier("next1", sender: nil)
//                                    }
//                                }
//                                    //            else if case . Error(let reason) = result {
//                                else if case . Error = result {
//                                    print("error")
//                                    
//                                }
//                            }
//                            
//                            NetworkClient.instance.process(register)
//                            
//                        }
//                    }
//                }
//                else
//                {
//                    print("passwords do not match")
//                }
//            }
//            else
//            {
//                print("not valid email")
//            }
//        }
//        }
//
//    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
