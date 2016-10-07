# Authorize.Net In-Person iOS SDK Integration Guide

The Authorize.Net In-Person SDK provides a Semi-Integrated Solution for EMV payment processing. For all transactions except EMV transactions, the SDK works like a standard Authorize.Net iOS SDK. For more information, see the source code and documentation:

[https://github.com/authorizenet/sdk-ios](https://github.com/authorizenet/sdk-ios)

The merchantís app invokes this SDK to complete an EMV transaction. The SDK handles the complex EMV workflow and securely submits the EMV transaction to Authorize.Net for processing. The merchantís application never touches any EMV data at any point.
  
## Operational Workflow

1.	From POS application, select Pay By Card.

2.	Attached the card reader to the device if it is not already attached.

3.	Insert a card with an EMV chip and do not remove the card until the transaction is complete. Alternatively, swipe a non-EMV card.

4.	If only a single compatible payment app resides on the chip, the payment app is selected automatically. If prompted, select the payment app. For example, Visa credit or MasterCard debit.

5.	Confirm the amount.

6.	If at any time the user cancels the transaction, the transaction is cancelled. 

## Using the SDK to Create and Submit an EMV Transaction

1.	Include the In-Person iOS SDK framework in the merchantís application. 	Use Xcode to include the _AnetEMVSdk.framework_ file under Embedded Binaries. The merchant application must log in and initialize a valid Merchant object with the `PasswordAuthentication` field.

2.	Include additional frameworks and settings.

    a)	Include the _libxml2.2.tbd_ file in the app. 

    b)	Navigate to **Build Settings > Search Paths > Header Search Paths**.

    c)	Enter the following settings:
        `Iphoneos/usr/include/libxml2`

3.	Copy Bundle Resources.

    a)	Include the `Response.bundle` and `AnetEMVStoryBoard.storyboard` fields from the _AnetEMVSdk.framework_ file in the application. If you included them correctly, you should be able to see Target > Build Phases > Copy Bundle Resources.

    b)	The `Response.bundle` field is required to show a simulated response for approved and declined transactions. 

    c)	Include _cert.cer_ and _cert_test.cer_. These files are there in _framework_ folder.

4.	If the application is developed in the Swift language, the application needs to have a bridging header file because the _AnetEMVSdk.framework_ file is based on Objective C.
 
5.	Initialize the _AnetEMVSdk.framework_ file.

    a)	Initialize _AnetEMVManager_ with US Currency and terminal ID.  Refer to the _AnetEMVManager.h_ file and the sample app for more details. Parameters include `skipSignature` and `showReceipt`.

    b)	`initWithCurrencyCode: terminalID: skipSignature: showReceipt`

    c)	Instantiate `AnetEMVTransactionRequest` and populate the required values, similar to `AuthNetRequest` for regular transactions. Also, `AnetEMVSdk` requires the app to provide `presentingViewController` and a completion block to get the response from the SDK about the submitted transaction. 

    d)	The `EMVTransactionType` should be mentioned in the `AnetEMVTransactionRequest`. Refer to the _AnetEMVTransactionRequest.h_ file for all the available enums to populate.

    e)	After creating all the required objects, call the following and submit the transaction. 

`[startEMVWithTransactionRequest:presentingViewController:completionBlock:andCancelActionBlock]`

**Note:** Only Goods, Services, and Payment are supported for the `TransactionType` field.

### Success

On success, the completion block should provide the `AnetEMVTransactionResponse` object with required information about the transaction response and isTransactionSuccessful will be true. Refer to _AnetEMVTransactionResponse.h_ for more details. `emvResponse` has `tlvdata` and all the tags as part of the response. 

### Errors

In case of a transaction error, the _AnetEMVTransactionResponse_ object should have the error details. 

In case of other errors, the _AnetEMVError_ object should be able to provide the details. 

Refer to _AnetEMVError.h_ for more details. Also refer to _AnetEMVManager.h_ for _ANETEmvErrorCode_ enum for more details on the errors. 

## Configuring the UI

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


# Building an MPoS Application

##Overview

The Authorize.Net SDK provides support for four main feature areas of an MPoS solution:

1. Mobile Device Login
2. Transaction Processing
3. Customer Email Receipt
4. Transaction Reporting


## Mobile Device Login and Logout

### Merchant User Login

*If the device is registered and approved then it can create a session for the user by "loggin on" to the Anet API:*

```objective-c
/**
* Perform mobileDeviceLoginRequest on the AIM API.
* @param r The request to send.
*/
- (void) mobileDeviceLoginRequest:(MobileDeviceLoginRequest *)r;
```

Perform an mobileDeviceLoginRequest request.  Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call.

### Merchant User Logout
*
To ensure maximum security the user should "logout" from their session and subsequently the application should use this method to terminate the mobile API session.*

```objective-c
/**
* Perform logoutRequest on the AIM API.
* @param r The request to send.
*/
- (void) LogoutRequest:(LogoutRequest *)r;
```

Perform an LogoutRequest request.  Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call.


## Transaction Processing

The SDK includes APIs for each of the supported API methods: 

1. AUTH
1. PRIOR_AUTH_CAPTURE
1. CAPTURE
1. VOID
1. CREDIT
1. CAPTURE_ONLY
1. Unlinked CREDIT

```objective-c
/**
 * Perform AUTH transaction with request.
 * @param r The request to send.
 */
- (void) authorizeWithRequest:(AuthNetAIMRequest *)r;
```

Perform a AUTH request. Application will receive delegate call back 
for successful, failed, and canceled transaction flows by setting 
the UIViewController with the setDelegate call.

```objective-c
/**
 * Perform AUTH_CAPTURE transaction with request.
 * @param r The request to send.
 */
- (void) purchaseWithRequest:(AuthNetAIMRequest *)r;
```

Perform a AUTH_CAPTURE request.  Application will receive delegate call 
back for successful, failed, and canceled transaction flows by setting 
the UIViewController with the setDelegate call.

```objective-c
/**
 * Perform PRIOR_AUTH_CAPTURE transaction with request.
 * @param r The request to send.
 */
- (void) captureWithRequest:(AuthNetAIMRequest *)r;
```

Perform a PRIOR_AUTH_CAPTURE request.  Application can still receive delegate call 
back for successful, failed, and canceled transaction flows by setting 
the UIViewController with the setDelegate call.

```objective-c
/**
 * Perform CAPTURE_ONLY transaction with request.
 * NOTE: Request must include in the request the authCode (x_auth_code).
 * @param r The request to send.
 */
- (void) captureWithRequest:(AuthNetAIMRequest *)r;
```

Perform a PRIOR_AUTH_CAPTURE request.  Application can still receive delegate 
call back for successful, failed, and canceled transaction flows by setting the 
UIViewController with the setDelegate call.

```objective-c
/**
 * Perform VOID transaction with request.
 * @param r The request to send.
 */
- (void) voidWithRequest:(AuthNetAIMRequest *)r;
```

Perform a VOID request.  Application can still receive delegate call 
back for successful, failed, and canceled transaction flows by 
setting the UIViewController with the setDelegate call.

```objective-c
/**
 * Perform CREDIT transaction with request.
 * @param r The request to send.
 */
- (void) creditWithRequest:(AuthNetAIMRequest *)r;
```

Perform a CREDIT request.  Application can still receive delegate call back for successful, 
failed, and canceled transaction flows by setting the UIViewController with 
the setDelegate call.

```objective-c
/**
 * Perform unlinked CREDIT transaction with request.
 * NOTE: Unlinked Credit request must not have an transaction id (x_trans_id) value.
 * @param r The request to send.
 */
- (void) unlinkedCreditWithRequest:(AuthNetAIMRequest *)r;
```

Perform an unlinked CREDIT request without using the UIButton call 
back mechanism.  Application can still receive delegate call back for 
successful, failed, and canceled transaction flows by setting the UIViewController 
with the setDelegate call.


## Customer Email Receipt


```objective-c
/**
* Perform sendCustomerTransactionReceiptRequest on the AIM API.
* @param r The request to send.
*/
- (void) sendCustomerTransactionReceiptRequest:(SendCustomerTransactionReceiptRequest *) r;
```

Perform an sendCustomerTransactionReceiptRequest request.  Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call.


## Reporting

```objective-c
/**
 * Perform getSettledBatchListRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getBatchStatisticsRequest:(GetBatchStatisticsRequest *) r;
```

Perform an getBatchStatisticsRequest request.  Application can still 
receive delegate call back for successful, failed, and canceled 
transaction flows by setting the UIViewController 
with the setDelegate call.

```objective-c
/**
 * Perform getSettledBatchListRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getSettledBatchListRequest:(GetSettledBatchListRequest *) r;
```

Perform an getSettledBatchListRequest request.  Application can still 
receive delegate call back for successful, failed, and canceled 
transaction flows by setting the UIViewController 
with the setDelegate call.

```objective-c
/**
 * Perform getTransactionDetailsRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getTransactionDetailsRequest:(GetTransactionDetailsRequest *) r;
```

Perform an getTransactionDetailsRequest request.  Application can still 
receive delegate call back for successful, failed, and canceled 
transaction flows by setting the UIViewController 
with the setDelegate call.

```objective-c
/**
 * Perform getTransactionDetailsRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getTransactionListRequest:(GetTransactionListRequest *) r;
```

Perform an getTransactionListRequest request.  Application can still 
receive delegate call back for successful, failed, and canceled 
transaction flows by setting the UIViewController 
with the setDelegate call.

```objective-c
/**
 * Perform getUnsettledTransactionListRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getUnsettledTransactionListRequest:(GetUnsettledTransactionListRequest *) r;
```

Perform an getUnsettledTransactionListRequest request.  Application can still 
receive delegate call back for successful, failed, and canceled 
transaction flows by setting the UIViewController 
with the setDelegate call.

#Putting it all together - the sample app

In order to help test for reachability on your device, you'll need to 
include the "SystemConfiguration.framework." From the Project Settings, 
go to the "Build Phases" tab and expose the "Link Binary With Libraries" 
section. Click the "+" button, select "SystemConfiguration.framework" and 
click "Add." The framework will be added to your project, which you may move 
to the "Frameworks" folder.

2) Initialize the singleton with the AUTHNET_ENVIRONMENT setting (dictating whether to access the
Test environment or the Live environment) either at the ApplicationDelegate or in the initial
UIViewController.  Make sure to #import "AuthNet.h".

```objective-c
[AuthNet authNetWithEnvironment:ENV_TEST];
```

3) Copy the code snippet below into your source file in XCode. Create a variable named "sessionToken" 
to store the session token and add your test credentials where <USERNAME> and <PASSWORD> are currently 
present. Then call the loginToGateway method from the appropriate class.

The example below is a minimal example of how to create and submit a transaction using the SDK:

```objective-c
- (void) loginToGateway {
    MobileDeviceLoginRequest *mobileDeviceLoginRequest =
        [MobileDeviceLoginRequest mobileDeviceLoginRequest];
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = <USERNAME>;
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = <PASSWORD>;
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId =
        [[[UIDevice currentDevice] uniqueIdentifier]
        stringByReplacingOccurrencesOfString:@"-" withString:@"_"];

    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
}

- (void) createTransaction {
    AuthNet *an = [AuthNet getInstance];

    [an setDelegate:self];

    CreditCardType *creditCardType = [CreditCardType creditCardType];
    creditCardType.cardNumber = @"4111111111111111";
    creditCardType.cardCode = @"100";
    creditCardType.expirationDate = @"1212";

    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = creditCardType;

    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";

    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";

    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"Soda";
    lineItem.itemDescription = @"Soda";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = @"1.00";
    lineItem.itemID = @"1";

    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSArray arrayWithObject:lineItem];
    requestType.amount = @"1.00";
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    requestType.shipping = extendedAmountTypeShipping;

    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.transactionType = AUTH_ONLY;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId =
        [[[UIDevice currentDevice] uniqueIdentifier]
        stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    [an purchaseWithRequest:request];
}

- (void) requestFailed:(AuthNetResponse *)response {
    // Handle a failed request
}

- (void) connectionFailed:(AuthNetResponse *)response {
    // Handle a failed connection
}

- (void) paymentSucceeded:(CreateTransactionResponse *) response {
    // Handle payment success
}

- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response {
    sessionToken = [response.sessionToken retain];
    [self createTransaction];
};
```

4) The first time you execute this sample code from a new device (either real 
or virtual), you will notice that the loginToGateway call fails and states 
that the device has been registered but is pending approval. You will need to 
login to the sandbox (https://test.authorize.net/) and enable the new device. 
You can find this by going to:

Home > Account (Settings) > Security Settings (Mobile Device Management)

Once there, you should see your new device in a 'Pending' state. Click on the new device and enable it.

Execute the above sample code again and the transaction should succeed.

5) Verify payment transaction success on your transaction report.



**Detail of the Authorize.Net iOS SDK**
=============================================

```objective-c
/**
 * Initialization of the AuthNet Singleton with the development server type.
 * @param e The environment either live or test server.
 */
+(AuthNet *)authNetWithEnvironment:(AUTHNET_ENVIRONMENT)e;
```

A class method that initializes and returns a singleton instance of AuthNet module.

```objective-c
/**
 * Get reference to singleton.
 */
+(AuthNet *)getInstance;
```

Returns the AuthNet singleton instance from the authNetWithEnvironment: call.

```objective-c
/**
 * Set Delegate to controller.  Call is not necessary when using standardized getButton method.
 * @param vc The View Controller that should be the delegate for AuthNetDelegate methods.
 */
+ (void) setDelegate:(UIViewController<AuthNetDelegate> const *)vc;
```

Applications that have different UIViewControllers that 
want to implement the delegate methods for successful, failed, 
and cancelled transaction flows should set the UIViewController 
of the view as delegate of the AuthNet singleton on loading the view.

```objective-c
////////////////////////
//Reporting API Calls
///////////////////////


////////////////////////
//Email Receipt Call
////////////////////////
////////////////////////
//Mobile API Calls
////////////////////////


////////////////////////
//AuthNet Delegate Protocol Methods
////////////////////////

/**
 * Delegate method is called when an AuthNetAIMResponse response is returned from the server, including
 * non processing of payment.
 */
-(void) paymentSucceeded:(AuthNetAIMResponse *)response;
```

AuthNet calls the paymentSucceeded: with an AuthNetAIMResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request. 

```objective-c
/**
 * Delegate method is called user cancels a transaction from the standardized 
 * checkout flow by clicking on the cancel button in the payment UI.
 */
-(void) paymentCancelled;
```

AuthNet calls the paymentCancelled when the user cancels the mobile payment checkout flow.  

```objective-c
/**
 * Delegate method is called when a non AuthNetAIMResponse is returned from the server.  
 * The errorType data member of response should indicate either SERVER_ERROR or
 * TRANSACTION_ERROR.  TRANSACTION_ERROR are non-APRROVED response code.  
 * SERVER_ERROR are due to connection errors with the Authorize.Net server.
 */
-(void) paymentFailed:(AuthNetAIMResponse *)response;
```

AuthNet calls the paymenFailed: with an AuthNetAIMResponse object.

```objective-c
////////////////////////
// Reporting Delegate Methods
////////////////////////

/**
 * Optional delegate: method is called when a GetBatchStatisticsResponse response is returned from the server,
 * including GetBatchStatisticsResponse error responses.
 */
- (void) getBatchStatisticsSucceeded:(GetBatchStatisticsResponse *)response;
```

AuthNet calls the getBatchStatisticsSucceeded: with an GetBatchStatisticsResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
/**
 * Optional delegate: method is called when a GetSettledBatchListResponse response is returned from the server,
 * including GetSettledBatchListResponse error responses.
 */
- (void) getSettledBatchListSucceeded:(GetSettledBatchListResponse *)response;
```

AuthNet calls the getSettledBatchListSucceeded: with an GetSettledBatchListResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
/**
 * Optional delegate: method is called when a GetTransactionDetailsResponse response is returned from the server,
 * including GetTransactionDetailsResponse error responses.
 */
- (void) getTransactionDetailsSucceeded:(GetTransactionDetailsResponse *)response;
```

AuthNet calls the getTransactionDetailsSucceeded: with an GetTransactionDetailsResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
/**
 * Optional delegate: method is called when a GetTransactionListResponse response is returned from the server,
 * including GetTransactionListResponse error responses.
 */
- (void) getTransactionListSucceeded:(GetTransactionListResponse *)response;
```

AuthNet calls the getTransactionListSucceeded: with an GetTransactionListResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
/**
 * Optional delegate: method is called when a GetUnsettledTransactionListResponse response is returned from the server,
 * including GetUnsettledTransactionListResponse error responses.
 */
- (void) getUnsettledTransactionListSucceeded:(GetUnsettledTransactionListResponse *)response;
```

AuthNet calls the getUnsettledTransactionListSucceeded: with an GetUnsettledTransactionListResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
////////////////////////
// Email Receipt Delegate Method
////////////////////////

/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) sendCustomerTransactionReceiptSucceeded:(SendCustomerTransactionReceiptResponse *)response;
```

AuthNet calls the sendCustomerTransactionReceiptSucceeded: with an SendCustomerTransactionReceiptResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
////////////////////////
// Mobile Delegate Methods
////////////////////////

/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response;
```

AuthNet calls the mobileDeviceLoginSucceeded: with an MobileDeviceLoginResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) mobileDeviceRegistrationSucceeded:(MobileDeviceRegistrationResponse *)response;
```

AuthNet calls the mobileDeviceRegistrationSucceeded: with an MobileDeviceRegistrationResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.

```objective-c
/**
 * Optional delegate: method is called when a LogoutResponse response is returned from the server,
 * including LogoutResponse error responses.
 */
- (void) logoutSucceeded:(LogoutResponse *)response;
```

AuthNet calls the logoutSucceeded: with an LogoutResponse object 
containing the parsed response fields returned from the Authorize.Net 
for the application request.



