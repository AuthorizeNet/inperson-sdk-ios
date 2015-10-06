#Mobile Point-of-Sale with Authorize.Net iOS SDK

##Installation & Sample App

See the main [SDK README](README.md) for details on installing, integrating & trying out the SDK.


##Overview

The Authorize.Net SDK provides support for four main feature areas of an MPoS solution:

1. Mobile Device Registration & Login
2. Transaction Processing
3. Customer Email Receipt
4. Transaction Reporting


## Mobile Device Registration & Login


###Register Device

*Each device to be used for MPoS transactions must be registered (see SDK support below) and approved by the merchant (in the MINT) before that device can be used for transaction processing.*

```objective-c
/**
* Perform mobileDeviceRegistrationRequest on the AIM API.
* @param r The request to send.
*/
- (void) mobileDeviceRegistrationRequest:(MobileDeviceRegistrationRequest *) r;
```

Perform an mobileDeviceRegistrationRequest request.  Application can still receive delegate call back for successful, failed, and canceled transaction flows by setting the UIViewController with the setDelegate call.

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
