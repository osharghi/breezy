//
//  APIClient.swift
//  breezy
//
//  Created by Omid Sharghi on 11/25/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import Foundation

struct RegisterRequest1:Requestable {
    let email, password, business: String
    var params: [String: String ] { return ["email": email, "password": password, "business":business] }
    var pathString: String { return "auth/register1" }
    var method: HTTPMethod { return .Post }
    var response: (result: Result<User>) -> Void
}

struct RegisterRequest1a:Requestable {
    let userDict: [String:AnyObject]
    var params: [String: AnyObject ] { return ["userInfo": userDict]}
    var pathString: String { return "auth/register1" }
    var method: HTTPMethod { return .Post }
    var response: (result: Result<User>) -> Void
}

struct RegisterRequest2:Requestable {
    
    let firstName, title, zipCode, employeeNumber, bizDesc, skills: String
    var params: [String: AnyObject] { return ["firstName": firstName, "title": title, "bizDesc":bizDesc, "employeeNumber": employeeNumber, "zipCode": zipCode, "skills": skills]}
    var pathString: String { return "auth/register2" }
    var method: HTTPMethod { return .Post }
    var response: (result: Result<UserInfo>) -> Void
}

struct RegisterRequest2a:Requestable {
    
    let userInfo: [String:AnyObject]
    var params: [String: AnyObject] { return ["userInfo": userInfo]}
    var pathString: String { return "auth/register2" }
    var method: HTTPMethod { return .Post }
    var response: (result: Result<UserInfo>) -> Void
}

struct loginRequest:Requestable {
    
    let email, password: String
    var params: [String: AnyObject] { return ["email": email, "password": password]}
    var pathString: String { return "auth/login" }
    var method: HTTPMethod { return .Post }
    var response: (result: Result<UserInfo>) -> Void
}

struct SearchSkill:Requestable {
    let skill: String
    var params: [String: String ] { return ["":""] }
    var pathString: String { return "auth/search/" + skill }
    var method: HTTPMethod { return .Get }
    var response: (result: Result<skillQuery2>) -> Void
}


typealias JSON = AnyObject

// Error Handling

struct ErrorReason: ErrorType {
    let code: Int
    let message: String
}

// Results either return a se/rialized model or an error
enum Result<Model> {
    case Success(Model)
    case Error(ErrorReason)
    
    init(success: Model) { self = .Success(success) }
    init(error: ErrorReason) { self = .Error(error) }
}

// HTTP Methods

enum HTTPMethod : String {
    case Get = "GET"
    case Put = "PUT"
    case Post = "POST"
    case Delete = "DELETE"
}

// Serializable model objects

protocol Serializable {
    static func instantiate(json: JSON) -> Result<Self>
}

// A requestable command

protocol Requestable {
    typealias Serialize: Serializable
    var baseURLString: String { get }
    var pathString: String { get }
    var method: HTTPMethod { get }
    var params: [String: AnyObject] { get }
//    var params: [String: AnyObject] { get }
    var request: NSURLRequest { get }
    var response: (result: Result<Serialize>) -> Void { get }
    func handleResponse(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<Serialize>
}

// Default implementations

extension Requestable {
    var method: HTTPMethod { return .Get }
    var baseURLString: String { return "http://127.0.0.1:5000/" }
    var params: [String: AnyObject] { return [:] }

    var request: NSURLRequest {
        
        let URLString = baseURLString + pathString
        let URL = NSURL(string: URLString)!
        let r = NSMutableURLRequest(URL: URL)
        r.HTTPMethod = method.rawValue
        r.addValue("application/json", forHTTPHeaderField: "Content-Type")
        r.addValue("application/json", forHTTPHeaderField: "Accept")
        print(params)
        do {
                        
            if r.HTTPMethod != "GET"
            {
                r.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params as NSDictionary, options: [])
                return r
            }
            
            return r
            
        }
        
        catch{
            print("\(error)")
        }
        return r
    }
    
    
    func handleResponse(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<Serialize> {
        
        let httpResponse = response as! NSHTTPURLResponse
        
        print("response : \(httpResponse)")

        if httpResponse.statusCode == 200 {
            do {
                let json: JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                return Serialize.instantiate(json)
            }
            catch  {
                print("Error thrown. could not parse JSON: '\(error)'")
                return Result(error: ErrorReason(code: -1, message: "invalid json stream \(error)"))
            }
        }
        print("error under handle response")
        return Result(error: ErrorReason(code: -2, message: "http error code \(httpResponse.statusCode)"))
    }
}

// User object
struct User : Serializable {
    var userID: Int
    // more stuff here
    
    static func instantiate(json: JSON) -> Result<User> {
        // grab the username from the response data
        
        let result: Result<User>
        
        if let userID = json["response"] as? Int {
            result = Result<User>(success: User(userID: userID))
            print("userID is \(userID)")
        }
        else {
            let message = json["error"] as? String ?? ""
            result = Result<User>(error: ErrorReason(code: -1, message: message))
        }

        return result
    }
}

// UserInfo object
struct UserInfo : Serializable {
    var userInfo: Dictionary<String,String>
    
    // more stuff here
    
    static func instantiate(json: JSON) -> Result<UserInfo> {
        // grab the username from the response data
        
        let result: Result<UserInfo>
        
        if let userInfo = json["response"] as? Dictionary<String,String> {
            result = Result<UserInfo>(success: UserInfo(userInfo: userInfo))
        }
        else {
            let message = json["error"] as? String ?? ""
            result = Result<UserInfo>(error: ErrorReason(code: -1, message: message))
        }
        
        return result
    }
}


struct skillQuery : Serializable {
    var email: Array<String>
    
    // more stuff here
    
    static func instantiate(json: JSON) -> Result<skillQuery>
    {
        // grab the username from the response data
        
        let result: Result<skillQuery>
        
        if let emailArray = json["response"] as? Array<String> {
            result = Result<skillQuery>(success: skillQuery(email: emailArray))
            print("email is \(emailArray)")
        }
        else {
            let message = json["error"] as? String ?? ""
            result = Result<skillQuery>(error: ErrorReason(code: -1, message: message))
        }
        
        return result
    }
}

struct skillQuery2 : Serializable {
    
    var skillResults: Array<AnyObject>
    
//    var skillResults: [[String: AnyObject]]
    
    static func instantiate(json: JSON) -> Result<skillQuery2>
    {
        // grab the username from the response data
        
        let result: Result<skillQuery2>
        
        if let resultsArray = json["response"] as? Array<AnyObject>
        {

            result = Result<skillQuery2>(success: skillQuery2(skillResults: resultsArray))
            
        }
        else
        {
            let message = json["error"] as? String ?? ""
            result = Result<skillQuery2>(error: ErrorReason(code: -1, message: message))
        }
        return result
    }
    
}

// A generic OK object with no data
struct OK : Serializable {
    static func instantiate(json: JSON) -> Result<OK> {
        
        return Result<OK>(success: OK())
    }
}

// LoginRequest returns a user result

struct LoginRequest : Requestable {
    let email, password: String
    var response: (result: Result<User>) -> Void
    
    var method: HTTPMethod { return .Post }
    var pathString: String { return "auth/login" }
    var params: [String: String] { return ["email": email, "password": password ] }
}

// LogoutRequest returns an OK result

struct LogoutRequest : Requestable {
    var response: (result: Result<OK>) -> Void
    var pathString: String { return "auth/logout" }
    var method: HTTPMethod { return .Post }
}

// Here is the code that talks to the network

final class NetworkClient {
    static var instance = NetworkClient()
    lazy var session = NSURLSession.sharedSession()
    
    func process<T: Requestable>(requestable: T) {
        let request = requestable.request
        print(request.HTTPBody)
        print(request.URL)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            let result = requestable.handleResponse(data, response: response, error: error)
            
            requestable.response(result: result)
        }
        task.resume()
    }
}

/////////////////////////////////////////////////////////////////////////////////

/// Sample client code from here

let login = LoginRequest(email: "rayfix@gmail.com", password: "secret") { result in
    if case .Success(let user) = result {
        print(user.userID)
    }
    else if case .Error(let reason) = result {
        print(reason.message)
    }
}

let logout = LogoutRequest() { result in
    if case .Success = result {
        print("Logged out")
    }
    else if case .Error(let reason) = result {
        print(reason.message)
    }
}

//NetworkClient.instance.process(login)




