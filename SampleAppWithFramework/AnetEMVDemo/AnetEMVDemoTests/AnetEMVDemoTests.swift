//
//  AnetEMVDemoTests.swift
//  AnetEMVDemoTests
//
//  Created by Pankaj Taneja on 10/27/15.
//  Copyright © 2015 Pankaj Taneja. All rights reserved.
//

import XCTest
@testable import AnetEMVDemo

class AnetEMVDemoTests: XCTestCase, AuthNetDelegate {
    
    var viewController:ViewController? = nil
    var addProductViewController:AddProductViewController? = nil
    var sessionToken:String? = nil
    var authnetInstance = AuthNet(environment: ENV_TEST);
    var mobileDeviceLoginRequest:MobileDeviceLoginRequest? = nil
    var asyncExpectation:XCTestExpectation? = nil
    var response:AnetEMVTransactionResponse? = nil
    var transactionDetailResponse:GetTransactionDetailsResponse? = nil
    var emvManager = AnetEMVManager.initWithCurrecyCode("840", terminalID: "", skipSignature: UserDefaults.standard.bool(forKey: "signature"), showReceipt: UserDefaults.standard.bool(forKey: "receipt"))
    var processCard = false

    override func setUp() {
        
        self.initializeObjects()
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func initializeObjects() -> () {
        self.authnetInstance = AuthNet(environment: ENV_TEST)
        self.authnetInstance?.delegate = self
        self.authnetInstance?.setLoggingEnabled(true)
        
        self.mobileDeviceLoginRequest = MobileDeviceLoginRequest()
        self.mobileDeviceLoginRequest?.anetApiRequest.merchantAuthentication.name = "mobilecnp1"
        self.mobileDeviceLoginRequest?.anetApiRequest.merchantAuthentication.password = "Authnet105"
        self.mobileDeviceLoginRequest?.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        
        self.emvManager = AnetEMVManager.initWithCurrecyCode("840", terminalID: "", skipSignature: UserDefaults.standard.bool(forKey: "signature"), showReceipt: UserDefaults.standard.bool(forKey: "receipt"))
    }
    
    func testEMVTransaction() -> () {
        self.initializeObjects()
        if self.sessionToken == nil {
            if (self.asyncExpectation != nil) {
                self.asyncExpectation = nil
            }
            self.asyncExpectation = expectation(description: "Login wait")
            self.authnetInstance?.mobileDeviceLoginRequest(self.mobileDeviceLoginRequest)
            self.authnetInstance?.delegate = self
            self.waitForExpectations(timeout: 50000, handler: {
                error in
                
                if self.sessionToken == nil {
                }
            })
        }
        
        let productArray:NSMutableArray = NSMutableArray()
        
        let anItem:LineItemType = LineItemType()
        anItem.itemName = "KeyedIn Item"
        anItem.itemTaxable = false
        anItem.itemQuantity = "1"
        anItem.itemID = "KI"
        anItem.itemDescription = "goods"
        anItem.itemPrice = self.randomDigitString()
        productArray.add(anItem)
        
        let aRequest = AnetEMVTransactionRequest()
        // uncomment this line to send the item information
        aRequest.lineItems = productArray
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = anItem.itemPrice
        
        let order = OrderType()
        order.orderDescription = "Order from Sample Application"
        aRequest.order = order
        
        // below values are optional
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.asyncExpectation = expectation(description: "long wait")
        AnetEMVManager.sharedInstance().startEMV(with: aRequest, presenting: (UIApplication.shared.keyWindow?.rootViewController)!, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            self.response = response
                        
            if (response?.responds(to: #selector(getter: AnetEMVTransactionResponse.isTransactionSuccessful)) == true && response?.isTransactionSuccessful == true && error == nil) {
                self.response = response
                print("transaction successfull")
                self.asyncExpectation?.fulfill()
                XCTAssertTrue((response?.isTransactionSuccessful)!, "testEMVTransaction Failed")
            } else {
                XCTAssertTrue(false, "testEMVTransaction Failed")
            }
        }, andCancelActionBlock: {
            print("Tapped cancel")
        }
        )
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testEMVTransaction timeout Failed")
            }
        })
    }
    
    func testQuickChipProcessCard() -> () {
        let controller = UIViewController()
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.emvManager.readQuickChipCardDataWithPredeterminedAmount(on: controller, transactionType:.payment, withCardInteractionProgressBlock: {
            (cardProgress : AnetEMVCardInteractionProgress) -> () in
            print(cardProgress)
        }, andCardIntercationCompletionBlock: {
            (isSuccess : Bool, error : AnetEMVError?) -> () in
            self.processCard = isSuccess
            self.asyncExpectation?.fulfill()
            XCTAssertTrue(isSuccess, "testQuickChipProcessCard Failed")
        })
        
        self.asyncExpectation = expectation(description: "long wait")
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if self.processCard == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout Failed")
            }
        })
    }
    
    func testDiscardProcessCard() -> () {
        let discarded = self.emvManager.discardQuickChipCardDataWithPredeterminedAmount()
        XCTAssert(discarded == false, "testDiscardProcessCard Success")
    }
    
    func testQuickChipProcessCardandDiscard() -> () {
        let controller = UIViewController()
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.emvManager.readQuickChipCardDataWithPredeterminedAmount(on: controller, transactionType:.payment, withCardInteractionProgressBlock: {
            (cardProgress : AnetEMVCardInteractionProgress) -> () in
            print(cardProgress)
        }, andCardIntercationCompletionBlock: {
            (isSuccess : Bool, error : AnetEMVError?) -> () in
            self.asyncExpectation?.fulfill()
        })
        
        self.asyncExpectation = expectation(description: "long wait")
        self.waitForExpectations(timeout: 50000, handler: {
            error in
        })
        
        let discarded = self.emvManager.discardQuickChipCardDataWithPredeterminedAmount()
        XCTAssertTrue(discarded, "testQuickChipProcessCardandDiscard Success")
    }
    
    func testQuickChipTransactionForNonPaperReceiptCase() -> () {
        self.initializeObjects()

        if self.sessionToken == nil {
            if (self.asyncExpectation != nil) {
                self.asyncExpectation = nil
            }
            self.asyncExpectation = expectation(description: "Login wait")
            self.authnetInstance?.mobileDeviceLoginRequest(self.mobileDeviceLoginRequest)
            self.authnetInstance?.delegate = self
            self.waitForExpectations(timeout: 50000, handler: {
                error in
                
                if self.sessionToken == nil {
                }
            })
        }
        
        let productArray:NSMutableArray = NSMutableArray()
        
        let anItem:LineItemType = LineItemType()
        anItem.itemName = "KeyedIn Item"
        anItem.itemTaxable = false
        anItem.itemQuantity = "1"
        anItem.itemID = "KI"
        anItem.itemDescription = "goods"
        anItem.itemPrice = self.randomDigitString()
        productArray.add(anItem)
        
        
        let aRequest = AnetEMVTransactionRequest()
        // uncomment this line to send the item information
        aRequest.lineItems = productArray
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = anItem.itemPrice
        
        let order = OrderType()
        order.orderDescription = "Order from Sample Application"
        aRequest.order = order
        
        // below values are optional
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.asyncExpectation = expectation(description: "long wait")
        self.emvManager.startQuickChip(with: aRequest, forPaperReceiptCase:false, presenting: (UIApplication.shared.keyWindow?.rootViewController)!, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            print("transaction successfull")
            self.response = response
            self.asyncExpectation?.fulfill()
            //XCTAssertTrue((response?.isTransactionSuccessful)!, "testQuickChipProcessCard Failed")
        }, andCancelActionBlock: {
            print("Tapped cancel")
            //XCTAssertTrue(false , "testQuickChipProcessCard Failed")
        })
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout")
            }
        })
        
        self.asyncExpectation = expectation(description: "long wait")

        let request:GetTransactionDetailsRequest = GetTransactionDetailsRequest()
        request.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        request.transId = self.response?.transId
        AuthNet.getInstance().delegate = self
        AuthNet.getInstance().getTransactionDetailsRequest(request)
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout")
            }
        })
        XCTAssertTrue(self.transactionDetailResponse?.transactionDetails.transactionStatus == "capturedPendingSettlement", "testQuickChipProcessCard Failed")
    }
    
    func testQuickChipTransactionForPaperReceiptCase() -> () {
        self.initializeObjects()
        
        if self.sessionToken == nil {
            if (self.asyncExpectation != nil) {
                self.asyncExpectation = nil
            }
            self.asyncExpectation = expectation(description: "Login wait")
            self.authnetInstance?.mobileDeviceLoginRequest(self.mobileDeviceLoginRequest)
            self.authnetInstance?.delegate = self
            self.waitForExpectations(timeout: 50000, handler: {
                error in
                
                if self.sessionToken == nil {
                }
            })
        }
        
        let productArray:NSMutableArray = NSMutableArray()
        
        let anItem:LineItemType = LineItemType()
        anItem.itemName = "KeyedIn Item"
        anItem.itemTaxable = false
        anItem.itemQuantity = "1"
        anItem.itemID = "KI"
        anItem.itemDescription = "goods"
        anItem.itemPrice = self.randomDigitString()
        productArray.add(anItem)
        
        
        let aRequest = AnetEMVTransactionRequest()
        // uncomment this line to send the item information
        aRequest.lineItems = productArray
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = anItem.itemPrice
        
        let order = OrderType()
        order.orderDescription = "Order from Sample Application"
        aRequest.order = order
        
        // below values are optional
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.asyncExpectation = expectation(description: "long wait")
        self.emvManager.startQuickChip(with: aRequest, forPaperReceiptCase:true, presenting: (UIApplication.shared.keyWindow?.rootViewController)!, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            print("transaction successfull")
            self.response = response
            self.asyncExpectation?.fulfill()
            //XCTAssertTrue((response?.isTransactionSuccessful)!, "testQuickChipProcessCard Failed")
        }, andCancelActionBlock: {
            print("Tapped cancel")
            //XCTAssertTrue(false , "testQuickChipProcessCard Failed")
        })
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout")
            }
        })
        
        self.asyncExpectation = expectation(description: "long wait")
        
        let request:GetTransactionDetailsRequest = GetTransactionDetailsRequest()
        request.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        request.transId = self.response?.transId
        AuthNet.getInstance().delegate = self
        AuthNet.getInstance().getTransactionDetailsRequest(request)
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout")
            }
        })
        
        XCTAssertTrue(self.transactionDetailResponse?.transactionDetails.transactionStatus == "authorizedPendingCapture", "testQuickChipProcessCard Failed")
    }
    
    func testQuickChipTransactionWithTipAmount() -> () {
        self.initializeObjects()
        
        if self.sessionToken == nil {
            if (self.asyncExpectation != nil) {
                self.asyncExpectation = nil
            }
            self.asyncExpectation = expectation(description: "Login wait")
            self.authnetInstance?.mobileDeviceLoginRequest(self.mobileDeviceLoginRequest)
            self.authnetInstance?.delegate = self
            self.waitForExpectations(timeout: 50000, handler: {
                error in
                
                if self.sessionToken == nil {
                }
            })
        }
        
        let productArray:NSMutableArray = NSMutableArray()
        
        let anItem:LineItemType = LineItemType()
        anItem.itemName = "KeyedIn Item"
        anItem.itemTaxable = false
        anItem.itemQuantity = "1"
        anItem.itemID = "KI"
        anItem.itemDescription = "goods"
        anItem.itemPrice = self.randomDigitString()
        productArray.add(anItem)
        
        
        let aRequest = AnetEMVTransactionRequest()
        // uncomment this line to send the item information
        aRequest.lineItems = productArray
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = anItem.itemPrice
        
        let order = OrderType()
        order.orderDescription = "Order from Sample Application"
        aRequest.order = order
        
        // below values are optional
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.asyncExpectation = expectation(description: "long wait")
            
        self.emvManager.startQuickChip(with: aRequest, tipAmount: ((UserDefaults.standard.value(forKey: "tipAmount")!) as! NSString) as String, presenting: (UIApplication.shared.keyWindow?.rootViewController)!, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            print("transaction successfull")
            self.response = response
            self.asyncExpectation?.fulfill()
            //XCTAssertTrue((response?.isTransactionSuccessful)!, "testQuickChipProcessCard Failed")
        }, andCancelActionBlock: {
            print("Tapped cancel")
            //XCTAssertTrue(false , "testQuickChipProcessCard Failed")
        })
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout")
            }
        })
    }

    func testQuickChipTransactionWithTipOptions() -> () {
        self.initializeObjects()
        
        if self.sessionToken == nil {
            if (self.asyncExpectation != nil) {
                self.asyncExpectation = nil
            }
            self.asyncExpectation = expectation(description: "Login wait")
            self.authnetInstance?.mobileDeviceLoginRequest(self.mobileDeviceLoginRequest)
            self.authnetInstance?.delegate = self
            self.waitForExpectations(timeout: 50000, handler: {
                error in
                
                if self.sessionToken == nil {
                }
            })
        }
        
        let productArray:NSMutableArray = NSMutableArray()
        
        let anItem:LineItemType = LineItemType()
        anItem.itemName = "KeyedIn Item"
        anItem.itemTaxable = false
        anItem.itemQuantity = "1"
        anItem.itemID = "KI"
        anItem.itemDescription = "goods"
        anItem.itemPrice = self.randomDigitString()
        productArray.add(anItem)
        
        
        let aRequest = AnetEMVTransactionRequest()
        // uncomment this line to send the item information
        aRequest.lineItems = productArray
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = anItem.itemPrice
        
        let order = OrderType()
        order.orderDescription = "Order from Sample Application"
        aRequest.order = order
        
        // below values are optional
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.asyncExpectation = expectation(description: "long wait")
        
        let tipOptions : NSMutableArray? = []
        tipOptions?.add(UserDefaults.standard.value(forKey: "tipOption1")!)
        tipOptions?.add(UserDefaults.standard.value(forKey: "tipOption2")!)
        tipOptions?.add(UserDefaults.standard.value(forKey: "tipOption3")!)
        
        self.emvManager.startQuickChip(with: aRequest, tipOptions: (tipOptions! as NSArray) as! [Any], presenting: (UIApplication.shared.keyWindow?.rootViewController)!, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            print("transaction successfull")
            self.response = response
            self.asyncExpectation?.fulfill()
            //XCTAssertTrue((response?.isTransactionSuccessful)!, "testQuickChipProcessCard Failed")
        }, andCancelActionBlock: {
            print("Tapped cancel")
            //XCTAssertTrue(false , "testQuickChipProcessCard Failed")
        })
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout")
            }
        })
        
        self.asyncExpectation = expectation(description: "long wait")
        
        let request:GetTransactionDetailsRequest = GetTransactionDetailsRequest()
        request.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        request.transId = self.response?.transId
        AuthNet.getInstance().delegate = self
        AuthNet.getInstance().getTransactionDetailsRequest(request)
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout")
            }
        })
        XCTAssertTrue(self.transactionDetailResponse?.transactionDetails.transactionStatus == "capturedPendingSettlement", "testQuickChipProcessCard Failed")
    }

    func testProcessCardAndQuickChipTransaction() -> () {
        self.initializeObjects()

        if self.sessionToken == nil {
            if (self.asyncExpectation != nil) {
                self.asyncExpectation = nil
            }
            self.asyncExpectation = expectation(description: "Login wait")
            self.authnetInstance?.mobileDeviceLoginRequest(self.mobileDeviceLoginRequest)
            self.authnetInstance?.delegate = self
            self.waitForExpectations(timeout: 50000, handler: {
                error in
            })
        }
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.emvManager.readQuickChipCardDataWithPredeterminedAmount(on: (UIApplication.shared.keyWindow?.rootViewController)!, transactionType:.payment, withCardInteractionProgressBlock: {
            (cardProgress : AnetEMVCardInteractionProgress) -> () in
            print(cardProgress)
        }, andCardIntercationCompletionBlock: {
            (isSuccess : Bool, error : AnetEMVError?) -> () in
            self.asyncExpectation?.fulfill()
        })
        
        self.asyncExpectation = expectation(description: "long wait")
        self.waitForExpectations(timeout: 50000, handler: {
            error in
        })
        
        let productArray:NSMutableArray = NSMutableArray()
        
        let anItem:LineItemType = LineItemType()
        anItem.itemName = "KeyedIn Item"
        anItem.itemTaxable = false
        anItem.itemQuantity = "1"
        anItem.itemID = "KI"
        anItem.itemDescription = "goods"
        anItem.itemPrice = self.randomDigitString()
        productArray.add(anItem)
        
        
        let aRequest = AnetEMVTransactionRequest()
        // uncomment this line to send the item information
        aRequest.lineItems = productArray
        aRequest.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        aRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        aRequest.amount = anItem.itemPrice
        
        let order = OrderType()
        order.orderDescription = "Order from Sample Application"
        aRequest.order = order
        
        // below values are optional
        aRequest.retail = TransRetailInfoType()
        aRequest.retail.marketType = "2"
        aRequest.retail.deviceType = "7"
        
        if (self.asyncExpectation != nil) {
            self.asyncExpectation = nil
        }
        self.asyncExpectation = expectation(description: "long wait")
        self.emvManager.startQuickChip(with: aRequest, forPaperReceiptCase:false, presenting: (UIApplication.shared.keyWindow?.rootViewController)!, completionBlock: {
            (response: AnetEMVTransactionResponse?, error : AnetEMVError?) -> Void  in
            print("transaction successfull")
            self.response = response
            self.asyncExpectation?.fulfill()
            XCTAssertTrue((response?.isTransactionSuccessful)!, "testQuickChipProcessCard Failed")
        }, andCancelActionBlock: {
            print("Tapped cancel")
            XCTAssertTrue(false , "testQuickChipProcessCard Failed")
        })
        
        self.waitForExpectations(timeout: 50000, handler: {
            error in
            
            if (self.response?.isTransactionSuccessful) == false {
                XCTAssertTrue(false, "testQuickChipProcessCard timeout Failed")
            }
        })
    }
    
    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
    func getTransactionDetailsSucceeded(_ response: GetTransactionDetailsResponse!) {
        self.transactionDetailResponse = response
        self.asyncExpectation?.fulfill()
        self.asyncExpectation = nil
    }
    
    func mobileDeviceLoginSucceeded(_ response: MobileDeviceLoginResponse) {
        self.sessionToken = response.sessionToken
        print(self.sessionToken!)
        
        if self.sessionToken != nil {
            self.asyncExpectation?.fulfill()
            self.asyncExpectation = nil
        }
    }
    
    func requestFailed(_ response: AuthNetResponse!) {
        self.asyncExpectation?.fulfill()
        print(response)
    }
    
    func connectionFailed(_ response: AuthNetResponse!) {
        self.asyncExpectation?.fulfill()
        print(response)

    }
    
    func randomDigitString() -> String {
        let i = arc4random_uniform(50)
        return String(i)
    }
}
