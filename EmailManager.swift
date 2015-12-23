//
//  EmailManager.swift
//  breezy
//
//  Created by Omid Sharghi on 12/10/15.
//  Copyright © 2015 Omid Sharghi. All rights reserved.
//

import UIKit
import MessageUI

public class EmailManager: NSObject, MFMailComposeViewControllerDelegate {
    
        var mailComposeViewController: MFMailComposeViewController?
        
        public override init()
        {
            mailComposeViewController = MFMailComposeViewController()
        }
        
        private func cycleMailComposer()
        {
            mailComposeViewController = nil
            mailComposeViewController = MFMailComposeViewController()
        }
        
        public func sendMailTo(emailList:[String], subject:String, body:String, fromViewController:UIViewController)
        {
            if MFMailComposeViewController.canSendMail() {
                mailComposeViewController!.setSubject(subject)
                mailComposeViewController!.setMessageBody(body, isHTML: false)
                mailComposeViewController!.setToRecipients(emailList)
                mailComposeViewController?.mailComposeDelegate = self
                fromViewController.presentViewController(mailComposeViewController!, animated: true, completion: nil)
            }
            else {
                print("Could not open email app")
            }
        }
        
        public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
        {
            controller.dismissViewControllerAnimated(true) { () -> Void in
                self.cycleMailComposer()
            }
        }

}
