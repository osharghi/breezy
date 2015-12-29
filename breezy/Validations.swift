//
//  Validations.swift
//  breezy
//
//  Created by Omid Sharghi on 12/23/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import Foundation

struct ValidationMessage {
    let field: String             // name of the field with a problem
    let localizedMessage: String  // show to user
}

struct ValidationError: ErrorType {
    let problems: [ValidationMessage]
}

func validateString2(input: String?) -> [ValidationMessage] {
    var problems: [ValidationMessage] = []

    if let input = input {
        if input != ""
        {
            return problems
            //            return input == "" ? nil : input
            // if its "" return nil, otherwise return input
        }
        else {
            problems.append(ValidationMessage(field: "Business", localizedMessage: NSLocalizedString("The format of business is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}

func validatePassword2(password: String?) -> [ValidationMessage] {
    
    var problems: [ValidationMessage] = []
    if let password = password
    {
        let passwordRegEx = ".{5,32}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        if (passwordTest.evaluateWithObject(password))
        {
            return problems
        }
        else
        {
            problems.append(ValidationMessage(field: "password", localizedMessage: NSLocalizedString("The format of password is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}

func validatePasswordMatch2(password:String?, confirmed: String?) -> [ValidationMessage]
{
    var problems: [ValidationMessage] = []
    
    if password != confirmed {
        problems.append(ValidationMessage(field: "password", localizedMessage: NSLocalizedString("The passwords do not match.", comment: "Registration error message")))
    }
    return problems
    
}

func validateEmail2(input: String?) -> [ValidationMessage] {
    
    var problems: [ValidationMessage] = []
    if let input = input
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (emailTest.evaluateWithObject(input))
        {
            return problems
        }
        else
        {
            problems.append(ValidationMessage(field: "email", localizedMessage: NSLocalizedString("The format of email is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}

func validateName2(name: String?) -> [ValidationMessage] {
    
    var problems: [ValidationMessage] = []
    if let input = name
    {
        let regEx = "\\A[a-zA-Z]{2,}\\z"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return problems
        }
        else
        {
            problems.append(ValidationMessage(field: "email", localizedMessage: NSLocalizedString("The format of email is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}


func validateTitle2(title: String?) -> [ValidationMessage] {
    
    var problems: [ValidationMessage] = []
    if let input = title
    {
        let regEx = "\\A[a-zA-Z0-9]{2,}\\z"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return problems
        }
        else
        {
            problems.append(ValidationMessage(field: "email", localizedMessage: NSLocalizedString("The format of email is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}

func validateEmployeeNumber2(number: String?) -> [ValidationMessage] {
    
    var problems: [ValidationMessage] = []
    if let input = number
    {
        let regEx = "\\d{1,}"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return problems
        }
        else
        {
            problems.append(ValidationMessage(field: "email", localizedMessage: NSLocalizedString("The format of email is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}

func validateSkills2(skills: String?) -> [ValidationMessage] {
    
    var problems: [ValidationMessage] = []
    if let input = skills
    {
        let regEx = "\\A[#,a-zA-Z0-9\\s]{2,}\\z"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return problems
        }
        else
        {
            problems.append(ValidationMessage(field: "email", localizedMessage: NSLocalizedString("The format of email is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}

func validateBizDesc2(bizDesc: String?) -> [ValidationMessage] {
    
    var problems: [ValidationMessage] = []
    if let input = bizDesc
    {
        let regEx = ".{1,}"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))

        {
            return problems
        }
        else
        {
            problems.append(ValidationMessage(field: "email", localizedMessage: NSLocalizedString("The format of email is invalid.", comment: "Registration error message")))
        }
    }
    return problems
}





enum Register: String, ErrorType {
    
    case InvalidEmail = "this is invalid email"
    case InvalidPassword = "this is invalid Password"
    case InvalidPasswordMatch = "this is invalid password match"
    case InvalidBusiness = "this is invalid business"
    
}

enum Register1: ErrorType
{
    case InvalidName
    case InvalidTitle
    case InvalidCompany
    case InvalidZip
    case InvalidEmployeeNumber
    case InvalidSkills
    case InvalidBizDesc
    
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
            throw Register.InvalidBusiness
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
            throw Register.InvalidEmail
        }
    }
    return nil
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
            throw Register.InvalidPassword
        }
    }
    return nil
}

func passwordsMatch1(input1:String?, input2: String?) throws -> Bool
{
    if input1 == input2
    {
        return true
    }
    else
    {
        throw Register.InvalidPasswordMatch
    }
    
}


func validateName(input: String?) throws -> String? {
    if let input = input {
//        let regEx = "[a-zA-Z]{2,}"
        let regEx = "\\A[a-zA-Z]{2,}\\z"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return input
        }
        else
        {
            print("ERROR")
            throw Register1.InvalidName
        }
    }
    return nil
}

func validateTitle(input: String?) throws -> String? {
    if let input = input {
//        let regEx = "[a-zA-Z0-9]{2,}"
        let regEx = "\\A[a-zA-Z0-9]{2,}\\z"

        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return input
        }
        else
        {
            print("ERROR")
            throw Register1.InvalidTitle
        }
    }
    return nil
}

func validateZip(input: String?) throws -> String? {
    if let input = input {
        let regEx = "\\d{5}"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return input
        }
        else
        {
            print("ERROR")
            throw Register1.InvalidZip
        }
    }
    return nil
}

func validateEmployeeNumber(input: String?) throws -> String? {
    if let input = input {
        let regEx = "\\d{1,}"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return input
        }
        else
        {
            print("ERROR")
            throw Register1.InvalidEmployeeNumber
        }
    }
    return nil
}

func validateSkills(input: String?) throws -> String? {
    if let input = input {
        let regEx = "\\A[#,a-zA-Z0-9\\s]{2,}\\z"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            var newInput = input.stringByReplacingOccurrencesOfString(" ", withString: "")
            newInput = newInput.stringByReplacingOccurrencesOfString(",", withString: "")
            print("NEW INPUT \(newInput)")
            return newInput
        }
        else
        {
            print("ERROR")
            throw Register1.InvalidSkills
        }
    }
    return nil
}

func validateBizDesc(input: String?) throws -> String? {
    if let input = input {
        let regEx = ".{1,}"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        if (regExTest.evaluateWithObject(input))
        {
            return input
        }
        else
        {
            print("ERROR")
            throw Register1.InvalidBizDesc
        }
    }
    return nil
}

//func checkValue(input: String?) -> String? {
//    if let input = input {
//        return input == "" ? nil : input
//        // if its "" return nil, otherwise return input
//    }
//    return nil
//}

//func validateUsername(input: String?) -> String? {
//    if let input = input {
//        if input.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 10 {
//            return nil
//        }
//        return input
//    }
//    return nil
//}
