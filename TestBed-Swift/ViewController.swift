//
//  ViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 5/26/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userIDValue: UILabel!
    @IBOutlet weak var branchLinkTextField: UITextField!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    var branchUniversalObject = BranchUniversalObject()
    var creditHistory: Array<AnyObject>?
    
    let canonicalIdentifier = "item/12345"
    let canonicalUrl = "https://dev.branch.io/getting-started/deep-link-routing/guide/ios/"
    let contentTitle = "Content Title"
    let contentDescription = "My Content Description"
    let imageUrl = "https://pbs.twimg.com/profile_images/658759610220703744/IO1HUADP.png"
    let feature = "Sharing Feature"
    let channel = "Distribution Channel"
    let desktop_url = "http://branch.io"
    let ios_url = "https://dev.branch.io/getting-started/sdk-integration-guide/guide/ios/"
    let shareText = "Super amazing thing I want to share"
    let user_id1 = "Teddy the Greek"
    let user_id2 = "Teddy the Greek"
    let live_key = "live_key"
    let test_key = "test_key"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableViewCell.appearance().backgroundColor = UIColor.clearColor()
        self.branchLinkTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        // let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        // self.tableView.addGestureRecognizer(gestureRecognizer)
        
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        branchUniversalObject.canonicalUrl = canonicalUrl
        branchUniversalObject.title = contentTitle
        branchUniversalObject.contentDescription = contentDescription
        branchUniversalObject.imageUrl  = imageUrl
        branchUniversalObject.addMetadataKey("deeplink_text", value: String(format: "This text was embedded as data in a Branch link with the following characteristics:\n\n  canonicalUrl: %@\n  title: %@\n  contentDescription: %@\n  imageUrl: %@\n", canonicalUrl, contentTitle, contentDescription, imageUrl))
        self.refreshRewardPoints()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section, indexPath.row) {
        case (0,0) :
            self.performSegueWithIdentifier("ShowUserIDViewControllerSegue", sender: nil)
        case (1,1) :
            self.performSegueWithIdentifier("ShowCustomEventSegue", sender: nil)
        case (1,2) :
            self.performSegueWithIdentifier("CustomEventData", sender: nil)
        default : break
        }
        
    }

    
    @IBAction func createBranchLinkButtonTouchUpInside(sender: AnyObject) {
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = feature
        linkProperties.channel = channel
        linkProperties.addControlParam("$desktop_url", withValue: desktop_url)
        linkProperties.addControlParam("$ios_url", withValue: channel)
        linkProperties.addControlParam("$deeplink_path", withValue: "#/nominate/579295cee4b0a9209267540a?referralCode=28199b17-620b-4329-af2e-5535b2f48d7d")
        print(linkProperties.description())
        print(branchUniversalObject.description())
        branchUniversalObject.getShortUrlWithLinkProperties(linkProperties) { (url, error) in
            if (error == nil) {
                print(url)
                self.branchLinkTextField.text = url
            } else {
                print(String(format: "Branch TestBed: %@", error))
                self.showAlert("Link Creation Failed", withDescription: error.localizedDescription)
            }
            
        }
    }
    
    
    @IBAction func redeemFivePointsButtonTouchUpInside(sender: AnyObject) {
        pointsLabel.hidden = true
        activityIndicator.startAnimating()
        
        let branch = Branch.getInstance()
        branch.redeemRewards(5) { (changed, error) in
            if (error != nil || !changed) {
                print(String(format: "Branch TestBed: Didn't redeem anything: %@", error))
                self.showAlert("Redemption Unsuccessful", withDescription: error.localizedDescription)
            } else {
                print("Branch TestBed: Five Points Redeemed!")
            }
        }
        pointsLabel.hidden = false
        activityIndicator.stopAnimating()
    }
    
    
    @IBAction func setUserIDButtonTouchUpInside(sender: AnyObject) {
        
    }
    
    @IBAction func refreshRewardsButtonTouchUpInside(sender: AnyObject) {
        refreshRewardPoints()
    }
    
    @IBAction func simulateLogoutButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        branch.logoutWithCallback { (changed, error) in
            if (error != nil || !changed) {
                print(String(format: "Branch TestBed: Logout failed: %@", error))
                self.showAlert("Error simulating logout", withDescription: error.localizedDescription)
            } else {
                print("Branch TestBed: Logout succeeded")
                self.showAlert("Logout succeeded", withDescription: "")
                self.refreshRewardPoints()
            }
        }

    }
    
    @IBAction func sendBuyEventButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        branch.userCompletedAction("buy")
        refreshRewardPoints()
        self.showAlert("'buy' event dispatched", withDescription: "")
    }
    
    @IBAction func sendComplexEventButtonTouchUpInside(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowCustomEvent", sender: nil)
        /*
        let eventDetails = ["name": user_id1, "integer": 1, "boolean": true, "float": 3.14159265359, "test_key": test_key]
        let branch = Branch.getInstance()
        branch.userCompletedAction("buy", withState: eventDetails as [NSObject : AnyObject])
        let logOutput = String(format: "Custom Event Details:\n\n%@", eventDetails.description)
        self.performSegueWithIdentifier("ShowLogOutput", sender: logOutput)
        */
    }
    
    
    @IBAction func showRewardsHistoryButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        branch.getCreditHistoryWithCallback { (creditHistory, error) in
            if (error == nil) {
                self.creditHistory = creditHistory as Array?
                self.performSegueWithIdentifier("ShowCreditHistory", sender: nil)
            } else {
                print(String(format: "Branch TestBed: Error retrieving credit history: %@", error.localizedDescription))
                self.showAlert("Error retrieving credit history", withDescription:error.localizedDescription)
            }
        }
    }

    
    @IBAction func viewFirstReferringParamsButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        let params = branch.getFirstReferringParams()
        let logOutput = String(format:"FirstReferringParams:\n\n%@", params.description)
        
        self.performSegueWithIdentifier("ShowLogOutput", sender: logOutput)
        print("Branch TestBed: FirstReferringParams:\n", logOutput)
    }
    
    
    @IBAction func viewLatestReferringParamsButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        let params = branch.getFirstReferringParams()
        let logOutput = String(format:"FirstReferringParams:\n\n%@", params.description)
        
        self.performSegueWithIdentifier("ShowLogOutput", sender: logOutput)
        print("Branch TestBed: LatestReferringParams:\n", logOutput)
    }
    
    
    @IBAction func simulateContentAccessButtonTouchUpInside(sender: AnyObject) {
        self.branchUniversalObject.registerView()
        self.showAlert("Content Access Registered", withDescription: "")
    }
    
    @IBAction func actionButtonTouchUpInside(sender: AnyObject) {
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = feature
        linkProperties.addControlParam("$desktop_url", withValue: desktop_url)
        linkProperties.addControlParam("$ios_url", withValue: ios_url)
        
        branchUniversalObject.addMetadataKey("deeplink_text", value: "This link was generated during Share Sheet sharing")
        
        branchUniversalObject.showShareSheetWithLinkProperties(linkProperties, andShareText: shareText, fromViewController: nil, anchor: actionButton) { (activityType, completed) in
            if (completed) {
                print(String(format: "Branch TestBed: Completed sharing to %@", activityType))
            } else {
                print("Branch TestBed: Link Sharing Failed\n")
                self.showAlert("Link Sharing Failed", withDescription: "")
            }
        }
    }
    
    
    //example using callbackWithURLandSpotlightIdentifier
    @IBAction func registerWithSpotlightButtonTouchUpInside(sender: AnyObject) {
        branchUniversalObject.addMetadataKey("deeplink_text", value: "This link was generated for Spotlight registration")
        branchUniversalObject.listOnSpotlightWithIdentifierCallback { (url, spotlightIdentifier, error) in
            if (error == nil) {
                print("Branch TestBed: ShortURL: %@   spotlight ID: %@", url, spotlightIdentifier)
                self.showAlert("Spotlight Registration Succeeded", withDescription: String(format: "Branch Link:\n%@\n\nSpotlight ID:\n%@", url, spotlightIdentifier))
            } else {
                print("Branch TestBed: Error: %@", error.localizedDescription)
                self.showAlert("Spotlight Registration Failed", withDescription: error.localizedDescription)
            }
        }
    }
    
    
    func textFieldDidChange(sender:UITextField) {
        sender.resignFirstResponder()
    }
    
    
    func refreshRewardPoints() {
        pointsLabel.hidden = true
        activityIndicator.startAnimating()
        let branch = Branch.getInstance()
        branch.loadRewardsWithCallback { (changed, error) in
            if (error == nil) {
                self.pointsLabel.text = String(format: "%ld", branch.getCredits())
            }
        }
        activityIndicator.stopAnimating()
        pointsLabel.hidden = false
    }
    
    
    //MARK: Resign First Responder
    func hideKeyboard() {
        if (self.branchLinkTextField.isFirstResponder()) {
            self.branchLinkTextField.resignFirstResponder();
        }
    }
    
    
    func showAlert(alertTitle: String, withDescription message: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
        presentViewController(alert, animated: true, completion: nil);

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "ShowUserIDViewControllerSegue":
                let vc = (segue.destinationViewController as! UserIDViewController)
                vc.incumbantUserID = userIDValue.text
            case "ShowCustomEventSegue":
                break
            case "ShowSimulateReferrals":
                break
            case "ShowCreditHistory":
                let vc = (segue.destinationViewController as! CreditHistoryViewController)
                vc.creditTransactions = creditHistory
            default:
                let vc = (segue.destinationViewController as! LogOutputViewController)
                vc.logOutput = sender as! String
            
        }
        
    }
    
    @IBAction func unwindUserIDViewController(segue:UIStoryboardSegue) {
        if let userIDViewController = segue.sourceViewController as? UserIDViewController {
            
            if let userID = userIDViewController.userIDTextView.text {
                
                guard self.userIDValue.text != userID else {
                    return
                }
                
                let branch = Branch.getInstance()

                guard userID != "" else {
                    
                    branch.logoutWithCallback { (changed, error) in
                        if (error != nil || !changed) {
                            print(String(format: "Branch TestBed: Unable to clear User ID: %@", error))
                            self.showAlert("Error simulating logout", withDescription: error.localizedDescription)
                        } else {
                            print("Branch TestBed: User ID cleared")
                            self.userIDValue.text = userID
                            self.refreshRewardPoints()
                        }
                    }
                    return
                }
                    
                branch.setIdentity(userID) { (params, error) in
                    if (error == nil) {
                        print(String(format: "Branch TestBed: Identity Successfully Set%@", params))
                        self.userIDValue.text = userID
                        self.refreshRewardPoints()
                    } else {
                        print(String(format: "Branch TestBed: Error setting identity: %@", error))
                        self.showAlert("Unable to Set Identity", withDescription:error.localizedDescription)
                    }
                }
                
            }
        }
    }

    
}

