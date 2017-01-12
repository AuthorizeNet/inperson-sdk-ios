# Authorize.Net In-Person iOS SDK Integration Guide

The Authorize.Net In-Person SDK provides a Semi-Integrated Solution for EMV payment processing. 

The merchant's app invokes this SDK to complete an EMV transaction. The SDK handles the complex EMV workflow and securely submits the EMV transaction to Authorize.Net for processing. The merchant's application never touches any EMV data at any point.
  
# Building an MPoS Application

##Overview

The Authorize.Net SDK provides support for five main feature areas of an MPoS solution:

1. Mobile Device Login to Authorize.net gateway
2. EMV Transaction Processing
3. Non-EMV Transaction Processing
4. Customer Email Receipt
5. Transaction Reporting

##Include the AnetEMVSDK framework into the merchant application

1.	Include the In-Person iOS SDK framework in the merchantís application. 	Use Xcode to include the _AnetEMVSdk.framework_ file under Embedded Binaries. The merchant application must log in and initialize a valid Merchant object with the `password` field.

2.	Include additional frameworks and settings.

    a)	Include the _libxml2.2.tbd_ file in the app. 

    b)	Navigate to **Build Settings > Search Paths > Header Search Paths**.

    c)	Enter the following settings: `Iphoneos/usr/include/libxml2`.

    d)  This is required only if you are including SDK as static Library. Please link the following modules in your project
        AudioToolbox.framework
        CoreAudio.framework
        MediaPlayer.framework
        AVFoundation.framework
        CoreBluetooth.framework

3.	Copy Bundle Resources.

    a)	Include the `AnetEMVStoryBoard.storyboard` and `eject.mp3` fields from the _AnetEMVSdk.framework_ file in the application. If you included them correctly, you should be able to see Target > Build Phases > Copy Bundle Resources.

4.	If the application is developed in the Swift language, the application needs to have a bridging header file because the _AnetEMVSdk.framework_ file is based on Objective C.

### Initialize the SDK with required environment, AnetEMVSDK can be used for two different environments: SANBOX and LIVE

    1. Initialize the singleton with the AUTHNET_ENVIRONMENT setting (dictating whether to access the
       Sandbox environment or the Live environment) either at the ApplicationDelegate or in the initial
       UIViewController.  Make sure to #import "AuthNet.h".

       [AuthNet authNetWithEnvironment:ENV_TEST];

## Mobile Device Login to Authorize.net gateway

/**
* Perform mobileDeviceLoginRequest on the AIM API.
* @param r The request to send.
*/
- (void) mobileDeviceLoginRequest:(MobileDeviceLoginRequest *)r;

Perform an mobileDeviceLoginRequest request.  Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class. Application must populate sessionToken generated from login request in all the subsequent api calls to Authorize.net gateway.

*
To ensure maximum security the user should "logout" from their session and subsequently the application should use this method to terminate the mobile API session.*

/**
* Perform logoutRequest on the AIM API.
* @param r The request to send.
*/
- (void) LogoutRequest:(LogoutRequest *)r;

Perform an LogoutRequest request.  Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call call of AuthNet class.

## EMV Transaction Processing

### EMV Transaction Operational Workflow

1.	From POS application, select Pay By Card.

2.	Attached the card reader to the device if it is not already attached.

3.	Insert a card with an EMV chip and do not remove the card until the transaction is complete. Alternatively, swipe a non-EMV card.

4.	If only a single compatible payment app resides on the chip, the payment app is selected automatically. If prompted, select the payment app. For example, Visa credit or MasterCard debit.

5.	Confirm the amount.

6.	If at any time the user cancels the transaction, the transaction is cancelled. 

### Using the SDK to Create and Submit an EMV Transaction

1.	Initialize the _AnetEMVSdk.framework_ file.

    a)	Initialize _AnetEMVManager_ with US Currency and terminal ID.  Refer to the _AnetEMVManager.h_ file and the sample app for more details. Parameters include `skipSignature` and `showReceipt`.

    b)	`initWithCurrencyCode: terminalID: skipSignature: showReceipt`

    c)	Instantiate `AnetEMVTransactionRequest` and populate the required values, similar to `AuthNetRequest` for regular transactions If you are using swift to build your application then please don't static method provided by SDK to initialize the objects. Also, `AnetEMVSdk` requires the app to provide `presentingViewController`, a completion block to get the response from the SDK about the submitted transaction and cancelation block to execute the cancel action inside the SDK. 

    d)	The `EMVTransactionType` should be mentioned in the `AnetEMVTransactionRequest`. Refer to the _AnetEMVTransactionRequest.h_ file for all the available enums to populate.

    e)	After creating all the required objects, call the following method AnetEMVManager and submit the transaction. 

`[startEMVWithTransactionRequest:presentingViewController:completionBlock:andCancelActionBlock]`

**Note:** Only Goods, Services, and Payment are supported for the `TransactionType` field.

### Success

On success, the completion block should provide the `AnetEMVTransactionResponse` object with required information about the transaction response and isTransactionSuccessful will be true. Refer to _AnetEMVTransactionResponse.h_ for more details. `emvResponse` has `tlvdata` and all the tags as part of the response. 

### Errors

In case of a transaction error, the _AnetEMVTransactionResponse_ object should have the error details. 

In case of other errors, the _AnetEMVError_ object should be able to provide the details. 

Refer to _AnetEMVError.h_ for more details. Also refer to _AnetEMVManager.h_ for _ANETEmvErrorCode_ enum for more details on the errors. 

### Configuring the UI

You can configure the UI of the In-Person SDK to better match the UI of the merchant application.  The merchant application must initialize these values before using the SDK.  If no values are set or null is set for any of the parameters, the SDK defaults to its original theme.
  
The merchant application can configure the following UI parameters:

* Background Color

* Text Font Color

* Button Font Color

* Button Background Color

* Banner Image

* Banner Background Color

* Background Image

### Code Samples

The `AnetEMVUISettings` field exposes the properties to set:

**Background Color**  
`AnetEMVUISettings.sharedUISettings ().backgroundColor = [UIColor blueColor];`

**Text Font Color**  
`AnetEMVUISettings.sharedUISettings ().textFontColor = [UIColor blackColor];`

**Button Font Color**  
`AnetEMVUISettings.sharedUISettings ().buttonTextColor = [UIColor blueColor];`

**Button Background Color**  
`AnetEMVUISettings.sharedUISettings ().buttonColor = [UIColor blueColor];`

**Banner Image**  
`AnetEMVUISettings.sharedUISettings ().logoImage = [UIImage imageNamed:@îANetLogo.pngî];`

**Banner Background Color**  
`AnetEMVUISettings.sharedUISettings ().bannerBackgroundColor = [UIColor yellowColor];`

**Background Image**  
`AnetEMVUISettings.sharedUISettings ().backgroundImage = [UIImage imageNamed:@îANetBgImage.pngî];`

## Non-EMV Transaction Processing

The SDK includes APIs for each of the supported API methods in AuthNet class: 

1. AUTH
2. PRIOR_AUTH_CAPTURE
3. CAPTURE
4. VOID
5. CREDIT
6. CAPTURE_ONLY
7. Unlinked CREDIT

/**
* Perform AUTH transaction with request.
* @param r The request to send.
*/
- (void) authorizeWithRequest:(CreateTransactionRequest *)r;

Perform a AUTH request. Application will receive delegate call back 
for successful, failed, and canceled transaction flows by setting 
the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform AUTH_CAPTURE transaction with request.
* @param r The request to send.
*/
- (void) purchaseWithRequest:(CreateTransactionRequest *)r;

Perform a AUTH_CAPTURE request.  Application will receive delegate call 
back for successful, failed, and canceled transaction flows by setting 
the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform PRIOR_AUTH_CAPTURE transaction with request.
* @param r The request to send.
*/
- (void) captureWithRequest:(CreateTransactionRequest *)r;

Perform a PRIOR_AUTH_CAPTURE request.  Application can still receive delegate call 
back for successful, failed, and canceled transaction flows by setting 
the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform CAPTURE_ONLY transaction with request.
* NOTE: Request must include in the request the authCode (x_auth_code).
* @param r The request to send.
*/
- (void) captureWithRequest:(CreateTransactionRequest *)r;

Perform a PRIOR_AUTH_CAPTURE request.  Application can still receive delegate 
call back for successful, failed, and canceled transaction flows by setting the 
UIViewController with the setDelegate call of AuthNet class.

/**
* Perform VOID transaction with request.
* @param r The request to send.
*/
- (void) voidWithRequest:(CreateTransactionRequest *)r;

Perform a VOID request.  Application can still receive delegate call 
back for successful, failed, and canceled transaction flows by 
setting the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform CREDIT transaction with request.
* @param r The request to send.
*/
- (void) creditWithRequest:(CreateTransactionRequest *)r;

Perform a CREDIT request.  Application can still receive delegate call back for successful, 
failed, and canceled transaction flows by setting the UIViewController with 
the setDelegate call of AuthNet class.

/**
* Perform unlinked CREDIT transaction with request.
* NOTE: Unlinked Credit request must not have an transaction id (x_trans_id) value.
* @param r The request to send.
*/
- (void) unlinkedCreditWithRequest:(CreateTransactionRequest *)r;

Perform an unlinked CREDIT request without using the UIButton call 
back mechanism.  Application can still receive delegate call back for 
successful, failed, and canceled transaction flows by setting the UIViewController 
with the setDelegate call of AuthNet class.


## Customer Email Receipt

/**
* Perform sendCustomerTransactionReceiptRequest on the AIM API.
* @param r The request to send.
*/
- (void) sendCustomerTransactionReceiptRequest:(SendCustomerTransactionReceiptRequest *) r;

Perform an sendCustomerTransactionReceiptRequest request. Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class.


## Reporting

/**
* Perform getSettledBatchListRequest on the Reporting API.
* @param r The reporting request to send.
*/
- (void) getBatchStatisticsRequest:(GetBatchStatisticsRequest *) r;

Perform an getBatchStatisticsRequest request. Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform getSettledBatchListRequest on the Reporting API.
* @param r The reporting request to send.
*/
- (void) getSettledBatchListRequest:(GetSettledBatchListRequest *) r;

Perform an getSettledBatchListRequest request. Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform getTransactionDetailsRequest on the Reporting API.
* @param r The reporting request to send.
*/
- (void) getTransactionDetailsRequest:(GetTransactionDetailsRequest *) r;

Perform an getTransactionDetailsRequest request. Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform getTransactionDetailsRequest on the Reporting API.
* @param r The reporting request to send.
*/
- (void) getTransactionListRequest:(GetTransactionListRequest *) r;

Perform an getTransactionListRequest request. Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class.

/**
* Perform getUnsettledTransactionListRequest on the Reporting API.
* @param r The reporting request to send.
*/
- (void) getUnsettledTransactionListRequest:(GetUnsettledTransactionListRequest *) r;

Perform an getUnsettledTransactionListRequest request. Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class.

#Code Snippets

1) Initialize the singleton with the AUTHNET_ENVIRONMENT setting (dictating whether to access the
    Test environment or the Live environment) either at the ApplicationDelegate or in the initial
    UIViewController.  Make sure to #import "AuthNet.h".

    [AuthNet authNetWithEnvironment:ENV_TEST];

2) Login to the gateway

    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = <USERNAME>;
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = <PASSWORD>;
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>

    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
    
    Callback for the successful login
    - (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response {
        sessionToken = [response.sessionToken retain];
    };


3) Create Non-EMV transaction 

    a) Purchase transaction
        CreditCardType *creditCardType = [CreditCardType creditCardType];
        creditCardType.cardNumber = @"4111111111111111";
        creditCardType.cardCode = @"100";
        creditCardType.expirationDate = @"1222";

        PaymentType *paymentType = [PaymentType paymentType];
        paymentType.creditCard = creditCardType;

        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeTax.amount = @"0";
        extendedAmountTypeTax.name = @"Tax";

        ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeShipping.amount = @"0";
        extendedAmountTypeShipping.name = @"Shipping";

        LineItemType *lineItem = [LineItemType lineItem];
        lineItem.itemName = @"AuthCaptureProduct";
        lineItem.itemDescription = @"AuthCaptureProductDescription";
        lineItem.itemQuantity = @"1";
        lineItem.itemPrice = [NSString stringWithFormat:@"%d", [self randomDigit]];
        lineItem.itemID = @"1";

        TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
        requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
        requestType.amount = lineItem.itemPrice;
        requestType.payment = paymentType;
        requestType.tax = extendedAmountTypeTax;
        requestType.shipping = extendedAmountTypeShipping;

        CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = AUTH_CAPTURE;
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = deviceId;
        request.anetApiRequest.merchantAuthentication.sessionToken = self.loginResponse.sessionToken;

        AuthNet *an = [AuthNet getInstance];
        [an setDelegate:self];
        [an purchaseWithRequest:request];

    b) Auth only transaction
        CreditCardType *creditCardType = [CreditCardType creditCardType];
        creditCardType.cardNumber = @"4111111111111111";
        creditCardType.cardCode = @"100";
        creditCardType.expirationDate = @"1222";

        PaymentType *paymentType = [PaymentType paymentType];
        paymentType.creditCard = creditCardType;

        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeTax.amount = @"0";
        extendedAmountTypeTax.name = @"Tax";

        ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeShipping.amount = @"0";
        extendedAmountTypeShipping.name = @"Shipping";

        LineItemType *lineItem = [LineItemType lineItem];
        lineItem.itemName = @"AuthOnlyProduct";
        lineItem.itemDescription = @"AuthOnlyProductDescription";
        lineItem.itemQuantity = @"1";
        lineItem.itemPrice = [NSString stringWithFormat:@"%d", [self randomDigit]];
        lineItem.itemID = @"1";

        TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
        requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
        requestType.amount = lineItem.itemPrice;
        requestType.payment = paymentType;
        requestType.tax = extendedAmountTypeTax;
        requestType.shipping = extendedAmountTypeShipping;

        CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = AUTH_ONLY;
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = deviceId;
        request.anetApiRequest.merchantAuthentication.sessionToken = self.loginResponse.sessionToken;

        AuthNet *an = [AuthNet getInstance];
        [an setDelegate:self];
        [an authorizeWithRequest:request];

    c) Capture the transaction
        CreditCardType *creditCardType = [CreditCardType creditCardType];
        creditCardType.cardNumber = @"4111111111111111";
        creditCardType.cardCode = @"100";
        creditCardType.expirationDate = @"1222";

        PaymentType *paymentType = [PaymentType paymentType];
        paymentType.creditCard = creditCardType;

        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeTax.amount = @"0";
        extendedAmountTypeTax.name = @"Tax";

        ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeShipping.amount = @"0";
        extendedAmountTypeShipping.name = @"Shipping";

        LineItemType *lineItem = [LineItemType lineItem];
        lineItem.itemName = @"CaptureOnlyProduct";
        lineItem.itemDescription = @"CaptureOnlyProductDescription";
        lineItem.itemQuantity = @"1";
        lineItem.itemPrice = [NSString stringWithFormat:@"%d", [self randomDigit]];
        lineItem.itemID = @"1";

        TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
        requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
        requestType.amount = lineItem.itemPrice;
        requestType.payment = paymentType;
        requestType.tax = extendedAmountTypeTax;
        requestType.shipping = extendedAmountTypeShipping;
        requestType.authCode = @"ABC123";

        CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = CAPTURE_ONLY;
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = deviceId;
        request.anetApiRequest.merchantAuthentication.sessionToken = self.loginResponse.sessionToken;

        AuthNet *an = [AuthNet getInstance];
        [an setDelegate:self];
        [an captureOnlyWithRequest:request];

    d) Auth and Capture the transaction
        CreditCardType *creditCardType = [CreditCardType creditCardType];
        creditCardType.cardNumber = @"4111111111111111";
        creditCardType.cardCode = @"100";
        creditCardType.expirationDate = @"1222";

        PaymentType *paymentType = [PaymentType paymentType];
        paymentType.creditCard = creditCardType;

        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeTax.amount = @"0";
        extendedAmountTypeTax.name = @"Tax";

        ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeShipping.amount = @"0";
        extendedAmountTypeShipping.name = @"Shipping";

        LineItemType *lineItem = [LineItemType lineItem];
        lineItem.itemName = @"AuthCaptureProduct";
        lineItem.itemDescription = @"AuthCaptureProductDescription";
        lineItem.itemQuantity = @"1";
        lineItem.itemPrice = [NSString stringWithFormat:@"%d", [self randomDigit]];
        lineItem.itemID = @"1";

        TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
        requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
        requestType.amount = lineItem.itemPrice;
        requestType.payment = paymentType;
        requestType.tax = extendedAmountTypeTax;
        requestType.shipping = extendedAmountTypeShipping;

        CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = AUTH_CAPTURE;
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = deviceId;
        request.anetApiRequest.merchantAuthentication.sessionToken = self.loginResponse.sessionToken;

        AuthNet *an = [AuthNet getInstance];
        [an setDelegate:self];
        [an purchaseWithRequest:request];

    e) Capture the transaction which is previously authorised 
        CreditCardType *creditCardType = [CreditCardType creditCardType];
        creditCardType.cardNumber = @"4111111111111111";
        creditCardType.cardCode = @"100";
        creditCardType.expirationDate = @"1222";

        PaymentType *paymentType = [PaymentType paymentType];
        paymentType.creditCard = creditCardType;

        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeTax.amount = @"0";
        extendedAmountTypeTax.name = @"Tax";

        ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeShipping.amount = @"0";
        extendedAmountTypeShipping.name = @"Shipping";

        LineItemType *lineItem = [LineItemType lineItem];
        lineItem.itemName = @"PriorAuthCaptureProduct";
        lineItem.itemDescription = @"PriorAuthCaptureProductDescription";
        lineItem.itemQuantity = @"1";
        lineItem.itemPrice = [NSString stringWithFormat:@"%d", [self randomDigit]];
        lineItem.itemID = @"1";

        TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
        requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
        requestType.amount = lineItem.itemPrice;
        requestType.payment = paymentType;
        requestType.tax = extendedAmountTypeTax;
        requestType.shipping = extendedAmountTypeShipping;

        CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = AUTH_ONLY;
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = deviceId;
        request.anetApiRequest.merchantAuthentication.sessionToken = self.loginResponse.sessionToken;

        AuthNet *an = [AuthNet getInstance];
        [an setDelegate:self];

        self.testExpectation = [self expectationWithDescription:@"Long wait"];
        [an authorizeWithRequest:request];
        [self waitForExpectationsWithTimeout:50000 handler:^ (NSError *anError) {

        }];

        requestType = [TransactionRequestType transactionRequest];
        requestType.refTransId = self.transactionResponse.transactionResponse.transId;
        requestType.payment = nil;
        requestType.amount = lineItem.itemPrice;

        request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = PRIOR_AUTH_CAPTURE;
        request.anetApiRequest.merchantAuthentication.mobileDeviceId = deviceId;
        request.anetApiRequest.merchantAuthentication.sessionToken = self.loginResponse.sessionToken;

        an = [AuthNet getInstance];
        [an setDelegate:self];
        [an captureWithRequest:request];

        Callback for the non-emv transaction request request 

        - (void) paymentSucceeded:(CreateTransactionResponse *) response {
        // Handle payment success
        }

4) Void the transaction

    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];

    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    
    request.transactionRequest.refTransId = self.transactionDetails.transId;
    request.transactionRequest.amount = self.transactionDetails.settleAmount;
    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
    // Omit payment data for VOIDs
    request.transactionRequest.payment = nil;

    [an voidWithRequest:request];

    Callback for the Void request 

    - (void) paymentSucceeded:(CreateTransactionResponse *) response {
        // Handle payment success
    }

5) Refund the transaction
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
    request.transactionRequest.refTransId = self.transactionDetails.transId;
    request.transactionRequest.amount = self.transactionDetails.settleAmount;
    request.transactionRequest.payment = [PaymentType paymentType];
    request.transactionRequest.payment.creditCard.cardNumber = transactionDetails.payment.creditCard.cardNumber;
    request.transactionRequest.payment.creditCard.expirationDate = transactionDetails.payment.creditCard.expirationDate;

    [an creditWithRequest:request];

    Callback for the Refund request 

    - (void) paymentSucceeded:(CreateTransactionResponse *) response {
        // Handle payment success
    }

6) GetSettledBatchListRequest     

    GetSettledBatchListRequest *r = [GetSettledBatchListRequest getSettlementBatchListRequest];
    r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
    [[AuthNet getInstance] setDelegate:self];
    [[AuthNet getInstance] getSettledBatchListRequest:r];

    Callback

    - (void) getSettledBatchListSucceeded:(GetSettledBatchListResponse *)response {
    }

7) GetTransactionDetailsRequest     

    GetTransactionDetailsRequest *r = [GetTransactionDetailsRequest getTransactionDetailsRequest];
    r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
    r.transId = transID;
    [[AuthNet getInstance] setDelegate:self];
    [[AuthNet getInstance] getTransactionDetailsRequest:r];

    Callback
    - (void) getTransactionDetailsSucceeded:(GetTransactionDetailsResponse *)response {
    }

8) GetTransactionListRequest
    
    GetTransactionListRequest *r = [GetTransactionListRequest getTransactionListRequest];
    r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;

    // Batch Lists are from oldest to newest so use last object.
    BatchDetailsType *b = [self.batchList lastObject];
    r.batchId = [NSString stringWithString:b.batchId];
    [self.batchList removeLastObject];
    [[AuthNet getInstance] setDelegate:self];
    [[AuthNet getInstance] getTransactionListRequest:r];

    // Callback
    - (void) getTransactionListSucceeded:(GetTransactionListResponse *)response {
    }

9) GetUnsettledTransactionListRequest     
    
    GetUnsettledTransactionListRequest *r = [GetUnsettledTransactionListRequest getUnsettledTransactionListRequest];
    r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
    [[AuthNet getInstance] setDelegate:self];
    [[AuthNet getInstance] getUnsettledTransactionListRequest:r];

    // Callback
    - (void) getUnsettledTransactionListSucceeded:(GetUnsettledTransactionListResponse *)response {
    }

10) SendCustomerTransactionReceiptRequest     

    SendCustomerTransactionReceiptRequest *r = [SendCustomerTransactionReceiptRequest sendCustomerTransactionReceiptRequest];
    r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
    r.customerEmail = self.currentEmail;
    r.transId = self.transactionId;

    SettingType *s = [SettingType settingType];

    s.name = @"footerEmailReceipt";

    // Append Transaction Type:  Purchase
    s.value = [NSString stringWithFormat:@"%@&emsp;&emsp;&emsp;&emsp;Purchase<br/>", kTransactionType];

    // Append Payment Method:
    s.value = [s.value stringByAppendingFormat:@"%@&emsp;&emsp;&emsp;&emsp;%@&nbsp;%@<br/><br/>", kPaymentMethod, self.createTransactionResponse.transactionResponse.accountType, self.createTransactionResponse.transactionResponse.accountNumber];
    // Append Boiler plate
    s.value = [s.value stringByAppendingFormat:@"%@",kBoilerPlateCopy];

    [r.emailSettings addObject:s];

    s = [SettingType settingType];

    s.name = @"headerEmailReceipt";
    s.value = [NSString stringWithFormat:@"%@<br/>%@<br/>%@, %@ %@<br/>%@<br/>%@",
    merchantName ? merchantName : @"",
    merchantAddress ? merchantAddress : @"",
    merchantCity ? merchantCity : @"",
    merchantState ? merchantState : @"",
    merchantZip ? merchantZip : @"",
    merchantPhone ? merchantPhone : @"",
    merchantEmailAddress ? merchantEmailAddress : @""];
    [r.emailSettings addObject:s];

    // Set delegate and send request
    [[AuthNet getInstance] setDelegate:self];
    [[AuthNet getInstance] sendCustomerTransactionReceiptRequest:r];

    // Callback
    - (void) sendCustomerTransactionReceiptSucceeded:(SendCustomerTransactionReceiptResponse *)response {
    }

11) Logout request 
    
    LogoutRequest *r = [LogoutRequest logoutRequest];
    r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
    [[AuthNet getInstance] setDelegate:self];
    [[AuthNet getInstance] LogoutRequest:r];

    // Callback
    - (void) logoutSucceeded:(LogoutResponse *)response {
    }

## Error  Codes
You can view these error messages at our [Reason Response Code](http://developer.authorize.net/api/reference/responseCodes.html) by entering the Response Reason Code into the tool. There will be additional information and suggestions there.

Field Order	| Response Code | Response Reason Code | Text
--- | --- | --- | ---
3 | 2 | 355	| An error occurred while parsing the EMV data.
3 | 2 | 356	| EMV-based transactions are not currently supported for this processor and card type.
3 | 2 | 357	| Opaque Descriptor is required.
3 | 2 | 358	| EMV data is not supported with this transaction type.
3 | 2 | 359	| EMV data is not supported with this market type.
3 | 2 | 360	| An error occurred while decrypting the EMV data.
3 | 2 | 361	| The EMV version is invalid.
3 | 2 | 362	| x_emv_version is required.
