//
//  ViewController.swift
//  breezy
//
//  Created by Allahe Sharghi on 11/9/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.

import UIKit
import MapKit
import CoreLocation

//Hello3

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    
    var searchResults: Array<AnyObject>?
    var searchSkill: String?
    let locationManager = CLLocationManager()
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        if (navigationController?.topViewController != self) {
            navigationController?.navigationBarHidden = false
        }
        super.viewWillDisappear(animated)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
        

        // Do any additional setup after loading the view, typically from a nib.
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
    
    func addHash(input: String?) -> String? {
//        var hashString = "#"
        if let input = input {
//            hashString = hashString + input
//            return hashString
            return input
        }

        return nil
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        
        if let searchText = checkValue(searchField.text)
        {
            searchSkill = searchText
            
           if let hashString = addHash(searchText)
            {
                print("hash string is \(hashString)")
                let search = SearchSkill(skill: hashString)
                {
                    result in
                    if case . Success (let user) = result
                    {
                        print("Count is \(user.skillResults.count)")
                        self.searchResults = user.skillResults
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("search", sender: nil)
                        }                    }
                    else if case . Error = result
                    {
                        print("error")
                        
                    }                    
                }
                
                NetworkClient.instance.process(search)

            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if let results = self.searchResults
        {
            let destinationVC = segue.destinationViewController as! SearchResult
            destinationVC.results = results
            destinationVC.currentSearch = searchSkill
            
        }
        
    }
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    

    


}

