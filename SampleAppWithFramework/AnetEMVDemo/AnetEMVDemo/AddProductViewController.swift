//
//  AddProductViewController.swift
//  AnetEMVDemo
//
//  Created by Pankaj Taneja on 10/28/15.
//  Copyright © 2015 Pankaj Taneja. All rights reserved.
//

import UIKit
import PassKit

class AddProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AuthNetDelegate, PKPaymentAuthorizationViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var selectedProducts:NSMutableArray = NSMutableArray()
    
    var emvManager = AnetEMVManager.initWithCurrecyCode("840", terminalID: "", skipSignature: false, showReceipt: true)
    
    var sessionToken:String? = nil
    var response:AnetEMVTransactionResponse? = nil
    var error:AnetEMVError? = nil
    let anApplePayRequest:PKPaymentRequest = PKPaymentRequest()
    var createTransaction:CreateTransactionRequest? = nil

    override func loadView() {
        super.loadView()
        self.navigationItem.hidesBackButton = true
        AuthNet.getInstance().delegate = self
        emvManager.setLoggingEnabled(false  )
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        
        if ((indexPath as NSIndexPath).row == 0) {
            aCell?.textLabel?.text = "Last Transaction Status"
            aCell?.detailTextLabel?.text = nil
            return aCell!
        } else {
            aCell?.textLabel?.text = "Item \((indexPath as NSIndexPath).row)"
            aCell?.detailTextLabel?.text = "$\((indexPath as NSIndexPath).row)"
            
            if self.selectedProducts.contains(indexPath) {
                aCell?.accessoryType = .checkmark
            } else {
                aCell?.accessoryType = .none
            }
            return aCell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).row == 0) {
            self.performSegue(withIdentifier: "details", sender: self)
        } else {
            if self.selectedProducts.contains(indexPath) {
                self.selectedProducts .remove(indexPath)
            } else {
                self.selectedProducts.add(indexPath)
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 100, width: self.tableView.frame.size.width, height: 80))
        let button : UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80)
        button.setTitleColor(UIColor.blue, for: UIControlState())
        button.setTitle("LOGOUT", for: UIControlState())
        button.addTarget(self, action: #selector(AddProductViewController.logout), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        return view
    }
    
    @IBAction func logout() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "YES", style: .cancel) { action -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        }
        actionSheetController.addAction(yesAction)
        let noAction: UIAlertAction = UIAlertAction(title: "NO", style: .default) { action -> Void in
        }
        actionSheetController.addAction(noAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func enteredAmount(_ sender: AnyObject)
    {
        let dialog = UIAlertController(title: "Please enter amount", message: "amount in USD, max 2 decimals", preferredStyle: UIAlertControllerStyle.alert)
        
        let chargeAction = UIAlertAction(title: "EMV", style: UIAlertActionStyle.default) {(_) in
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

            AnetEMVManager.sharedInstance().startEMV(with: aRequest, presenting: self, completionBlock: {
                (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
                
                self.response = response
                self.error = error
                print(error)
                
                if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        dialog.addAction(chargeAction)
        dialog.addAction(cancelAction)
        dialog.addTextField()  { (textField) in
            textField.placeholder = "Amount in USD"
            textField.keyboardType = .decimalPad
        }
        self.present(dialog, animated: true, completion: nil)
    }
    
    @IBAction func pay(_ sender: AnyObject) {
        self.emvPayment()
    }
    
    func applePayPayment() -> () {
        anApplePayRequest.currencyCode = "USD"
        anApplePayRequest.countryCode = "US"
        anApplePayRequest.merchantIdentifier = "merchant.net.authorize"
        anApplePayRequest.merchantCapabilities = PKMerchantCapability.capability3DS
        anApplePayRequest.supportedNetworks = [PKPaymentNetwork.masterCard, PKPaymentNetwork.visa, PKPaymentNetwork.amex]
        
        let aSummary:PKPaymentSummaryItem = PKPaymentSummaryItem()
        aSummary.amount = NSDecimalNumber(string: ".01")
        aSummary.label = "Apple Pay Demo"
        anApplePayRequest.paymentSummaryItems = [aSummary]
        
        
        if PKPaymentAuthorizationViewController.canMakePayments() &&
            PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [PKPaymentNetwork.masterCard, PKPaymentNetwork.visa, PKPaymentNetwork.amex]){
            let aController:PKPaymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: anApplePayRequest)
            aController.delegate = self
            self.present(aController, animated: true, completion: nil)
        }
    }
    
    func emvPayment() -> () {
        let productArray:NSMutableArray = NSMutableArray()
        var transactionAmount = 0
        
        self.selectedProducts.enumerateObjects({ object, index, stop in
            let indexPath:IndexPath = object as! IndexPath
            let cell = self.tableView.cellForRow(at: indexPath)
            
            let anItem:LineItemType = LineItemType()
            anItem.itemID = "\((indexPath as NSIndexPath).row)"
            anItem.itemPrice = cell?.detailTextLabel?.text?.replacingOccurrences(of: "$", with: "")
            
            if (anItem.itemPrice != nil) {
                transactionAmount = Int(anItem.itemPrice)! + transactionAmount
            }
            anItem.itemName = cell?.textLabel?.text
            anItem.itemTaxable = false
            anItem.itemQuantity = "1"
            anItem.itemDescription = "goods"
            productArray.add(anItem)
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
        
        AnetEMVUISettings.shared().backgroundColor = AnetEMVDemoUISettings.sharedInstance().backgroundColor
        AnetEMVUISettings.shared().textFontColor = AnetEMVDemoUISettings.sharedInstance().textFontColor
        AnetEMVUISettings.shared().buttonColor = AnetEMVDemoUISettings.sharedInstance().buttonColor
        AnetEMVUISettings.shared().buttonTextColor = AnetEMVDemoUISettings.sharedInstance().buttonTextColor
        AnetEMVUISettings.shared().logoImage = AnetEMVDemoUISettings.sharedInstance().logoImage
        AnetEMVUISettings.shared().bannerBackgroundColor = AnetEMVDemoUISettings.sharedInstance().bannerBackgroundColor
        //AnetEMVUISettings.shared().backgroundImage = UIImage(named: "bg.jpg")
        
        AnetEMVManager.sharedInstance().startEMV(with: aRequest, presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            self.response = response
            
            self.error = error
            
            print(error)
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let detailsController:DetailsViewController = segue.destination as! DetailsViewController
            detailsController.sessionToken = self.sessionToken
            detailsController.transId = self.response?.transId
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
        controller.dismiss(animated: true, completion: nil)
        
//        let data:String = self.base64forData(payment.token.paymentData)
        let data:String = String(data: payment.token.paymentData, encoding: String.Encoding.utf8)!
        
        self.createTransaction = CreateTransactionRequest()
        
        self.createTransaction!.transactionRequest.amount = ".01"
        
        let retailType = TransRetailInfoType()
        retailType.marketType = "0"
        retailType.deviceType = "7"
        
        self.createTransaction!.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        self.createTransaction!.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        
        self.createTransaction!.transactionRequest.retail = retailType
        let orderType:OrderType = OrderType()
        orderType.invoiceNumber = String(Int(arc4random_uniform(10)))
        
        let opaqueData:OpaqueDataType = OpaqueDataType()
        opaqueData.dataValue = data
        opaqueData.dataDescriptor = "COMMON.APPLE.INAPP.PAYMENT"
        
        let paymentT:PaymentType = PaymentType()
        self.createTransaction!.transactionRequest.payment = paymentT
        self.createTransaction!.transactionRequest.payment.opaqueData = opaqueData
        
        self.createTransaction!.transactionRequest.payment.swiperData = nil
        self.createTransaction!.transactionRequest.payment.trackData = nil
        self.createTransaction!.transactionRequest.payment.creditCard = nil
        self.createTransaction!.transactionRequest.payment.bankAccount = nil
        
        AuthNet.getInstance().authorize(with: self.createTransaction)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func base64forData(_ theData: Data) -> String {
        let charSet = CharacterSet.urlQueryAllowed
        
        let paymentString = NSString(data: theData, encoding: String.Encoding.utf8.rawValue)!.addingPercentEncoding(withAllowedCharacters: charSet)
        
        return paymentString!
    }
}
