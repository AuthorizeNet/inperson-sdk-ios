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
    
    

    var emvManager:AnetEMVManager? = nil
    
    var sessionToken:String? = nil
    var response:AnetEMVTransactionResponse? = nil
    var error:AnetEMVError? = nil
    let anApplePayRequest:PKPaymentRequest = PKPaymentRequest()
    var createTransaction:CreateTransactionRequest? = nil
    var amountTextField:UITextField? = nil
    var keyedINAmount:Bool = false
    var isAdditionalProfile:Bool = false
    var transID:String? = nil
    var profileID:String? = nil
    
    
    // View life cycle

    override func loadView() {
        super.loadView()
        var currencyCode = "840" // USD
        
        if (Locale.current.currencyCode! == "INR") {
            currencyCode = "356"
        } else if (Locale.current.currencyCode! == "EUR") {
            currencyCode = "978"
        } else {
            // choose the correct one as per your supported currency
        }
        emvManager = AnetEMVManager.initWithCurrecyCode(currencyCode, terminalID: "", skipSignature: UserDefaults.standard.bool(forKey: "signature"), showReceipt: UserDefaults.standard.bool(forKey: "receipt"))
        self.navigationItem.hidesBackButton = true
        AuthNet.getInstance().delegate = self
        emvManager?.setLoggingEnabled(true)
        
        let connectionMode = ((UserDefaults.standard.value(forKey: "connectionMode")!) as! NSString) as String
        if connectionMode == "BT" {
            emvManager?.setConnectionMode(.bluetooth)
        } else {
            emvManager?.setConnectionMode(.audio)
        }
        print(AnetEMVManager.anetSDKVersion())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    // TableView delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
        
        if ((indexPath as NSIndexPath).row == 0) {
            aCell?.textLabel?.text = "Last Transaction Status"
            aCell?.detailTextLabel?.text = nil
            return aCell!
        } else if ((indexPath as NSIndexPath).row == 1) {
            aCell?.textLabel?.text = "Merchant Details"
            aCell?.detailTextLabel?.text = nil
            return aCell!
        } else if ((indexPath as NSIndexPath).row == 2) {
            aCell?.textLabel?.text = "Reset SDK"
            aCell?.detailTextLabel?.text = nil
            return aCell!
        } else {
//            aCell?.textLabel?.text = "Item \((indexPath as NSIndexPath).row)"

            let beers:NSMutableArray = self.beers()
            aCell?.textLabel?.text = beers.object(at: (((indexPath as NSIndexPath).row) - 3)) as? String
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
        return 12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).row == 0) {
            self.performSegue(withIdentifier: "details", sender: self)
        } else if ((indexPath as NSIndexPath).row == 1) {
            let request:GetMerchantDetailsRequest = GetMerchantDetailsRequest()
            request.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
            request.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
            AuthNet.getInstance().delegate = self
            AuthNet.getInstance().getMerchantDetailsRequest(request)
        } else if ((indexPath as NSIndexPath).row == 2) {
            AnetEMVManager.resetEMVManager()
            self.cardInteraction.text = "No activity in process."
        } else {
            if self.selectedProducts.contains(indexPath) {
                self.selectedProducts .remove(indexPath)
            } else {
                self.selectedProducts.add(indexPath)
            }
            self.tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 100, width: self.tableView.frame.size.width, height: 80))
        let button : UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80)
        button.setTitleColor(UIColor.blue, for: UIControl.State())
        button.setTitle("LOGOUT", for: UIControl.State())
        button.addTarget(self, action: #selector(AddProductViewController.logout), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        return view
    }
    
    // AddProductViewController actions
    
    @IBAction func logout() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "YES", style: .cancel) { action -> Void in
            let request:LogoutRequest = LogoutRequest()
            request.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
            request.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
            AuthNet.getInstance().delegate = self
            AuthNet.getInstance()?.logoutRequest(request)
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
        
        let qcWPCAction: UIAlertAction = UIAlertAction(title: "Customer Profile Before", style: .default) { action -> Void in
            self.quickChipPaymentWithProfile(iConsentBefore: true)
        }
        
        actionSheetController.addAction(qcWPCAction)
        
        let qcCCPAAction: UIAlertAction = UIAlertAction(title: "Customer Profile After", style: .default) { action -> Void in
            self.quickChipPaymentWithProfile(iConsentBefore: false)
        }
        
        actionSheetController.addAction(qcCCPAAction)
        
        let qcCCHBAction: UIAlertAction = UIAlertAction(title: "Customer Profile Headless Before", style: .default) { action -> Void in
            
            let alert = UIAlertController(title: "", message: "Do you want to create a customer profile?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.quickChipPaymentCreateProfileHeadLessBefore(isConsent: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        actionSheetController.addAction(qcCCHBAction)
        
        let qcCCHAAction: UIAlertAction = UIAlertAction(title: "Customer Profile Headless After", style: .default) { action -> Void in
            self.quickChipPaymentCreateProfileHeadLessAfter()
        }
        actionSheetController.addAction(qcCCHAAction)
        
        let qcAddPPAction: UIAlertAction = UIAlertAction(title: "Add Payment Profile Before", style: .default) { action -> Void in
            self.additionalProfileClicked(isBefore: true)
        }
        actionSheetController.addAction(qcAddPPAction)
        
        let qcAddPPAfterAction: UIAlertAction = UIAlertAction(title: "Add Payment Profile After", style: .default) { action -> Void in
            self.additionalProfileClicked(isBefore: false)
        }
        actionSheetController.addAction(qcAddPPAfterAction)
        
        let qcAddPPHBAction: UIAlertAction = UIAlertAction(title: "Add Payment Profile Headless Before", style: .default) { action -> Void in
            let alert = UIAlertController(title: "", message: "Do you want to create an additional payment profile?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.quickChipPaymentCreateAdditionalProfileHeadLessBefore()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        actionSheetController.addAction(qcAddPPHBAction)
        
        let qcAddPPAAfterAction: UIAlertAction = UIAlertAction(title: "Add Payment Profile Headless After", style: .default) { action -> Void in
            self.quickChipPaymentCreateAdditionalProfileHeadLessAfter()
        }
        actionSheetController.addAction(qcAddPPAAfterAction)
        
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
        
        if (UserDefaults.standard.value(forKey: "terminalMode") != nil) {
            let terminalMode:String = ((UserDefaults.standard.value(forKey: "terminalMode")!) as! NSString) as String
            
            if (terminalMode == "M") {
                emvManager?.setTerminalMode(.modeSwipe)
            } else {
                emvManager?.setTerminalMode(.modeInsertOrSwipe)
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
        
        AnetProfileDemoUISettings.sharedInstance().readFromSettingsBundle()
        
        AnetCustomerProfileUISettings.shared().backgroundColor = AnetProfileDemoUISettings.sharedInstance().backgroundColor
        AnetCustomerProfileUISettings.shared().submitButtonColor = AnetProfileDemoUISettings.sharedInstance().submitButtonBGColor
        AnetCustomerProfileUISettings.shared().submitButtonTextColor = AnetProfileDemoUISettings.sharedInstance().submitButtonTextColor
        AnetCustomerProfileUISettings.shared().cancelButtonColor = AnetProfileDemoUISettings.sharedInstance().cancelButtonBGColor
        AnetCustomerProfileUISettings.shared().cancelButtonTextColor = AnetProfileDemoUISettings.sharedInstance().cancelButtonTextColor
        AnetCustomerProfileUISettings.shared().titleFontColor = AnetProfileDemoUISettings.sharedInstance().titleTextColor
        AnetCustomerProfileUISettings.shared().textFieldBorderColor = AnetProfileDemoUISettings.sharedInstance().textFieldBorderColor
        
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
    
    func quickChipPaymentCreateProfileHeadLessBefore(isConsent:Bool) -> () {
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().startQuickChip(with: self.transactionObject(), forPaperReceiptCase:UserDefaults.standard.bool(forKey: "paperReceipt"), presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            
            self.response = response
            self.error = error
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
                if (isConsent) {
                    self.isAdditionalProfile = false
                    self.performSegue(withIdentifier: "showProfile", sender: self)
                }
            } else {
                print("transaction error")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
            self.performSegue(withIdentifier: "showProfile", sender: self)
            
            
        })
    }
    
    func quickChipPaymentCreateAdditionalProfileHeadLessBefore() -> () {
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().startQuickChip(with: self.transactionObject(), forPaperReceiptCase:UserDefaults.standard.bool(forKey: "paperReceipt"), presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            
            self.response = response
            self.error = error
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
                self.additionalPaymentProfileHeadless()
                
            } else {
                print("transaction error")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
        })
    }
    
    func quickChipPaymentCreateProfileHeadLessAfter() -> () {
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().startQuickChip(with: self.transactionObject(), forPaperReceiptCase:UserDefaults.standard.bool(forKey: "paperReceipt"), presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            
            self.response = response
            self.error = error
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
                let alert = UIAlertController(title: "", message: "Do you want to create a customer profile?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.isAdditionalProfile = false
                    self.performSegue(withIdentifier: "showProfile", sender: self)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("transaction error")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
            self.performSegue(withIdentifier: "showProfile", sender: self)
            
        })
    }
    
    func quickChipPaymentCreateAdditionalProfileHeadLessAfter() -> () {
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().startQuickChip(with: self.transactionObject(), forPaperReceiptCase:UserDefaults.standard.bool(forKey: "paperReceipt"), presenting: self, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            
            self.response = response
            self.error = error
            
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.sessionToken = self.response?.sessionToken
                print("transaction successfull")
                let alert = UIAlertController(title: "", message: "Do you want to create an additional customer profile?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.additionalPaymentProfileHeadless()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("transaction error")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
            self.performSegue(withIdentifier: "showProfile", sender: self)
            
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
    
    func quickChipPaymentWithProfile(iConsentBefore:Bool) -> () {
        
        
        AnetProfileDemoUISettings.sharedInstance().readFromSettingsBundle()
        
        
        
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().createCustomerProfile(self.transactionObject(), forPaperReceiptCase: UserDefaults.standard.bool(forKey: "paperReceipt"), isConsentBefore: iConsentBefore, presenting: self, completionBlock:  {
            (response: AnetCustomerProfileTransactionResponse?, error : AnetCustomerProfileError?) -> Void  in
            if (error == nil) {
                print("profile successfull \(response?.customerProfileId) & \(response?.customerPaymentProfileIdList)")
            } else {
                print("profile error")
            }
        },transactionCompletionBlock: {
            (response: AnetEMVTransactionResponse?) -> Void  in
            print("Transaction successful")
        }, andCancelActionBlock: {
            print("Tapped cancel")
        })
    }
    
    func additionalPaymentWithProfileBefore(profileID:String) -> () {
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().createAdditionalPaymentProfile(self.transactionObject(), forPaperReceiptCase: UserDefaults.standard.bool(forKey: "paperReceipt"), isConsentBefore: true, withCustomerProfileID: profileID, presenting: self, completionBlock:  {
            (response: AnetCustomerProfileTransactionResponse?, error : AnetCustomerProfileError?) -> Void  in
            if (error == nil) {
                print("profile successfull")
                print("Customer Profile ID \(String(describing: response?.customerProfileId))")
                
            } else {
                print("profile error")
            }
        },transactionCompletionBlock: {
            (response: AnetEMVTransactionResponse?) -> Void  in
            print("Transaction successful")
        }, andCancelActionBlock: {
            print("Tapped cancel")
        })
    }
    
    func additionalPaymentWithProfileAfter(profileID:String) -> () {
        self.cardInteraction.text = "No activity in process."
        AnetEMVManager.sharedInstance().createAdditionalPaymentProfile(self.transactionObject(), forPaperReceiptCase: UserDefaults.standard.bool(forKey: "paperReceipt"), isConsentBefore: false, withCustomerProfileID: profileID, presenting: self, completionBlock:  {
            (response: AnetCustomerProfileTransactionResponse?, error : AnetCustomerProfileError?) -> Void  in
            if (error == nil) {
                print("profile successfull")
            } else {
                print("profile error")
            }
        },transactionCompletionBlock: {
            (response: AnetEMVTransactionResponse?) -> Void  in
            print("Transaction successful")
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
    
    func additionalPaymentProfileHeadless(){
        let alertController = UIAlertController(title: "Customer Profile ID", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Profile ID"
            textField.text = "1505168385"
        }
        let saveAction = UIAlertAction(title: "Continue", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.profileID = firstTextField.text
            self.isAdditionalProfile = true
            self.performSegue(withIdentifier: "showProfile", sender: self)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func additionalProfileClicked(isBefore:Bool){
        let alertController = UIAlertController(title: "Customer Profile ID", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Profile ID"
            textField.text = "1505168385"
        }
        let saveAction = UIAlertAction(title: "Continue", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if (isBefore) {
                self.additionalPaymentWithProfileBefore(profileID: firstTextField.text!)
            }
            else {
                self.additionalPaymentWithProfileAfter(profileID: firstTextField.text!)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deviceInfo(_ sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let firstAction: UIAlertAction = UIAlertAction(title: "Scan neay by devices", style: .cancel) { action -> Void in
            AnetEMVManager.sharedInstance().setConnectionMode(.bluetooth)
            
            AnetEMVManager.sharedInstance().deviceListBlock = {
                (deviceInfo : Any?, statusCode: AnetBTDeviceStatusCode) -> () in
                if let list = deviceInfo as? NSArray {
                    
                    for value in list {
                        if let object = value as? AnetBTObject {
                            print(object.name)

                        }
                    }
                }

            }
            AnetEMVManager.sharedInstance().scanBTDevicesList();
        }
        actionSheetController.addAction(firstAction)
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Device Info", style: .default) { action -> Void in
            
            self.cardInteraction.text = "Getting device info..."
            
            let aBlock:ReaderDeviceInfoBlock = {
                (deviceInfo : [AnyHashable:Any]) -> Void in
                print(deviceInfo)
                self.cardInteraction.text = "No activit in progress."
                
                let actionSheetController: UIAlertController = UIAlertController(title: "", message: deviceInfo.description, preferredStyle: .alert)
                let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                }
                actionSheetController.addAction(yesAction)
                self.present(actionSheetController, animated: true, completion: nil)
            }
            
            AnetEMVManager.sharedInstance().getAnyWhereReaderInfo(aBlock, presenting: self)
        }
        actionSheetController.addAction(secondAction)
        
        let thirdAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
        }
        actionSheetController.addAction(thirdAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func mail(_ sender: AnyObject) {
        let mailController:MFMailComposeViewController? = AnetEMVDemoUISettings.mail(to: "", withSubject: "", withBody: "", from: self)
        
        if (mailController != nil) {
            self.present(mailController!, animated: true, completion: nil)
        } else {
            let dialog = UIAlertController(title: "", message: "Please setup your e-mail account", preferredStyle: UIAlertController.Style.alert)
            let chargeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {(_) in
            }
            dialog.addAction(chargeAction)
            self.present(dialog, animated: true, completion: {
            })
        }
    }
    
    @IBAction func OTAUpdate(_ sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let firstAction: UIAlertAction = UIAlertAction(title: "Check for update", style: .cancel) { action -> Void in
            self.cardInteraction.text = "Checking for OTA updates..."
            
            AnetEMVManager.sharedInstance().check(forOTAUpdateIsTestReader: self.isTestReader.isOn, withOTAUpdateStatus: {
                (iFirmwareUpdate: Bool, iConfigurationUpdate : Bool, iErrorType: AnetOTAErrorCode, iErrorString : String?) -> Void in
                print("Check for update completed.")
                self.cardInteraction.text = "No activit in progress."
                
                let dialog = UIAlertController(title: "Firmware and Config status", message: "Firmware:\(iFirmwareUpdate) Config:\(iConfigurationUpdate) Error:\(iErrorType.rawValue)", preferredStyle: UIAlertController.Style.alert)
                let chargeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {(_) in
                }
                dialog.addAction(chargeAction)
                self.present(dialog, animated: true, completion: {
                })
            })
        }
        actionSheetController.addAction(firstAction)
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Update Headless", style: .default) { action -> Void in
            
            self.cardInteraction.text = "Updating OTA..."
            
            AnetEMVManager.sharedInstance().startOTAUpdateIsTestReader(self.isTestReader.isOn, withProgress: {
                (iProgress : Float, iUpdateType : OTAUpdateType) -> Void in
                print("Updating progress.")
                
                if (iUpdateType == OTAUpdateType.OTAFirmwareUpdate) {
                    self.cardInteraction.text = "Updating firmware...\(iProgress)%"
                } else {
                    self.cardInteraction.text = "Updating configuration...\(iProgress)%"
                }
            }, andOTACompletionBlock: {
                (iUpdateSuccessful: Bool, iErrorType: AnetOTAErrorCode, iErrorString : String?) -> Void in
                print("Update completed.")
                self.cardInteraction.text = "No activit in progress."
                
                let dialog = UIAlertController(title: "Update completed", message: "Status:\(iUpdateSuccessful) Error:\(iErrorType)", preferredStyle: UIAlertController.Style.alert)
                let chargeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {(_) in
                }
                dialog.addAction(chargeAction)
                self.present(dialog, animated: true, completion: {
                })
            })
        }
        actionSheetController.addAction(secondAction)
        
        let thirdAction: UIAlertAction = UIAlertAction(title: "Update", style: .default) { action -> Void in
            AnetEMVManager.sharedInstance().startOTAUpdate(fromPresenting: self, isTestReader: self.isTestReader.isOn)
        }
        actionSheetController.addAction(thirdAction)
        
        
        let fourthAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
        }
        actionSheetController.addAction(fourthAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func enteredAmount(_ sender: AnyObject)
    {
        let dialog = UIAlertController(title: "Please enter amount", message: "amount in USD, max 2 decimals", preferredStyle: UIAlertController.Style.alert)
        
        
        let chargeAction = UIAlertAction(title: "Pay", style: UIAlertAction.Style.default) {(_) in
            self.keyedINAmount = true
            self.pay(nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
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
            if self.amountTextField?.text != "" {
                let anItem:LineItemType = LineItemType()
                anItem.itemName = "KeyedIn Item"
                anItem.itemTaxable = false
                anItem.itemQuantity = "1"
                anItem.itemID = "KI"
                anItem.itemDescription = "goods"
                anItem.itemPrice = self.amountTextField?.text
                productArray.add(anItem)
                transactionAmount = Double((self.amountTextField?.text)!)!
            }
            
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
        else if segue.identifier == "showProfile" {
            let viewController: CreateProfileHeadlessViewController = segue.destination as! CreateProfileHeadlessViewController
            viewController.sessionToken = self.sessionToken
            viewController.mobileDeviceID = "454545454554"
            viewController.transactionID = self.response?.transId
            viewController.isAdditionalProfile = self.isAdditionalProfile
            viewController.profileID = self.profileID
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
    
    
    func getMerchantDetailsResponseSucceeded(_ response: GetMerchantDetailsResponse!) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: response.description, preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(yesAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

