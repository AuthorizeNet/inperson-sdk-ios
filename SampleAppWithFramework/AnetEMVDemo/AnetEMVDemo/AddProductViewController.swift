//
//  AddProductViewController.swift
//  AnetEMVDemo
//
//  Created by Pankaj Taneja on 10/28/15.
//  Copyright © 2015 Pankaj Taneja. All rights reserved.
//

import UIKit
import PassKit
import Messages

class AddProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AuthNetDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var cardInteraction: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var isTestReader: UISwitch!

    var selectedProducts:NSMutableArray = NSMutableArray()
    
    var emvManager = AnetEMVManager.initWithCurrecyCode("840", terminalID: "", skipSignature: UserDefaults.standard.bool(forKey: "signature"), showReceipt: UserDefaults.standard.bool(forKey: "receipt"))
    
    var sessionToken:String? = nil
    var response:AnetEMVTransactionResponse? = nil
    var error:AnetEMVError? = nil
    let anApplePayRequest:PKPaymentRequest = PKPaymentRequest()
    var createTransaction:CreateTransactionRequest? = nil
    var amountTextField:UITextField? = nil
    var keyedINAmount:Bool = false
    // View life cycle

    override func loadView() {
        super.loadView()
        self.navigationItem.hidesBackButton = true
        AuthNet.getInstance().delegate = self
        emvManager.setLoggingEnabled(true)
        print(AnetEMVManager.anetSDKVersion())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // TableView delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        if ((indexPath as NSIndexPath).row == 0) {
            aCell?.textLabel?.text = "Last Transaction Status"
            aCell?.detailTextLabel?.text = nil
            return aCell!
        } else {
//            aCell?.textLabel?.text = "Item \((indexPath as NSIndexPath).row)"

            let beers:NSMutableArray = self.beers()
            aCell?.textLabel?.text = beers.object(at: (((indexPath as NSIndexPath).row) + 1)) as? String
            aCell?.detailTextLabel?.text = "$\((indexPath as NSIndexPath).row)"
            aCell?.imageView?.image = UIImage(named: "beer.png")
            
            if self.selectedProducts.contains(indexPath) {
                aCell?.accessoryType = .checkmark
            } else {
                aCell?.accessoryType = .none
            }
            return aCell!
        }
    }
    
    func beers() -> NSMutableArray {
        let tipOptions : NSMutableArray? = []
        tipOptions?.add("SAM ADAMS")
        tipOptions?.add("CORONA LIGHT")
        tipOptions?.add("BECKS")
        tipOptions?.add("MILLER LIGHT")
        tipOptions?.add("BOUNDARY BAY IPA")
        tipOptions?.add("HEINEKEN")
        tipOptions?.add("ELYSIAN IPA")
        tipOptions?.add("BELLEVUE IPA")
        tipOptions?.add("STELLA ARTOIS")
        tipOptions?.add("BUD LIGHT")
        tipOptions?.add("DUVEL")
        tipOptions?.add("PACIFICO")
        return tipOptions!
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
    
    // AddProductViewController actions
    
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
    
    @IBAction func pay(_ sender: AnyObject?) {
        if self.keyedINAmount == false {
            self.amountTextField = nil
        }
        self.keyedINAmount = false
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let qcInBAction: UIAlertAction = UIAlertAction(title: "EMV Transaction", style: .default) { action -> Void in
            self.emvPayment()
        }
        actionSheetController.addAction(qcInBAction)

        let emvAction: UIAlertAction = UIAlertAction(title: "Process Card for QuickChip", style: .default) { action -> Void in
            self.quickChipInBackground()
        }
        actionSheetController.addAction(emvAction)
        
        let discardAction: UIAlertAction = UIAlertAction(title: "Discard Processed Card Data", style: .default) { action -> Void in
            self.discardPreviousProcessedCard()
        }
        actionSheetController.addAction(discardAction)

        let qcAction: UIAlertAction = UIAlertAction(title: "Quick Chip Transaction", style: .default) { action -> Void in
            self.quickChipPayment()
        }
        actionSheetController.addAction(qcAction)

        let qcWTAction: UIAlertAction = UIAlertAction(title: "Quick Chip with Tip Amount", style: .default) { action -> Void in
            self.quickChipPaymentWithTipAmount()
        }
        actionSheetController.addAction(qcWTAction)

        let qcWTOAction: UIAlertAction = UIAlertAction(title: "Quick Chip with Tip Options", style: .default) { action -> Void in
            self.quickChipPaymentWithTipOptions()
        }
        
        actionSheetController.addAction(qcWTOAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            self.discardPreviousProcessedCard()
        }
        actionSheetController.addAction(cancelAction)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func discardPreviousProcessedCard() -> () {
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().discardQuickChipCardDataWithPredeterminedAmount()
    }
    
    func quickChipInBackground() -> () {
        self.cardInteraction.text = "Initializing.."
        
        AnetEMVManager.sharedInstance().readQuickChipCardDataWithPredeterminedAmount(on: self, transactionType:.goods, withCardInteractionProgressBlock: {
            (cardProgress : AnetEMVCardInteractionProgress) -> () in
            
            switch cardProgress {
                case .waitingForCard:
                    self.cardInteraction.text = "Please insert the card"
                    print("waiting for card")
                    break
                case .processingCard:
                    self.cardInteraction.text = "Processing the card..."
                    print("Processing the card...")
                    break
                case .doneWithCard:
                    self.cardInteraction.text = "Done with the card."
                    print("Done with the card.")
                    break
                case .retryInsertOrSwipe:
                    self.cardInteraction.text = "Please retry swipe/insert."
                    break
                case .swipe:
                    self.cardInteraction.text = "Please swipe."
                    break
                case .swipeOrTryAnotherCard:
                    self.cardInteraction.text = "Please swipe or try another card."
                    break
            }
        }, andCardIntercationCompletionBlock: {
            (isSuccess : Bool, error : AnetEMVError?) -> () in
            
            var actionSheetController: UIAlertController = UIAlertController(title: "", message: "Chip data SAVED SUCCESSFULLY.", preferredStyle: .alert)
            
            if !isSuccess {
                self.cardInteraction.text = "Read chip data failed."
                actionSheetController = UIAlertController(title: "", message: "Chip data fetch failed.", preferredStyle: .alert)
            } else {
                self.cardInteraction.text = "Read chip data successfully."
            }
            let yesAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(yesAction)
            self.present(actionSheetController, animated: true, completion: nil)
        })
    }
    
    func transactionObject() -> AnetEMVTransactionRequest {
        let aRequest = AnetEMVTransactionRequest()
        aRequest.emvTransactionType = .goods;
        let amountAndProducts = self.totalAmountAndProduct()
        aRequest.lineItems = amountAndProducts.products
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = "\(amountAndProducts.totalAmount)"
        
        let order = OrderType()
        order.invoiceNumber = randoMax10DigitString()
        order.orderDescription = "Order from Sample Application"
        aRequest.order = order
        
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        
        
        if (UserDefaults.standard.value(forKey: "employeeId") != nil) {
            aRequest.employeeId = ((UserDefaults.standard.value(forKey: "employeeId")!) as! NSString) as String
        }
        
        
        if (UserDefaults.standard.value(forKey: "tableNumber") != nil) {
            aRequest.tableNumber = ((UserDefaults.standard.value(forKey: "tableNumber")!) as! NSString) as String
        }
        
        if (UserDefaults.standard.value(forKey: "terminalMode") != nil) {
            let terminalMode:String = ((UserDefaults.standard.value(forKey: "terminalMode")!) as! NSString) as String
            
            if (terminalMode == "M") {
                emvManager.setTerminalMode(.modeSwipe)
            } else {
                emvManager.setTerminalMode(.modeInsertOrSwipe)
            }
        }
        

        AnetEMVDemoUISettings.sharedInstance().readFromSettingsBundle()
        
        AnetEMVUISettings.shared().backgroundColor = AnetEMVDemoUISettings.sharedInstance().backgroundColor
        AnetEMVUISettings.shared().textFontColor = AnetEMVDemoUISettings.sharedInstance().textFontColor
        AnetEMVUISettings.shared().buttonColor = AnetEMVDemoUISettings.sharedInstance().buttonColor
        AnetEMVUISettings.shared().buttonTextColor = AnetEMVDemoUISettings.sharedInstance().buttonTextColor
        AnetEMVUISettings.shared().logoImage = AnetEMVDemoUISettings.sharedInstance().logoImage
        AnetEMVUISettings.shared().bannerBackgroundColor = AnetEMVDemoUISettings.sharedInstance().bannerBackgroundColor
        AnetEMVUISettings.shared().backgroundImage = AnetEMVDemoUISettings.sharedInstance().backgroundImage
        
        return aRequest
    }
    
    func emvPayment() -> () {
        self.cardInteraction.text = "No activity in process."
        
        AnetEMVManager.sharedInstance().startEMV(with: self.transactionObject(), presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            self.response = response
            self.error = error
            
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
    
    func quickChipPayment() -> () {
        self.cardInteraction.text = "No activity in process."
                
        
        AnetEMVManager.sharedInstance().startQuickChip(with: self.transactionObject(), forPaperReceiptCase:UserDefaults.standard.bool(forKey: "paperReceipt"), presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            
            self.response = response
            self.error = error
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
            } else {
                print("transaction error")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
        })
    }
    
    func quickChipPaymentWithTipAmount() -> () {
        self.cardInteraction.text = "No activity in process."
        
        AnetEMVManager.sharedInstance().startQuickChip(with: self.transactionObject(), tipAmount: ((UserDefaults.standard.value(forKey: "tipAmount")!) as! NSString) as String, presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            
            self.response = response
            self.error = error
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
            } else {
                print("transaction error")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
        })
        
        
    }
    
    func quickChipPaymentWithTipOptions() -> () {
        self.cardInteraction.text = "No activity in process."
        
        let tipOptions : NSMutableArray? = []
        tipOptions?.add(UserDefaults.standard.value(forKey: "tipOption1")!)
        tipOptions?.add(UserDefaults.standard.value(forKey: "tipOption2")!)
        tipOptions?.add(UserDefaults.standard.value(forKey: "tipOption3")!)

        AnetEMVManager.sharedInstance().startQuickChip(with: self.transactionObject(), tipOptions: (tipOptions! as NSArray) as! [Any], presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            
            self.response = response
            self.error = error
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
            } else {
                print("transaction error")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
        })
    }
    
    @IBAction func deviceInfo(_ sender: AnyObject) {
        let aBlock:ReaderDeviceInfoBlock = {
            (deviceInfo : [AnyHashable:Any]) -> Void in
            print(deviceInfo)
            
            let actionSheetController: UIAlertController = UIAlertController(title: "", message: deviceInfo.description, preferredStyle: .alert)
            let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(yesAction)
            self.present(actionSheetController, animated: true, completion: nil)            
        }
        
        AnetEMVManager.sharedInstance().getAnyWhereReaderInfo(aBlock)
    }
    
    @IBAction func mail(_ sender: AnyObject) {
        let mailController:MFMailComposeViewController = AnetEMVDemoUISettings.mail(to: "", withSubject: "", withBody: "", from: self)
        self.present(mailController, animated: true, completion: nil)
    }
    
    @IBAction func OTAUpdate(_ sender: AnyObject) {
        AnetEMVManager.sharedInstance().startOTAUpdate(fromPresenting: self, isTestReader: self.isTestReader.isOn)

    }
    
    @IBAction func enteredAmount(_ sender: AnyObject)
    {
        let dialog = UIAlertController(title: "Please enter amount", message: "amount in USD, max 2 decimals", preferredStyle: UIAlertControllerStyle.alert)

        
        let chargeAction = UIAlertAction(title: "Pay", style: UIAlertActionStyle.default) {(_) in
            self.keyedINAmount = true
            self.pay(nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        dialog.addAction(chargeAction)
        dialog.addAction(cancelAction)
        dialog.addTextField()  { (textField) in
            textField.placeholder = "Amount in USD"
            textField.keyboardType = .decimalPad
        }
        self.present(dialog, animated: true, completion: {
            let textField = dialog.textFields![0] as UITextField
            self.amountTextField = textField
            self.amountTextField?.delegate = self
        })
    }
    
    // Utility

    func totalAmountAndProduct() -> (products:NSMutableArray, totalAmount:Double) {
        
        let productArray:NSMutableArray = NSMutableArray()
        var transactionAmount = 0.0
        
        if self.amountTextField != nil {
            let anItem:LineItemType = LineItemType()
            anItem.itemName = "KeyedIn Item"
            anItem.itemTaxable = false
            anItem.itemQuantity = "1"
            anItem.itemID = "KI"
            anItem.itemDescription = "goods"
            anItem.itemPrice = self.amountTextField?.text
            productArray.add(anItem)
            transactionAmount = Double((self.amountTextField?.text)!)!
        } else {
            self.selectedProducts.enumerateObjects({ object, index, stop in
                let indexPath:IndexPath = object as! IndexPath
                let cell = self.tableView.cellForRow(at: indexPath)
                
                let anItem:LineItemType = LineItemType()
                anItem.itemID = "\((indexPath as NSIndexPath).row)"
                anItem.itemPrice = cell?.detailTextLabel?.text?.replacingOccurrences(of: "$", with: "")
                
                if (anItem.itemPrice != nil) {
                    transactionAmount = Double(anItem.itemPrice)! + transactionAmount
                }
                anItem.itemName = cell?.textLabel?.text
                anItem.itemTaxable = false
                anItem.itemQuantity = "1"
                anItem.itemDescription = "goods"
                productArray.add(anItem)
            })
        }
        return (productArray, transactionAmount)
    }
    
    func randoMax10DigitString() -> String {
        let i = arc4random_uniform(1000000000) + 1
        return String(i)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let detailsController:DetailsViewController = segue.destination as! DetailsViewController
            detailsController.sessionToken = self.sessionToken
            detailsController.transId = self.response?.transId
        }
    }
    
    func base64forData(_ theData: Data) -> String {
        let charSet = CharacterSet.urlQueryAllowed
        
        let paymentString = NSString(data: theData, encoding: String.Encoding.utf8.rawValue)!.addingPercentEncoding(withAllowedCharacters: charSet)
        
        return paymentString!
    }
    
    // Mail composer delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?){
        controller.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let digitChracterSet = NSCharacterSet.decimalDigits.inverted
        
        let replaceDecimal = string.replacingOccurrences(of: ".", with: "")
        
        if ((replaceDecimal.rangeOfCharacter(from: digitChracterSet)) != nil) && !(((replaceDecimal.rangeOfCharacter(from: digitChracterSet))?.isEmpty)!) {
            return false
        }
        return true
    }
}
