//
//  CustomEventMetadataTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/14/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class CustomEventMetadataTableViewController: UITableViewController {

    var customEventMetadata = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customEventMetadata = TestData.getCustomEventMetadata()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customEventMetadata.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomEventMetadataTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomEventMetadataTableViewCell
        
        let keys = Array(customEventMetadata.keys).sort()
        cell.keyLabel.text = keys[indexPath.row]
        cell.valueLabel.text = self.customEventMetadata[keys[indexPath.row]] as? String

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let keys = Array(customEventMetadata.keys)
            customEventMetadata.removeValueForKey(keys[indexPath.row])

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        TestData.setCustomEventMetadata(customEventMetadata)
        
    }
    
    /*
    - (void)addItem:sender {
    if (itemInputController == nil) {
    itemInputController = [[ItemInputController alloc] init];
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:itemInputController];
    [[self navigationController] presentModalViewController:navigationController animated:YES];
    }*/
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEnterParameter" {
            let customEventMetadataElementViewController = segue.destinationViewController as! CustomEventMetadataElementViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? CustomEventMetadataTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let keys = Array(customEventMetadata.keys)
                let selectedParameterKey = keys[indexPath.row]
                let selectedParameterValue = self.customEventMetadata[keys[indexPath.row]] as? String
                customEventMetadataElementViewController.incumbantKey = selectedParameterKey
                customEventMetadataElementViewController.incumbantValue = selectedParameterValue
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new key-value pair.")
        }
    }
    
    @IBAction func unwindCustomEventMetadataElementViewController(sender: UIStoryboardSegue) {
        if let sourceVC = sender.sourceViewController as? CustomEventMetadataElementViewController {
            
            guard sourceVC.keyTextField.text!.characters.count > 0 else {
                return
            }
            customEventMetadata[sourceVC.keyTextField.text!] = sourceVC.valueTextView.text
            tableView.reloadData()
        }
    }
    
}
