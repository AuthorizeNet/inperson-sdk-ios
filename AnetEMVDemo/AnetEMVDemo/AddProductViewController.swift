//
//  AddProductViewController.swift
//  AnetEMVDemo
//
//  Created by Pankaj Taneja on 10/28/15.
//  Copyright © 2015 Pankaj Taneja. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AuthNetDelegate {
    @IBOutlet weak var tableView: UITableView!
    var selectedProducts:NSMutableArray = NSMutableArray()
    
    var emvManager = AnetEMVManager.initWithCurrecyCode("840", terminalID: "", skipSignature: false, showReceipt: false)
    
    var sessionToken:String? = nil
    var response:AnetEMVTransactionResponse? = nil
    var error:AnetEMVError? = nil
    
    override func loadView() {
        super.loadView()
        self.navigationItem.hidesBackButton = true
        AuthNet.getInstance().delegate = self
        emvManager.setLoggingEnabled(true)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        
        if (indexPath.row == 0) {
            aCell.textLabel?.text = "Last Transaction Status"
            aCell.detailTextLabel?.text = nil
            return aCell
        } else {
            aCell.textLabel?.text = "Item \(indexPath.row)"
            aCell.detailTextLabel?.text = "$\(indexPath.row)"
            
            if self.selectedProducts.containsObject(indexPath) {
                aCell.accessoryType = .Checkmark
            } else {
                aCell.accessoryType = .None
            }
            return aCell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            self.performSegueWithIdentifier("details", sender: self)
        } else {
            if self.selectedProducts.containsObject(indexPath) {
                self.selectedProducts .removeObject(indexPath)
            } else {
                self.selectedProducts.addObject(indexPath)
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view : UIView = UIView.init(frame: CGRectMake(0, 100, self.tableView.frame.size.width, 80))
        let button : UIButton = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 80)
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        button.setTitle("LOGOUT", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(AddProductViewController.logout), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        return view
    }
    
    @IBAction func logout() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "YES", style: .Cancel) { action -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        actionSheetController.addAction(yesAction)
        let noAction: UIAlertAction = UIAlertAction(title: "NO", style: .Default) { action -> Void in
        }
        actionSheetController.addAction(noAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func enteredAmount(sender: AnyObject)
    {
        let dialog = UIAlertController(title: "Please enter amount", message: "amount in USD, max 2 decimals", preferredStyle: UIAlertControllerStyle.Alert)
        
        let chargeAction = UIAlertAction(title: "EMV", style: UIAlertActionStyle.Default) {(_) in
            let amountTextField = dialog.textFields![0] as UITextField
            let anItem:LineItemType = LineItemType()
            anItem.itemID = "0"
            anItem.itemPrice = amountTextField.text
            anItem.itemName = "0"
            anItem.itemTaxable = false
            anItem.itemQuantity = "1"
            anItem.itemDescription = "goods"
            
            let aRequest = AnetEMVTransactionRequest()
            aRequest.lineItems = [anItem];
            aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
            aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
            aRequest.amount = amountTextField.text
            
            // below value are optional
            aRequest.retail = TransRetailInfoType()
            aRequest.retail.marketType = "2"
            aRequest.retail.deviceType = "7"

            AnetEMVManager.sharedInstance().startEMVWithTransactionRequest(aRequest, presentingViewController: self, completionBlock: {
                (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
                
                self.response = response
                self.error = error
                print(error)
                
                if (response?.respondsToSelector(Selector("isTransactionSuccessful")) == true && response?.isTransactionSuccessful == true && error == nil) {
                    self.sessionToken = self.response?.sessionToken
                    print("transaction successfull")
                } else {
                    print("transaction error")
                }
                }, andCancelActionBlock: {
                    print("Tapped cancel")
                }
            )
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        dialog.addAction(chargeAction)
        dialog.addAction(cancelAction)
        dialog.addTextFieldWithConfigurationHandler()  { (textField) in
            textField.placeholder = "Amount in USD"
            textField.keyboardType = .DecimalPad
        }
        self.presentViewController(dialog, animated: true, completion: nil)
    }
    
    @IBAction func pay(sender: AnyObject) {
        let productArray:NSMutableArray = NSMutableArray()
        var transactionAmount = 0

        self.selectedProducts.enumerateObjectsUsingBlock({ object, index, stop in
            let indexPath:NSIndexPath = object as! NSIndexPath
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            
            let anItem:LineItemType = LineItemType()
            anItem.itemID = "\(indexPath.row)"
            anItem.itemPrice = cell?.detailTextLabel?.text?.stringByReplacingOccurrencesOfString("$", withString: "")
            
            if (anItem.itemPrice != nil) {
                transactionAmount = Int(anItem.itemPrice)! + transactionAmount
            }
            anItem.itemName = cell?.textLabel?.text
            anItem.itemTaxable = false
            anItem.itemQuantity = "1"
            anItem.itemDescription = "goods"
            productArray.addObject(anItem)
        })
        
        let aRequest = AnetEMVTransactionRequest()
        // uncomment this line to send the item information
        aRequest.lineItems = productArray
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = "\(transactionAmount)"
        
        // below values are optional
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        AnetEMVDemoUISettings.sharedInstance().readFromSettingsBundle()
        
        AnetEMVUISettings.sharedUISettings().backgroundColor = AnetEMVDemoUISettings.sharedInstance().backgroundColor
        AnetEMVUISettings.sharedUISettings().textFontColor = AnetEMVDemoUISettings.sharedInstance().textFontColor
        AnetEMVUISettings.sharedUISettings().buttonColor = AnetEMVDemoUISettings.sharedInstance().buttonColor
        AnetEMVUISettings.sharedUISettings().buttonTextColor = AnetEMVDemoUISettings.sharedInstance().buttonTextColor
        AnetEMVUISettings.sharedUISettings().logoImage = AnetEMVDemoUISettings.sharedInstance().logoImage
        AnetEMVUISettings.sharedUISettings().bannerBackgroundColor = AnetEMVDemoUISettings.sharedInstance().bannerBackgroundColor
        
        AnetEMVManager.sharedInstance().startEMVWithTransactionRequest(aRequest, presentingViewController: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            self.response = response
            
            self.error = error
            
            print(error)
            
            if (response?.respondsToSelector(Selector("isTransactionSuccessful")) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
            } else {
                print("transaction error")
            }
            }, andCancelActionBlock: {
                print("Tapped cancel")
            }
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details" {
            let detailsController:DetailsViewController = segue.destinationViewController as! DetailsViewController
            detailsController.sessionToken = self.sessionToken
            detailsController.transId = self.response?.transId
        }
    }
}
