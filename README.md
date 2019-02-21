# Authorize.Net In-Person iOS SDK Integration Guide

The Authorize.Net In-Person SDK provides a Semi-Integrated Solution for EMV payment processing. For an overview of the semi-integrated environment and the transaction workflow within that environment, see our [Authorize.Net In-Person SDK Overview](http://developer.authorize.net/api/reference/features/in-person.html). This SDK builds on the Authorize.Net API for transaction processing. For more in-depth information on the Authorize.Net API, see our [API Reference](http://developer.authorize.net/api/reference/). For frequently asked questions, see [the EMV FAQ page](https://www.authorize.net/support/emvfaqs/).

Your application invokes the SDK to complete an EMV transaction. The SDK handles the complex EMV workflow and securely submits the EMV transaction to Authorize.Net for processing. Your never touches any EMV data at any point.


### Supported Encrypted Readers:
=======
To determine which processor you use, you can submit an API call to [getMerchantDetailsRequest](https://developer.authorize.net/api/reference/#transaction-reporting-get-merchant-details). The response contains a `processors` object.

[Supported reader devices can be obtained from Authorize.Net POS Portal](https://partner.posportal.com/authorizenet/auth/)

## Including the Framework

1.	Include the In-Person iOS SDK framework in the merchant's application. Use Xcode to include the *AnetEMVSdk.framework* file under Embedded Binaries. The merchant application must log in and initialize a valid Merchant object with the `password` field.

2.	Include additional frameworks and settings.

    a)	Include the *libxml2.2.tbd* file in the app. 

    b)	Navigate to **Build Settings > Search Paths > Header Search Paths**.

    c)	Enter the following settings: `Iphoneos/usr/include/libxml2`.

    d)  This is required only if you are including SDK as static Library. Please link the following modules in your project:
    
        • AudioToolbox.framework
        
        • CoreAudio.framework
        
        • MediaPlayer.framework
        
        • MediaToolbox.framework
        
        • External Accessory.framework
        
        • AVFoundation.framework
        
        • CoreBluetooth.framework

3.	Copy Bundle Resources.

    a)	Include the `AnetEMVStoryBoard.storyboard`, `OTAUpdate.png` and `eject.mp3` fields from the *AnetEMVSdk.framework*             file in the application. If you included them correctly, you should be able to see Target > Build Phases > Copy               Bundle Resources.

4.	If the application is developed in the Swift language, it must have a bridging header file because the                             *AnetEMVSdk.framework* file is based on Objective C.

### Initializing the SDK

There are two environments: TEST for testing your integration with the Authorize.Net Sandbox environment and LIVE for processing real transactions. 

Initialize the singleton with the AUTHNET_ENVIRONMENT setting either at the ApplicationDelegate or in the initial UIViewController. You must also #import AuthNet.h.

```
[AuthNet authNetWithEnvironment:ENV_TEST];
```

# Overview

The Authorize.Net SDK supports the following features of an MPoS solution:

1. [Mobile Device Authentication](#mobile-device-authentication)
2. [EMV Transaction Processing](#emv-transaction-processing)

    i)  [Traditional EMV](#traditional-emv)
    
    ii) [Quick Chip](#quick-chip)

3. [Non-EMV Transaction Processing](#non-emv-transaction-processing)
4. [Customer Email Receipt](#customer-email-receipt)
5. [Transaction Reporting](#transaction-reporting)
6. [Firmware/Configuration Update](#firmwareconfiguration-update)
7. [Configuring the UI](#configuring-the-ui)
8. [Code Snippets](#code-snippets)

## Mobile Device Authentication

### Device Login

```
/**
* Perform mobileDeviceLoginRequest on the AIM API.
* @param r The request to send.
*/
- (void) mobileDeviceLoginRequest:(MobileDeviceLoginRequest *)r;
```

This request logs in the mobile device.  The application can still receive a delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class. Application must populate `sessionToken` generated from login request in all the subsequent API calls to the Authorize.Net gateway.

### Device Logout

```
/**
* Perform logoutRequest on the AIM API.
* @param r The request to send.
*/
- (void) LogoutRequest:(LogoutRequest *)r;
```

Perform a `LogoutRequest` request. The application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

## EMV Transaction Processing

### Traditional EMV

#### EMV Transaction Operational Workflow

1.	In the POS application, select Pay By Card.

2.	Attach the card reader to the device.

3.	Insert a card with an EMV chip and do not remove the card until the transaction is complete. Alternatively, swipe a non-EMV card.

4.	If only a single compatible payment app resides on the chip, the payment app is selected automatically. If prompted, select the payment app. For example, Visa credit or MasterCard debit.

5.	Confirm the amount.

6.	If at any time the user cancels the transaction, the transaction is cancelled. 

#### Using the SDK to Create and Submit an EMV Transaction

1.	Initialize the _AnetEMVSdk.framework_ file.

    a)	Initialize _AnetEMVManager_ with US Currency and terminal ID.  Refer to the _AnetEMVManager.h_ file and the sample app for more details. Parameters include `skipSignature` and `showReceipt`.

    b)	`initWithCurrencyCode: terminalID: skipSignature: showReceipt`

    c)	Instantiate `AnetEMVTransactionRequest` and populate the required values, similar to `AuthNetRequest` for regular transactions. If you are using Swift to build your application, do not use the static methods provided by the SDK to initialize the objects. Also, `AnetEMVSdk` requires the app to provide `presentingViewController`, a completion block to get the response from the SDK about the submitted transaction, and a cancellation block to execute the cancel action inside the SDK. 

    d)	The `EMVTransactionType` should be mentioned in the `AnetEMVTransactionRequest`. Refer to the _AnetEMVTransactionRequest.h_ file for all the available enums to populate.

    e)	After creating all the required objects, call the following methods of AnetEMVManager and submit the transaction. 

        [startEMVWithTransactionRequest:presentingViewController:completionBlock:andCancelActionBlock]

### Quick Chip

#### Quick Chip Transaction Operational Workflow

1.	From the POS application, select Pay By Card.

2.	Attached the card reader to the device if it is not already attached.

3.	Insert a card with an EMV chip and do not remove the card until terminal asks you to do so. Alternatively, swipe a non-EMV card.

4.	If only a single compatible payment app resides on the chip, the payment app is selected automatically. If prompted, select the payment app. For example, Visa credit or MasterCard debit.

5.	Confirm the amount.

6.	If at any time the user cancels the transaction, the transaction is cancelled. 

#### Using the SDK to Create and Submit a Quick Chip EMV Transaction

1.	Initialize the _AnetEMVSdk.framework_ file.

    a)	Initialize _AnetEMVManager_ with US Currency and terminal ID.  Refer to the _AnetEMVManager.h_ file and the sample app for more details. Parameters include `skipSignature` and `showReceipt`.

    b) `initWithCurrencyCode: terminalID: skipSignature: showReceipt`
    
    c) Set the terminal mode, SDK allows AnetEMVModeSwipe or AnetEMVModeInsertOrSwipe. AnetEMVModeInsertOrSwipe accepts CHIP Based transactions as well as Swipe/MSR transaction, AnetEMVModeSwipe accepts only MSR/Swipe transactions. 
    `- (void)setTerminalMode:(AnetEMVTerminalMode)iTerminalMode;`
    
    * AnetEMVModeInsertOrSwipe is selected by default
    * Refer to the _AnetEMVManager.h_ file and the sample app for more details.
    
    d) Instantiate `AnetEMVTransactionRequest` and populate the required values, similar to `AuthNetRequest` for regular transactions. If you are using Swift to build your application, do not use the static methods provided by SDK to initialize the objects. Also, `AnetEMVSdk` requires the app to provide `presentingViewController`, a completion block to get the response from the SDK about the submitted transaction and cancelation block to execute the cancel action inside the SDK. 

    e) The `EMVTransactionType` should be mentioned in the `AnetEMVTransactionRequest`. Refer to the _AnetEMVTransactionRequest.h_ file for all the available enums to populate.)

    f) After creating all the required objects, call one of the following method of AnetEMVManager and submit the transaction. 
    
    g) Set up bluetooth connection: this step is needed if application wants to work with Bluetooth connection. 
        * Set the connection mode of the EMV reader device. EMV reader can be connected to the iOS device either with Audio or Bluetooth connection.
          `- (void)setConnectionMode:(AnetEMVConnectionMode)iConnectionMode;`
        * Audio connection is selected by default.
        * Set the BTScanDeviceListBlock(deviceListBlock) and BTDeviceConnected(deviceConnectedBlock) of AnetEMVManager.
        * Call scanBTDevicesList method of AnetEMVManager. This will search the near by devices and execute the deviceListBlock with the near by devices list. 
        * Display the list the user.
        * On user selection, call connectBTDeviceAtIndex and pass in the selected index. SDK tries to connect with selected devices from the list. On Successful/failure of connection, SDK will execute deviceConnectedBlock.
        
        * Refer to the _AnetEMVManager.h_ file and the sample app for more details.

    #### Quick Chip Transaction 

This API will authorize and capture the transaction if the `iPaperReceiptCase` argument is set to false. If `iPaperReceiptCase` argument is set to true then SDK will only authorize the transaction. Your application must settle/capture the transaction with/without tip amount. the authorized amount will be released after few days if your application fails to settle/capture the transaction.

    `[- (void)startQuickChipWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest forPaperReceiptCase:(BOOL)iPaperReceiptCase presentingViewController:(UIViewController * _Nonnull)iPresentingController completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock]`

   #### Quick Chip Transaction with Tip Amount

    `[- (void)startQuickChipWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest tipAmount:(NSString * _Nonnull)iTipAmount presentingViewController:(UIViewController * _Nonnull)iPresentingController completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock]`

   #### Quick Chip Transaction with Tip Options
    
This API will display the tip percentages on the SDK's signature screen. Your application can send three tip percentages options. Tip options must be whole numbers. The SDK will calculate and capture the tip amount based on the selected tip option.

    `[- (void)startQuickChipWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest tipOptions:(NSArray * _Nonnull)iTipOptions presentingViewController:(UIViewController * _Nonnull)iPresentingController completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock]`

**Note:** Only Goods, Services, and Payment are supported for the `TransactionType` field.

#### Success

On success, the completion block should provide the `AnetEMVTransactionResponse` object with required information about the transaction response and `isTransactionSuccessful` will be true. Refer to _AnetEMVTransactionResponse.h_ for more details. `emvResponse` has `tlvdata` and all the tags as part of the response. 

#### Errors

In case of a transaction error, the `AnetEMVTransactionResponse` object should have the error details. 

In case of other errors, the `AnetEMVError` object should be able to provide the details. 

Refer to _AnetEMVError.h_ for more details. Also, refer to _AnetEMVManager.h_ for _ANETEmvErrorCode_ enum for more details on the errors. 

### Process Card Data

The SDK's Quick Chip functionality enables your application to process the card data before the final amount is ready. Processing the card does not authorize or capture the transaction. It retrieves the card data and stores it in in-flight mode inside the SDK. When your application is ready with the final amount, your applicaton must initiate a Quick Chip transaction to capture the processed card data. When your application calls the process card method, the following Quick Chip transaction charges the processed card data.

    [- (void)readQuickChipCardDataWithPredeterminedAmountOnViewController:(UIViewController * _Nonnull)iViewController transactionType:(EMVTransactionType)iEmvTransactionType 
    withCardInteractionProgressBlock:(CardIntercationProgressBlock _Nonnull)iCardInteractionProgressBlock andCardIntercationCompletionBlock:(CardIntercationCompletionBlock _Nonnull)iCardIntercationCompletionBlock]

If your application does not charge the processed card, your application must call discard thr card data method. Any Quick Chip call after process card will charge the processed card, once the SDK charges the processed card card data will be deleted. 

    [- (BOOL)discardQuickChipCardDataWithPredeterminedAmount]

### Configuring the UI

You can configure the UI of the In-Person SDK to match the UI of your application.  Your application must initialize these values before using the SDK.  If no values are set or null is set for any of the parameters, the SDK defaults to its original theme.

The merchant application can configure the following UI parameters:

* Background Color

* Text Font Color

* Button Font Color

* Button Background Color

* Banner Image

* Banner Background Color

* Background Image

### Code Samples

The `AnetEMVUISettings` field exposes the properties to set

**Background Color**  
`AnetEMVUISettings.sharedUISettings ().backgroundColor = [UIColor blueColor];`

**Text Font Color**  
`AnetEMVUISettings.sharedUISettings ().textFontColor = [UIColor blackColor];`

**Button Font Color**  
`AnetEMVUISettings.sharedUISettings ().buttonTextColor = [UIColor blueColor];`

**Button Background Color**  
`AnetEMVUISettings.sharedUISettings ().buttonColor = [UIColor blueColor];`

**Banner Image**  
`AnetEMVUISettings.sharedUISettings ().logoImage = [UIImage imageNamed:@"ANetLogo.png"];`

**Banner Background Color**  
`AnetEMVUISettings.sharedUISettings ().bannerBackgroundColor = [UIColor yellowColor];`

**Background Image**  
`AnetEMVUISettings.sharedUISettings ().backgroundImage = [UIImage imageNamed:@"ANetBgImage.png"];`

**Signature screen Background Image**
`AnetEMVUISettings.sharedUISettings ().signatureScreenBackgroundImage = [UIImage imageNamed:@"ANetSignatureScreenBgImage.png"];`

**Signature pad Background Image**
`AnetEMVUISettings.sharedUISettings ().signaturePadBackgroundImage = [UIImage imageNamed:@"ANetSignaturePadBgImage.png"];`

**Signature pad Border Color**
`AnetEMVUISettings.sharedUISettings ().signaturePadBorderColor = [UIColor blackColor];`

**Signature pad Border Width**
`AnetEMVUISettings.sharedUISettings ().signaturePadBorderWidth = 5.0;`

**Signature pad Corner Radius**
`AnetEMVUISettings.sharedUISettings ().signaturePadCornerRadius = 5.0;`

## Non-EMV Transaction Processing

The SDK includes APIs for each of the supported API methods in AuthNet class: 

1. Authorization 
2. Purchase
3. Capture Only
4. Capture a Prior Authorization 
5. Void
6. Credit
7. Unlinked Credit

```

/**
* Perform AUTH transaction with request.
* @param r The request to send.
*/
- (void) authorizeWithRequest:(CreateTransactionRequest *)r;
```

Perform an authorization request. The application will receive delegate call back 
for successful, failed, and canceled transaction flows by setting 
the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform AUTH_CAPTURE transaction with request.
* @param r The request to send.
*/
- (void) purchaseWithRequest:(CreateTransactionRequest *)r;
```

Perform a purchase request.  This request performs both authorization and capture. The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform PRIOR_AUTH_CAPTURE transaction with request.
* @param r The request to send.
*/
- (void) captureWithRequest:(CreateTransactionRequest *)r;
```

Perform a capture request.  This request captures  a transaction that was authorized through the Authorize.Net gateway. The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform CAPTURE_ONLY transaction with request.
* NOTE: Request must include the authCode (x_auth_code).
* @param r The request to send.
*/
- (void) captureWithRequest:(CreateTransactionRequest *)r;
```

Perform a PRIOR_AUTH_CAPTURE request.  The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform VOID transaction with request.
* @param r The request to send.
*/
- (void) voidWithRequest:(CreateTransactionRequest *)r;
```

Perform a void request.  The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```

/**
* Perform CREDIT transaction with request.
* @param r The request to send.
*/
- (void) creditWithRequest:(CreateTransactionRequest *)r;
```

Perform a credit request.  The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform unlinked CREDIT transaction with request.
* NOTE: Unlinked Credit request must not have a transaction id (x_trans_id) value.
* @param r The request to send.
*/
- (void) unlinkedCreditWithRequest:(CreateTransactionRequest *)r;
```

Perform an unlinked credit request without using the UIButton call 
back mechanism.  The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.



## Customer Email Receipt

```
/**
* Perform sendCustomerTransactionReceiptRequest on the AIM API.
* @param r The request to send.
*/
- (void) sendCustomerTransactionReceiptRequest:(SendCustomerTransactionReceiptRequest *) r;
```

Perform a `sendCustomerTransactionReceiptRequest` request. The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.


## Transaction Reporting

```
/**
* Perform getSettledBatchListRequest on the Reporting API.
* @param r The reporting request to send.
*/

- (void) getBatchStatisticsRequest:(GetBatchStatisticsRequest *) r;
```

Perform a `getBatchStatisticsRequest` request. Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call of AuthNet class.

```
/**
* Perform getSettledBatchListRequest on the Reporting API.
* @param r The reporting request to send.
*/

- (void) getSettledBatchListRequest:(GetSettledBatchListRequest *) r;
```

Perform a `getSettledBatchListRequest` request. The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform getTransactionDetailsRequest on the Reporting API.
* @param r The reporting request to send.
*/

- (void) getTransactionDetailsRequest:(GetTransactionDetailsRequest *) r;
```

Perform a `getTransactionDetailsRequest` request. The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform getTransactionDetailsRequest on the Reporting API.
* @param r The reporting request to send.
*/

- (void) getTransactionListRequest:(GetTransactionListRequest *) r;
```

Perform a `getTransactionListRequest` request. The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

```
/**
* Perform getUnsettledTransactionListRequest on the Reporting API.
* @param r The reporting request to send.
*/

- (void) getUnsettledTransactionListRequest:(GetUnsettledTransactionListRequest *) r;
```

Perform a `getUnsettledTransactionListRequest` request. The application will receive delegate call back for successful, failed, and canceled transaction flows by setting the `UIViewController` with the `setDelegate` call of `AuthNet` class.

## Firmware/Configuration update
SDK enables you to update the firmware or configuration of the reader device over the air. The reader device is driven by the firmware and configuration file. Your application can check the current version of the firmware and configuration on the reader device. 

To initiate an update from the your application, call the method and it will present the UI, which will enable you to determine whether the device needs an update. If an update is required, the user will be provided the option to select configutation/firmware update. Once the option is selected, the user must take an action to start the update. The SDK displays the progress of the updates. 

```
[- (void)startOTAUpdateFromPresentingViewController:(UIViewController * _Nonnull) iPresentingController]
```

# Code Snippets

1) Initialize the singleton with the AUTHNET_ENVIRONMENT setting (dictating whether to access the Test environment or the Live environment) either at the `ApplicationDelegate` or in the initial `UIViewController`.  Make sure to `#import` _AuthNet.h_.

```
[AuthNet authNetWithEnvironment:ENV_TEST];
```

2) #### Log in to the Authorize.Net payment gateway.

```
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
```
3) #### Non EMV transaction using Encrypted Swiper data(IDTech Shuttle Two-Track Secure MagStripe Reader)
```
SwiperDataType *st = [SwiperDataType swiperDataType];
st.encryptedValue = self.encryptedCardDetails; // Encypted data be obtained with the IDTech Shuttle 
st.deviceDescription = @îFID=IDTECH.UniMag.Android.Sdkv1î;
st.encryptionType = @îTDESî;

PaymentType *paymentType = [PaymentType paymentType];
payment.swiperData = st;
payment.creditCard.cardNumber = nil;
payment.creditCard.cardCode = nil;
payment.creditCard.expirationDate = nil;


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
[an purchaseWithRequest:request]; // transaction type can be changed depending upon the need of merchant application

// Merchant application would receive the encryptedValue in the below inteface of IDTech reader
- (BOOL)_interpretUnimagEncryptedSwipeData:(NSNotification*)notification {    
self.encryptedCardDetails = @"";

NSData *data = [notification object];
NSString *val = [data description];
self.encryptedCardDetails = [val stringByReplacingOccurrencesOfString:@" " withString:@""];
self.encryptedCardDetails = [[self.encryptedCardDetails stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
```

4) #### Create a Non-EMV transaction.

### • Purchase transaction(AUTH_CAPTURE)
```
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
```

### • Authorization-only transaction(AUTH_ONLY)  
```
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
```

### • Capture only (CAPTURE_ONLY)
```
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
```

### • Capture transaction which is previously authorized
```
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

[an authorizeWithRequest:request];

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

Callback for the non-emv transaction request 

- (void) paymentSucceeded:(CreateTransactionResponse *) response {
// Handle payment success
}
```

5) #### Void the transaction.
```
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
```

6) #### Refund the transaction.
```
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
```

7) #### Request a list of settled batches   
```
GetSettledBatchListRequest *r = [GetSettledBatchListRequest getSettlementBatchListRequest];
r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
[[AuthNet getInstance] setDelegate:self];
[[AuthNet getInstance] getSettledBatchListRequest:r];

Callback

- (void) getSettledBatchListSucceeded:(GetSettledBatchListResponse *)response {
}
```

8) #### Request a transaction's details.  
```
GetTransactionDetailsRequest *r = [GetTransactionDetailsRequest getTransactionDetailsRequest];
r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
r.transId = transID;
[[AuthNet getInstance] setDelegate:self];
[[AuthNet getInstance] getTransactionDetailsRequest:r];

Callback
- (void) getTransactionDetailsSucceeded:(GetTransactionDetailsResponse *)response {
}
```

9) #### Request a list of transactions.
```
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
```

10) #### Request a list of unsettled transactions.   
```
GetUnsettledTransactionListRequest *r = [GetUnsettledTransactionListRequest getUnsettledTransactionListRequest];
r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
[[AuthNet getInstance] setDelegate:self];
[[AuthNet getInstance] getUnsettledTransactionListRequest:r];

// Callback
- (void) getUnsettledTransactionListSucceeded:(GetUnsettledTransactionListResponse *)response {
}
```

11) #### Send the customer a receipt. 
```
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
```

12) #### Logout request.
```
LogoutRequest *r = [LogoutRequest logoutRequest];
r.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
r.anetApiRequest.merchantAuthentication.mobileDeviceId = <PROVIDE A UNIQUE DEVICE IDENTIFIER>;
[[AuthNet getInstance] setDelegate:self];
[[AuthNet getInstance] LogoutRequest:r];

// Callback
- (void) logoutSucceeded:(LogoutResponse *)response {
}
```

## Error  Codes
You can view these error messages at our [Reason Response Code Tool](http://developer.authorize.net/api/reference/responseCodes.html) by entering the specific Response Reason Code into the tool. There will be additional information and suggestions there.

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
