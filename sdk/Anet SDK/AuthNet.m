//
//  AuthNet.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 8/3/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import "AuthNet.h"
#import "Reachability.h"

#define API_VERSION @"3.1"
#define DELIM_CHAR ","
#define ENCAP_CHAR "$"

#define MOBILE_DEVICE_ID [[NSString stringWithString:[[UIDevice currentDevice] uniqueIdentifier]] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]

NSInteger kErrorNoInternet				= 1;
NSInteger kErrorServerUnreachable		= 2;
NSInteger kErrorReturnedFromServer		= 3;
NSInteger kInnerErrorReturnedFromServer	= 4;
NSInteger kErrorBadCredentials			= 5;

NSString *kTestURL = @"https://test.authorize.net/gateway/transact.dll";
NSString *kLiveURL = @"https://secure.authorize.net/gateway/transact.dll";

NSString *kTestXMLURL = @"https://apitest.authorize.net/xml/v1/request.api";
NSString *kLiveXMLURL = @"https://api.authorize.net/xml/v1/request.api";

//NSString *kTestXMLURL = @"https://fjf87593lssl.servicebus.windows.net/u8p8xvE/notify/1";
//NSString *kLiveXMLURL = @"https://fjf87593lssl.servicebus.windows.net/u8p8xvE/notify/1";


//NSString *kMobileSvcURL = @"https://apitest.authorize.net/MobileService/GatewayAccount.svc/soap/v1";

NSString *kMobileSvcURL = @"https://apitest.authorize.net/MobileService/GatewayAccount.svc/soap/v1";

@interface AuthNet(private) 
@property (nonatomic, readwrite) SEL checkoutSelector;

@property (nonatomic, strong) UIViewController *loginVC;
@property (nonatomic, strong) UIViewController *checkoutVC;

- (AuthNet *)initWithEnvironment:(AUTHNET_ENVIRONMENT) e;

- (BOOL) issueSSLPost:(NSString *)body withURL:(NSString *)url;

// Asynchronous response handling
- (void) checkHTTPResponseCode:(NSHTTPURLResponse *)r;

- (void) processResponseData:(NSData *)theResponse;
- (void) processConnectionFailError:(NSError *)e;
- (void) processNoConnectionError;
- (void) makeRequest:(AuthNetRequest *) r;
- (void) makeTestAccountRequest:(AuthNetRequest *) r;

@end


static AuthNet *sharedInstance = nil;

@implementation AuthNet

@synthesize delegate;
@synthesize request;
@synthesize rootvc;
@synthesize environment;
@synthesize merchantAuthentication;
@synthesize sessionToken;
@synthesize duplicateWindowValue;
@synthesize isPendingResponse;
@synthesize responseData;
@synthesize response;
@synthesize merchantFields;

@synthesize checkoutSelector;

#pragma mark -
#pragma mark Init functions
#pragma mark -

- (AuthNet *)initWithEnvironment:(AUTHNET_ENVIRONMENT) e
{
	self = [super init];
    
	if (self) {
		self.delegate = nil;
        self.request = nil;
		self.rootvc = nil;
        self.environment = e;
		self.merchantAuthentication = [MerchantAuthenticationType merchantAuthentication];
		self.sessionToken = nil;
		// Should change this if user wants to specify something beyond default of 120secs.
		self.duplicateWindowValue = DUPLICATE_WINDOW;
		self.isPendingResponse = NO;
		self.responseData = nil;
		self.merchantFields = nil;
		self.response = nil;
		requestType = UNKNOWN;
	}
	
	return self;
}

+(AuthNet *)getInstance {
	return sharedInstance;
}


+(AuthNet *)authNetWithEnvironment:(AUTHNET_ENVIRONMENT)e {

	AuthNet *authNet = [[AuthNet alloc] initWithEnvironment:e];
	
    if (sharedInstance != nil) {
        sharedInstance = nil;
    }
    
	sharedInstance = authNet;
	return authNet;
}

+ (void) setDelegate:(id<AuthNetDelegate> )vc {
	self.delegate = vc;
}

#pragma mark -
#pragma mark New Transaction API that takes  object
#pragma mark -

- (void) authorizeWithRequest:(CreateTransactionRequest *)r {
	r.transactionRequest.transactionType = @"authOnlyTransaction";
	requestType = CREATE_TRANSACTION_REQUEST;
	[self makeRequest:r];
}

- (void) purchaseWithRequest:(CreateTransactionRequest *)r {
	r.transactionRequest.transactionType = @"authCaptureTransaction";
	requestType = CREATE_TRANSACTION_REQUEST;
	[self makeRequest:r];
}

- (void) captureWithRequest:(CreateTransactionRequest *)r {
	r.transactionRequest.transactionType = @"priorAuthCaptureTransaction";	
    requestType = CREATE_TRANSACTION_REQUEST;
	[self makeRequest:r];
}

- (void) captureOnlyWithRequest:(CreateTransactionRequest *)r {
	r.transactionRequest.transactionType = @"captureOnlyTransaction";	
    requestType = CREATE_TRANSACTION_REQUEST;
	[self makeRequest:r];
}

- (void) voidWithRequest:(CreateTransactionRequest *)r {
	r.transactionRequest.transactionType = @"voidTransaction";	
	requestType = CREATE_TRANSACTION_REQUEST;
	[self makeRequest:r];
}

- (void) creditWithRequest:(CreateTransactionRequest *)r {
	r.transactionRequest.transactionType = @"refundTransaction";	
	requestType = CREATE_TRANSACTION_REQUEST;
	[self makeRequest:r];
}

- (void) unlinkedCreditWithRequest:(CreateTransactionRequest *)r {
	// unlinked Credit is just a Credit transaction without x_trans_id
	r.transactionRequest.transactionType = @"refundTransaction";	
	requestType = CREATE_TRANSACTION_REQUEST;
	[self makeRequest:r];
}

#pragma mark -
#pragma mark Reporting API
#pragma mark -

- (void) getTransactionDetailsRequest:(GetTransactionDetailsRequest *) r {
    requestType = GET_TRANSACTION_DETAILS;
    [self makeRequest:r];
}


- (void) getSettledBatchListRequest:(GetSettledBatchListRequest *) r {
	requestType = GET_SETTLED_BATCH_LIST_REQUEST;
    [self makeRequest:r];
}

- (void) getTransactionListRequest:(GetTransactionListRequest *) r {
	requestType = GET_TRANSACTION_LIST_REQUEST;
    [self makeRequest:r];
}

- (void) getUnsettledTransactionListRequest:(GetUnsettledTransactionListRequest *) r {
	requestType = GET_UNSETTLED_TRANSACTION_LIST_REQUEST;
    [self makeRequest:r];
}


- (void) getBatchStatisticsRequest:(GetBatchStatisticsRequest *) r {
	requestType = GET_BATCH_STATISTICS_REQUEST;
    [self makeRequest:r];
}
#pragma mark -
#pragma mark Email Customer Receipt API
#pragma mark -
- (void) sendCustomerTransactionReceiptRequest:(SendCustomerTransactionReceiptRequest *) r {
    requestType = SEND_CUSTOMER_TRANSACTION_RECEIPT_REQUEST;
    [self makeRequest:r];
}

#pragma mark -
#pragma mark Mobile Registration/Login Methods
#pragma mark -

- (void) mobileDeviceLoginRequest:(MobileDeviceLoginRequest *) r {
	requestType = MOBILE_DEVICE_LOGIN_REQUEST;
	[self makeRequest:r];
}

- (void) mobileDeviceRegistrationRequest:(MobileDeviceRegistrationRequest *) r {
	requestType = MOBILE_DEVICE_REGISTRATION_REQUEST;
	[self makeRequest:r];
}

- (void) LogoutRequest:(LogoutRequest *)r {
    requestType = LOGOUT_REQUEST;
    [self makeRequest:r];
}


#pragma mark -
#pragma mark Mobile Registration/Login Methods
#pragma mark -
- (void) GetCaptchaRequest:(TestAccountCaptchaRequest *)r {
    requestType = TESTACCOUNT_CAPTCHA_REQUEST;
    [self makeTestAccountRequest:r];
}

- (void) testAccountRegistrationRequest:(TestAccountRegistrationRequest *)r {
    requestType = TESTACCOUNT_CREATE_REQUEST;
    [self makeTestAccountRegistrationRequest:r];
}


#pragma mark -
#pragma mark AIM XML API that takes CreateTransactionRequest
#pragma mark -

- (void) makeRequest:(AuthNetRequest *) r {
	NSLog(@"MAKE REQUEST");
	NSString *requestUrl = nil;
	
	if (self.environment == ENV_TEST) {
        NSLog(@"MAKE REQUEST ENV_TEST");
		requestUrl = kTestXMLURL;
        NSLog(@"MAKE REQUEST URL %@",requestUrl);
	} else {
		requestUrl = kLiveXMLURL;
	}
    
    // Check connection first
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if ([reachability currentReachabilityStatus] == NotReachable) {
        [self processNoConnectionError];
        return;
    }
	
	NSString *XMLAIMRequest = [r stringOfXMLRequest];
	
	[self issueSSLPost:XMLAIMRequest withURL:requestUrl withSoap:nil];
}
/*
 * make SSL request to mobile web service to get captcha or create test account
 */

- (void) makeTestAccountRequest:(AuthNetRequest *) r {
    NSString *requestUrl = kMobileSvcURL;
    
    // Check connection first
    self.environment = ENV_TEST;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if ([reachability currentReachabilityStatus] == NotReachable) {
        [self processNoConnectionError];
        return;
    }
	
	NSString *requestBody = [r stringOfXMLRequest];
	
	[self issueSSLPost:requestBody withURL:requestUrl withSoap:@"http://visa.com/mobileApi/IGatewayAccount/ProcessCaptcha‏"];
}

/*
 * make SSL request to mobile web service to get captcha or create test account
 */

- (void) makeTestAccountRegistrationRequest:(AuthNetRequest *) r {
    NSString *requestUrl = kMobileSvcURL;
    
    // Check connection first
    self.environment = ENV_TEST;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if ([reachability currentReachabilityStatus] == NotReachable) {
        [self processNoConnectionError];
        return;
    }
	
	NSString *requestBody = [r stringOfXMLRequest];
	
	[self issueSSLPost:requestBody withURL:requestUrl withSoap:@"http://visa.com/mobileApi/IGatewayAccount/CreateGatewayAccount"];
}



#pragma mark -
#pragma mark HTTPS Request to Authorize.Net Gateway
#pragma mark -
/**
 * issueSSLPost Starts Asychronous POST request with specified URL and POST Body.
 * Note the module will not issue another request if there's an outstanding request.
 * param body The post body.
 * param url The string representation of the url to the server.
 */
- (BOOL) issueSSLPost:(NSString *)body withURL:(NSString *)url withSoap:(NSString *)header{

	if (self.isPendingResponse)
		return NO;

	NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]];

	[r setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
	[r setHTTPMethod:@"POST"];
	
	if (body)
	{
		[r setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
		[r setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	}
    
    if (header)
    {
        [r addValue:header forHTTPHeaderField:@"SOAPAction"];//] caseSensitive:YES];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [body length]];
        [r setValue:msgLength forHTTPHeaderField:@"Content-Length"];
        
    }
    
	NSURLConnection *c = [NSURLConnection connectionWithRequest:r delegate:self];
	
	if (c == nil)
	{
		NSLog(@"Get Notification failed:  Unable to create connection");
		return NO;
	}
	
	c = nil;
	self.isPendingResponse = YES;
	return YES;
}
 
#pragma mark -
#pragma mark NSURLConnection delegates
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *respo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"MY#=%@",respo);
	if (self.responseData == nil) {
		self.responseData = [NSMutableData dataWithData:data];
	} else {
		[responseData appendData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.isPendingResponse = NO;

	if (self.responseData != nil) {
		[self processResponseData:self.responseData];
		self.responseData = nil;
	}

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.isPendingResponse = NO;

	[self processConnectionFailError:error];
}

#pragma mark -
#pragma mark Asynchronous response handling.
#pragma mark -


/**
 * processResponseData Attempts to determine and split response data into delimited response fields
 * and call the appropriate response handling callbacks depending on nature of the response.
 * param theResponse The raw response data.
 */
- (void) processResponseData:(NSData *)theResponse
{
	NSString *responseString = [[NSString alloc] initWithData:theResponse encoding:NSUTF8StringEncoding]; 

	switch (requestType) {
		case CREATE_TRANSACTION_REQUEST:
		{
			// This is part of the AIM API
            // The rest are reporting APIs, this is why this case behaves
            // a little differently.  You should have excellent knowledge 
            // of the XSD before making future edits :)
			NSLog(@"Create Transaction response");
			NSLog(@"%@", responseString);
			CreateTransactionResponse *r = [CreateTransactionResponse parseCreateTransactionResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [CreateTransactionResponse createTransactionResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
                
                if (self.response.errorType == SERVER_ERROR && 
                    [self.delegate respondsToSelector:@selector(requestFailed:)]) {
                    [self.delegate requestFailed:self.response];        
                }
            } else if ([((CreateTransactionResponse *)self.response).transactionResponse.responseCode isEqualToString:@"1"] ||
                       [((CreateTransactionResponse *)self.response).transactionResponse.responseCode isEqualToString:@"4"]) {
                
                if ([((CreateTransactionResponse *)self.response).transactionResponse.messages.messageArray count]) {
                    AuthNetMessage *m = [((CreateTransactionResponse *)self.response).transactionResponse.messages.messageArray objectAtIndex:0];
                    self.response.responseReasonText = [NSString stringWithString:m.mDescription];
                }
                if ([self.delegate respondsToSelector:@selector(paymentSucceeded:)]) {
                    [self.delegate paymentSucceeded:r];
                }
            } else {
                
                if ([((CreateTransactionResponse *)self.response).transactionResponse.errors count]) {
                    Error *e = [((CreateTransactionResponse *)self.response).transactionResponse.errors objectAtIndex:0];
                    self.response.responseReasonText = [NSString stringWithString:e.errorText];
                } 
                self.response.errorType = TRANSACTION_ERROR;
                if ([self.delegate respondsToSelector:@selector(requestFailed:)]) { 
                    [self.delegate requestFailed:self.response];
                }
            }
            
            
            return;
		}
			break;
		case GET_BATCH_STATISTICS_REQUEST:
		{
			NSLog(@"Get Batch Statistics response");
			NSLog(@"%@", responseString);
			GetBatchStatisticsResponse *r = [GetBatchStatisticsResponse parseGetBatchStatisticsResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [GetBatchStatisticsResponse getBatchStatisticsResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(getBatchStatisticsSucceeded:)]) {
                [self.delegate getBatchStatisticsSucceeded:r];
            }
		}
			break;
		case GET_TRANSACTION_DETAILS:
		{
			NSLog(@"Get Transaction Details response");
			NSLog(@"%@", responseString);
			GetTransactionDetailsResponse *r = [GetTransactionDetailsResponse parseTransactionDetail:theResponse];
            self.response = r;
            if (r == nil) {
                //TODO: make autorelease call consistent with other API calls
                self.response = [GetTransactionDetailsResponse getTransactionDetailsResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(getTransactionDetailsSucceeded:)]) {
                [self.delegate getTransactionDetailsSucceeded:r];
            }
		}
			break;
        case GET_UNSETTLED_TRANSACTION_LIST_REQUEST:
		{
			NSLog(@"Get Unsettled Transaction Details response");
            NSLog(@"%@", responseString);
			GetUnsettledTransactionListResponse *r = [GetUnsettledTransactionListResponse parseGetUnsettledTransactionListResponse:theResponse];
			self.response = r;
            if (r == nil) {
                self.response = [GetUnsettledTransactionListResponse getUnsettledTransactionListResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(getUnsettledTransactionListSucceeded:)]) {
                [self.delegate getUnsettledTransactionListSucceeded:r];
            }
		}
			break; 
        case GET_SETTLED_BATCH_LIST_REQUEST:
		{
			NSLog(@"Get Settled Batch List response");
			NSLog(@"%@", responseString);
			GetSettledBatchListResponse *r = [GetSettledBatchListResponse parseGetSettledBatchListResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [GetSettledBatchListResponse getSettledBatchListResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(getSettledBatchListSucceeded:)]) {
                [self.delegate getSettledBatchListSucceeded:r];
            }
		}
			break;
        case GET_TRANSACTION_LIST_REQUEST:
		{
			NSLog(@"Get Transaction List response");
			NSLog(@"%@", responseString);
			GetTransactionListResponse *r = [GetTransactionListResponse parseGetTransactionListResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [GetTransactionListResponse getTransactionListResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(getTransactionListSucceeded:)]) {
                [self.delegate getTransactionListSucceeded:r];
            }
		}
            break;
        case SEND_CUSTOMER_TRANSACTION_RECEIPT_REQUEST:
		{
			NSLog(@"Send Customer Transaction Receipt Response");
			NSLog(@"%@", responseString);
			SendCustomerTransactionReceiptResponse *r = [SendCustomerTransactionReceiptResponse parseSendCustomerTransactionReceiptResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [SendCustomerTransactionReceiptResponse sendCustomerTransactionReceiptResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(sendCustomerTransactionReceiptSucceeded:)]) {
                [self.delegate sendCustomerTransactionReceiptSucceeded:r];
            }
		}
			break;
        case MOBILE_DEVICE_LOGIN_REQUEST:
        {
            NSLog(@"Mobile Device Login Response");
            NSLog(@"%@", responseString);
            MobileDeviceLoginResponse *r = [MobileDeviceLoginResponse parseMobileDeviceLoginResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [MobileDeviceLoginResponse mobileDeviceLoginResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(mobileDeviceLoginSucceeded:)]) {
                [self.delegate mobileDeviceLoginSucceeded:r];
            }
        }
            break;
        case MOBILE_DEVICE_REGISTRATION_REQUEST:
        {
            NSLog(@"Mobile Device Registration Response");
            NSLog(@"%@", responseString);
            MobileDeviceRegistrationResponse *r = [MobileDeviceRegistrationResponse parseMobileDeviceRegistrationResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [MobileDeviceRegistrationResponse mobileDeviceRegistrationResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(mobileDeviceRegistrationSucceeded:)]) {
                [self.delegate mobileDeviceRegistrationSucceeded:r];
            }
        }
            break;
        case LOGOUT_REQUEST:
        {
            NSLog(@"Logout Response");
            NSLog(@"%@", responseString);
            LogoutResponse *r = [LogoutResponse parseLogoutResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [LogoutResponse logoutResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"] && 
                [self.delegate respondsToSelector:@selector(logoutSucceeded:)]) {
                [self.delegate logoutSucceeded:r];
            }
        }
            break;
        case TESTACCOUNT_CREATE_REQUEST:
        {
            NSLog(@"TESTACCOUNT_CREATE_REQUEST Response");
            NSLog(@"%@", responseString);
            TestAccountRegistrationResponse *r = [TestAccountRegistrationResponse parseTsetAccountRegistrationResponse:theResponse];
            self.response = r;
            if (r == nil) {
                NSLog(@"************** ");
                self.response = [TestAccountRegistrationResponse testAccountRegistrationResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }

            NSLog(@"%%%%%%%%%%%%%% ");
                [self.delegate testAccountRegistrationSucceeded:r];
           
        }
            break;

        case TESTACCOUNT_CAPTCHA_REQUEST:
        {
            
            NSLog(@"TESTACCOUNT_CAPTCHA_REQUEST Response");
            NSLog(@"%@", responseString);
            TestAccountCaptchaResponse *r = [TestAccountCaptchaResponse parseTestAccountCaptchaResponse:theResponse];
            self.response = r;
            if (r == nil) {
                self.response = [TestAccountCaptchaResponse testAccountCaptchaResponse];
                self.response.errorType = SERVER_ERROR;
                self.response.responseReasonText = responseString;
            }
            if ([self.response.anetApiResponse.messages.resultCode isEqualToString:@"OK"] &&
                [self.delegate respondsToSelector:@selector(CaptchaImageSucceeded:)])
            {
                [self.delegate CaptchaImageSucceeded:r];
            }
        }
            break;		default:
			break;
	}
    
    //Call appropriate delegate methods for error conditions
    if (self.response.errorType == SERVER_ERROR && 
        [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed:self.response];        
    } else if (!([self.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"]) && 
               [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		self.response.errorType = TRANSACTION_ERROR;
		[self.delegate requestFailed:self.response];
	}

}


/**
 * processConnectionFailError In the error case where a connection failed
 * to connection, invoke connectionFailed callback with a response that
 * contains the errorType CONNECTION_ERROR.
 * param e The failing conenctions error.
 */
- (void) processConnectionFailError:(NSError *)e
{
	NSInteger errorCode = 0;
	
    if ([[e domain] isEqualToString:NSURLErrorDomain])
    {
        errorCode = ([e code] == NSURLErrorNotConnectedToInternet) ? kErrorNoInternet : kErrorServerUnreachable;
		NSLog(@"errorCode = %d", errorCode);
        NSLog(@"error = %@", e);
    }
	NSLog(@"NSError code = %d", [e code]);
	NSLog(@"NSError description = %@", [e localizedDescription]);
	
	if ([self.delegate respondsToSelector:@selector(connectionFailed:)]) {
		AuthNetResponse *anResponse = [AuthNetResponse authNetResponse];
		anResponse.errorType = CONNECTION_ERROR;
		anResponse.responseReasonText = [e localizedDescription];
		self.response = anResponse;
		[self.delegate connectionFailed:anResponse];
	}
	return;
}

/**
 * processNoConnectionError In the error case where there is no 
 * connection, invoke connectionFailed callback with a response that
 * contains the errorType NO_CONNECTION_ERROR.
 */
- (void) processNoConnectionError
{
	NSLog(@"No connection found to process request");
	
	if ([self.delegate respondsToSelector:@selector(connectionFailed:)]) {
		AuthNetResponse *anResponse = [AuthNetResponse authNetResponse];
		anResponse.errorType = NO_CONNECTION_ERROR;
		anResponse.responseReasonText = NSLocalizedString(@"No connection found to process request", @"");
		self.response = anResponse;
		[self.delegate connectionFailed:anResponse];
	}
	return;
}

- (void) checkHTTPResponseCode:(NSHTTPURLResponse *)r
{
	NSHTTPURLResponse *urlResponse = r;
	NSInteger errorCode = 0;
	
	if ([urlResponse statusCode] == 400)
    {
        errorCode = kErrorBadCredentials;
    }
    else if ([urlResponse statusCode] != 200 && [urlResponse statusCode] != 201)
    {
        errorCode = kErrorReturnedFromServer;
    }	
	NSLog(@"errorCode = %d", errorCode);
	NSLog(@"response = %@", urlResponse);
	NSLog(@"response.statusCode = %d", [urlResponse statusCode]);
}

@end
