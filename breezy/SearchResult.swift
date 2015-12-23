//
//  SearchResult.swift
//  breezy
//
//  Created by Omid Sharghi on 12/9/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import UIKit
import MessageUI

class SearchResult: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
   
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTable: UITableView!
    
    var results: Array<AnyObject>?
    var currentSearch: String?
    var selectedCellDict: Dictionary<String, AnyObject>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.searchTable.separatorInset = UIEdgeInsetsZero
        let nibName = UINib(nibName: "ResultCell", bundle:nil)
        self.searchTable.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        self.searchTable.estimatedRowHeight = 55
        self.searchTable.rowHeight = UITableViewAutomaticDimension
        self.searchTable.tableFooterView = UIView(frame: CGRectZero)

        


        print("new VC")
        if let results = results {
//            searchField.text = currentSearch
            searchBar.text = currentSearch
            print(currentSearch)
            print(results)
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.results!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.searchTable.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ResultCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.descriptionLabel.numberOfLines = 2

        if let searchResults = self.results
        {
            searchResults[indexPath.row]
            let dictResult = searchResults[indexPath.row]
            if let firstName = dictResult["firstName"]
            {
                cell.nameLabel.text = firstName as? String
                
                if let company = dictResult["company"]
                {
                    cell.companyLabel.text = (company as! String)
                    
                    if let title = dictResult["title"]
                    {
                        cell.titleLabel.text = title as? String
                        
                        if let bizDesc = dictResult["bizDesc"]
                        {
                            cell.descriptionLabel.text = bizDesc as? String
                            
                        }
                        
                    }
                    
                }
            }
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ResultCell {
            let label = cell.descriptionLabel
            self.searchTable.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.beginUpdates()
            label.numberOfLines = label.numberOfLines == 0 ? 2 : 0
            tableView.endUpdates()
        }

        
//New Email Method
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let emailer = appDelegate.emailer
//        
//        emailer.sendMailTo(["test@test.com"], subject: "Hi!", body: "Hi", fromViewController: self)
        
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
