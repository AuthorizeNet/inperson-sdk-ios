////
////  AuthNetUnitTests.m
////  ANMobilePaymentLib
////
////  Created by Authorize.Net on 8/25/10.
////  Copyright 2010 Authorize.Net. All rights reserved.
////
//
//#import "AuthNetUnitTests.h"
//#import "AuthNet.h"
//
//#import "NSString+dataFromFilename.h"
//#import "NSString+stringWithEscapedXMLValue.h"
//#import "NSString+stringWithXMLTag.h"
//
//// To run the unit tests, you must enter in your test credentials
//#define API_LOGIN_ID @"9Pa9qXE6m"
//#define TRANSACTION_KEY @"9eMxA663T9Y6xuyv"
//
//#define USERNAME @"shiun75"
//#define PASSWORD @"Authorize75"
//#define MOBILE_DEVICE_ID [[NSString stringWithString:[[UIDevice currentDevice] uniqueIdentifier]] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]
//
//
//@interface AuthNet(private)
//- (AuthNet *)initWithAPILoginID:(NSString const *)a andTransactionKey:(NSString const *)t forEnvironment:(AUTHNET_ENVIRONMENT) e;
//- (AuthNet *)initWithEnvironment:(AUTHNET_ENVIRONMENT) e;
//@end
//
//
//@interface AuthNetUnitTests()
//- (void) setupRequest:(CreateTransactionRequest *) request;
//- (void) setupSimpleRequest:(CreateTransactionRequest *)request;
//- (NSString *) doMobileRegistrationAndLoginToGetSessionToken;
//@end
//
//@implementation AuthNetUnitTests
//
//#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application
//
//- (void) setupRequest:(CreateTransactionRequest *)request
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//    
//    SettingType *s = [SettingType settingType];
//    s.name = @"duplicateWindow";
//    s.value = @"1";
//    [request.transactionRequest.transactionSettings addObject:s];
//    
//    s = [SettingType settingType];
//    s.name = @"emailCustomer";
//    s.value = @"false";
//    [request.transactionRequest.transactionSettings addObject:s];
//
//    s = [SettingType settingType];
//    s.name = @"recurringBilling";
//    s.value = @"false";
//    [request.transactionRequest.transactionSettings addObject:s];
//
//    s = [SettingType settingType];
//    s.name = @"testRequest";
//    s.value = @"false";
//    [request.transactionRequest.transactionSettings addObject:s];
//
//    s = [SettingType settingType];
//    s.name = @"headerEmailReceipt";
//    s.value = @"header value";
//    [request.transactionRequest.transactionSettings addObject:s];
//
//    s = [SettingType settingType];
//    s.name = @"footerEmailReceipt";
//    s.value = @"footer value";
//    [request.transactionRequest.transactionSettings addObject:s];
//    
////    s = [SettingType settingType];
////    s.name = [NSString stringWithString:@"merchantEmail"];
////    s.value = [NSString stringWithString:@"shiun@visa.labzero.com"];
////    [request.transactionRequest.transactionSettings addObject:s];
//
////    s = [SettingType settingType];
////    s.name = [NSString stringWithString:@"allowPartialAuth"];
////    s.value = [NSString stringWithString:@"false"];
////    [request.transactionRequest.transactionSettings addObject:s];
//
//    
//	request.transactionRequest.poNumber = @"123454321";
//	
//	CreditCardType *cc = [CreditCardType creditCardType];
//	cc.cardNumber = @"4222222222222";
//	cc.expirationDate = @"1112";
//	cc.cardCode = @"1234";
//	request.transactionRequest.payment.creditCard = cc;
//
//	CustomerAddressType *c = [CustomerAddressType customerAddressType];
//	c.firstName = @"Unit";
//	c.lastName = @"Tests";
//	c.address = @"123 street";
//	c.city = @"some city";
//	c.state = @"San Francisco";
//	c.zip = @"94103";
//	c.country = @"USA";
//	c.company = @"some company";
//	c.phoneNumber = @"1234567890";
//	c.faxNumber = @"0987654321";
//	request.transactionRequest.billTo = c;
//
//	CustomerDataType *cd = [CustomerDataType customerDataType];
//	cd.email = @"nobody@somewhere.com";
//	cd.customerID = @"my ID";
//	request.transactionRequest.customer = cd;
//	
//	OrderType *o = [OrderType order];
//	o.invoiceNumber = @"123124123432";
//	o.orderDescription = @"Invoice Description";
//    request.transactionRequest.order = o;
//	
//	LineItemType *o1 = [LineItemType lineItem];
//	o1.itemID = @"item1";
//	o1.itemName = @"golf balls";
//	o1.itemDescription = @"just bags";
//	o1.itemQuantity = @"2";
//	o1.itemPrice = @"18.95";
//	o1.itemTaxable = YES;
//	
//	LineItemType *o2 = [LineItemType lineItem];
//	o2.itemID = @"item2";
//	o2.itemName = @"golf bag";
//	o2.itemDescription = @"Wilson golf carry bag, red";
//	o2.itemQuantity = @"1";
//	o2.itemPrice = @"39.99";
//	o2.itemTaxable = YES;
//
//    [request.transactionRequest.lineItems addObject:o1];
//    [request.transactionRequest.lineItems addObject:o2];
//    
//	NameAndAddressType *sd = [NameAndAddressType nameAndAddressType];
//	sd.firstName = @"Shipping First Name";
//	sd.lastName = @"Shipping Last Name";
//	sd.company = @"Shipping Company";
//	sd.address = @"Shipping Street";
//	sd.city = @"Shipping City";
//	sd.state = @"Shipping State";
//	sd.zip = @"Shipping Zip";
//	sd.country = @"Shipping Country";
//	request.transactionRequest.shipTo = sd;
//	
//	ExtendedAmountType *tax = [ExtendedAmountType extendedAmountType];
//	tax.name = @"Tax1";
//	tax.amountDescription = @"State tax";
//	tax.amount= @"1.23";
//    request.transactionRequest.tax = tax;
//
//	ExtendedAmountType *duty = [ExtendedAmountType extendedAmountType];
//	duty.name = @"Duty";
//	duty.amountDescription = @"Duty tax";
//	duty.amount = @"1.23";
//    request.transactionRequest.duty = duty;
//
//	ExtendedAmountType *shipping = [ExtendedAmountType extendedAmountType];
//	shipping.name = @"Shipping";
//	shipping.amountDescription = @"Shipping tax";
//	shipping.amount = @"1.23";
//    request.transactionRequest.shipping = shipping;
//	
//	request.transactionRequest.taxExempt = NO;
//	request.transactionRequest.poNumber = @"123456789";
//	
//	request.transactionRequest.customerIP = @"192.168.1.1";
//	
//	//Validating that merchant fields are being returned.
//    UserField *u1 = [UserField userField];
//    u1.name = @"MDF1";
//    u1.value = @"MDF_Value1";
//
//    UserField *u2 = [UserField userField];
//    u2.name = @"MDF2";
//    u2.value = @"MDF_Value2";
//
//    UserField *u3 = [UserField userField];
//    u3.name = @"MDF3";
//    u3.value = @"MDF_Value3";
//    
//    UserField *u4 = [UserField userField];
//    u4.name = @"MDF4";
//    u4.value = @"MDF_Value4";
//    
//    UserField *u5 = [UserField userField];
//    u5.name = @"MDF5";
//    u5.value = @"MDF_Value5";
//
//    UserField *u6 = [UserField userField];
//    u6.name = @"MDF6";
//    u6.value = @"MDF_Value6";
//
//    UserField *u7 = [UserField userField];
//    u7.name = @"MDF7";
//    u7.value = @"MDF_Value7";
//    
//    UserField *u8 = [UserField userField];
//    u8.name = @"MDF8";
//    u8.value = @"MDF_Value8";
//    
//    UserField *u9 = [UserField userField];
//    u9.name = @"MDF9";
//    u9.value = @"MDF_Value9";
//    
//    UserField *u10 = [UserField userField];
//    u10.name = @"MDF10";
//    u10.value = @"MDF_Value10";
//    
//    UserField *u11 = [UserField userField];
//    u11.name = @"MDF11";
//    u11.value = @"MDF_Value11";
//
//    UserField *u12 = [UserField userField];
//    u12.name = @"MDF12";
//    u12.value = @"MDF_Value12";
//
//    [request.transactionRequest.userFields addObject:u1];
//    [request.transactionRequest.userFields addObject:u2];
//    [request.transactionRequest.userFields addObject:u3];
//    [request.transactionRequest.userFields addObject:u4];
//    [request.transactionRequest.userFields addObject:u5];
//    [request.transactionRequest.userFields addObject:u6];
//    [request.transactionRequest.userFields addObject:u7];
//    [request.transactionRequest.userFields addObject:u8];
//    [request.transactionRequest.userFields addObject:u9];
//    [request.transactionRequest.userFields addObject:u10];
//    [request.transactionRequest.userFields addObject:u11];
//    [request.transactionRequest.userFields addObject:u12];
//}
//
//- (void) setupSimpleRequest:(CreateTransactionRequest *)request
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//
//	CreditCardType *cc = [CreditCardType creditCardType];
//	cc.cardNumber = @"4222222222222";
//	cc.expirationDate = @"1112";
////	cc.cardCodeVerification = @"1234";
//	request.transactionRequest.payment.creditCard = cc;
//}
//
//- (void) setupMobileDeviceRegistrationRequest:(MobileDeviceRegistrationRequest *) request 
//{
//	request.anetApiRequest.merchantAuthentication.name = USERNAME;
//	request.anetApiRequest.merchantAuthentication.password = PASSWORD;
//
//	request.mobileDevice.mobileDeviceId = MOBILE_DEVICE_ID;
//}
//
//
//- (void) setupMobileDeviceLoginRequest:(MobileDeviceLoginRequest *) request 
//{
//	request.anetApiRequest.merchantAuthentication.name = USERNAME;
//	request.anetApiRequest.merchantAuthentication.password = PASSWORD;
//
//	request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//}
//
//- (void) setupGetTransactionDetailsRequest:(GetTransactionDetailsRequest *) request 
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//}
//
//- (void) setupGetSettledBatchListRequest:(GetSettledBatchListRequest *) request 
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//}
//
//
//- (void) setupGetTransactionListRequest:(GetTransactionListRequest *) request 
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//}
//
//- (void) setupGetUnsettledTransactionListRequest:(GetUnsettledTransactionListRequest *) request 
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//}
//
//- (void) setupGetBatchStatisticsRequest:(GetBatchStatisticsRequest *) request 
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//}
//
//- (void) setupSendCustomerTransactionReceiptRequest:(SendCustomerTransactionReceiptRequest *) request 
//{
//    NSString *sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//    request.customerEmail = @"customer@somewhere.com";
//    NSLog(@"Send Customer Transaction Receipt Request = %@", [request stringOfXMLRequest]);
//}
//
//- (NSString *) doMobileRegistrationAndLoginToGetSessionToken {
//    //1. Attempt to register device.
//	MobileDeviceRegistrationRequest *r = [MobileDeviceRegistrationRequest mobileDeviceRegistrationRequest];
//	[self setupMobileDeviceRegistrationRequest:r];
//	
//    AuthNet *an = [AuthNet authNetWithEnvironment:ENV_TEST];
//	an.duplicateWindowValue = 1;
//	
//	[an mobileDeviceRegistrationRequest:r];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from mobileDeviceRegistrationRequest should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Result Code for mobileDeviceRegistrationResponse was not Ok");
//    Messages *ma = ((MobileDeviceRegistrationResponse *)an.response).anetApiResponse.messages;
//    AuthNetMessage *m = [ma.messageArray objectAtIndex:0];
//    STAssertTrue([m.code isEqualToString:@"I00006"], @"Response code was NOT I00006.  Device not approved for use!");
//    
//	if (an.response == nil)
//		return nil;
//    
//    // 2. Attempt to login
//    NSLog(@"Registration successful.  Message = %@", m);
//    MobileDeviceLoginRequest *loginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
//    [self setupMobileDeviceLoginRequest:loginRequest];
//
//    an = [AuthNet getInstance];
//
//    [an mobileDeviceLoginRequest:loginRequest];
//    
//    while (an.isPendingResponse == YES || an.response == nil) {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//    }
//    
//    STAssertTrue((an.response != nil), @"Response from mobileDeviceRegistrationRequest should not be nil!");
//    STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Result Code for mobileDeviceRegistrationResponse was not Ok");
//    
//    NSString *sessionToken = [NSString stringWithString:((MobileDeviceLoginResponse *)an.response).sessionToken];
//    NSLog(@"Session Token = %@", sessionToken);
//
//    return sessionToken;
//}
//
//
//- (void) testAuthNetSingletonCreationWithEnv
//{
//	AuthNet *an = [AuthNet authNetWithEnvironment:ENV_TEST];
//	STAssertTrue((an.environment != ENV_LIVE), @"Environment should be for LIVE server");	
//	STAssertTrue((an.environment == ENV_TEST), @"Environment should not be for TEST server");
//	an = nil;
//    
//	an = [AuthNet getInstance];
//	STAssertTrue((an.environment != ENV_LIVE), @"Environment should be for LIVE server");	
//	STAssertTrue((an.environment == ENV_TEST), @"Environment should not be for TEST server");
//	
//	an = [AuthNet authNetWithEnvironment:ENV_LIVE];    
//    STAssertTrue((an.environment != ENV_TEST), @"Environment should be for TEST server");	
//	STAssertTrue((an.environment == ENV_LIVE), @"Environment should not be for LIVE server");
//
//	an = [AuthNet getInstance];
//    STAssertTrue((an.environment != ENV_TEST), @"Environment should be for TEST server");	
//	STAssertTrue((an.environment == ENV_LIVE), @"Environment should not be for LIVE server");
//}
//
//
//
//- (void) testMobileDeviceRegistrationAndLoginRequest
//{
//    //1. attempt the doMobileRegistrationAndLoginToGetSessionToken
//    // If no sessionToken is not returned, registration was wrong.
//    NSString * sessionToken = [self doMobileRegistrationAndLoginToGetSessionToken];
//    STAssertNotNil(sessionToken, @"Did not get a session token from registration and login");
//
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//
//    
//    //2. NEGATIVE TESTING. To avoid populating the mobile device list, use bad user.
//    MobileDeviceRegistrationRequest *r = [MobileDeviceRegistrationRequest mobileDeviceRegistrationRequest];
//    [self setupMobileDeviceRegistrationRequest:r];
//
//    r.anetApiRequest.merchantAuthentication.name = @"BADUSER";
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from mobileDeviceRegistrationRequest should not be nil!");
//    
//	if (an.response == nil)
//		return;
//    
//    
//}
//
//
//- (void) testMobileDeviceLoginRequest
//{
//    //1. Attempt to register device.
//	MobileDeviceLoginRequest *r = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
//	[self setupMobileDeviceLoginRequest:r];
//	
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	[an mobileDeviceLoginRequest:r];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from mobileDeviceLoginRequest should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Result Code for mobileDeviceLoginResponse was not Ok");
//    
//	if (an.response == nil)
//		return;
//    
//    ///////////////
//	// 2. NEGATIVE TESTING: attempt to make a wrong user credential.
//    r.anetApiRequest.merchantAuthentication.name = @"BADUSER";
//
//    [an mobileDeviceLoginRequest:r];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from mobileDeviceLoginRequest should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Error"], @"Result Code for mobileDeviceLoginResponse should not be Ok");
//
//}
//
//- (void) testSimpleAuthNetPurchase
//{
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupSimpleRequest:request];
//    
//	request.transactionRequest.amount = @"3.33";
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//    
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Result Code for Purchase(AUTH_CAPTURE) was not Ok");
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	if (an.response == nil)
//		return;
//	
//    request.anetApiRequest.merchantAuthentication.sessionToken = ((CreateTransactionResponse *)an.response).sessionToken;
//	//Slowly add to the request.  This simple request has Shipping Charges included
//	request.transactionRequest.amount = @"11.11";
//	request.transactionRequest.shipping = [ExtendedAmountType extendedAmountType];
//	request.transactionRequest.shipping.amount = @"0.15";
//	request.transactionRequest.shipping.name = @"my_tax";
//	request.transactionRequest.shipping.amountDescription = @"my_tax_description";
//
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Result Code for Purchase(AUTH_CAPTURE) was not Ok");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	if (an.response == nil)
//		return;
//}
//
//-(void) testAuthNetAuthorize
//{
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	request.transactionRequest.amount = @"1.23";
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//
//	///////////////
//	// 1. Try a standard AUTH_ONLY request
//	///////////////
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Authorization was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	if (an.response == nil)
//		return;
//	
//	///////////////
//	// 2. Try a zero value AUTH_ONLY request
//	///////////////
//	request.transactionRequest.amount = @"0.00";
//	[an authorizeWithRequest:request];
//	
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from $0.00 Authorize transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for $0.00 Authorization was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	
//    if (an.response == nil)
//		return;
//}
//
//- (void) testAuthNetAuthorizeAndCapture
//{
//	NSString *transactionID;
//	NSMutableArray *a = nil;
//	BOOL error = FALSE;
//	
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	request.transactionRequest.amount = @"4.56";
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1a. Initial AUTH_ONLY request
//	///////////////
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Authorization was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//    if (an.response == nil)
//		return;
//	
//	///////////////
//	// 1b. Do a PRIOR_AUTH_CAPTURE on previous AUTH_ONLY request using transaction id.
//	///////////////
//	transactionID = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];
//	NSLog(@"transId!!!!!!!!! = %@", transactionID);
//	request.transactionRequest.refTransId = transactionID;
//	request.transactionRequest.amount = nil;  // Amount not necessary unless specifying lower amount than initial auth.
//	[an captureWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Authorization was not APPROVED");	
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//	if (an.response == nil)
//		return;
//	
//	
//	
//	///////////////
//	// 2a. Initial AUTH_ONLY request
//	///////////////
//	request.transactionRequest.refTransId = nil;
//	request.transactionRequest.amount = @"4.44";
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Authorization was not APPROVED");	
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//
//	if (an.response == nil)
//		return;
//	
//	///////////////
//	// 2b. Do a PRIOR_AUTH_CAPTURE on previous AUTH_ONLY request with less
//	//     dollar amount than was previous APPROVED.
//	///////////////
//	transactionID = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];	
//	request.transactionRequest.refTransId = transactionID;
//	request.transactionRequest.amount = @"1.00";
//	[an captureWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Capture transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Capture was not ERROR");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//
//	///////////////
//	// 3a. NEGATIVE TESTING: Initial AUTH_ONLY request
//	///////////////
//	request.transactionRequest.refTransId = nil;
//	request.transactionRequest.amount = @"4.31";
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Authorization was not APPROVED");	
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//
//    if (an.response == nil)
//		return;
//	
//	///////////////
//	// 3b. NEGATIVE TESTING: Do a PRIOR_AUTH_CAPTURE on previous AUTH_ONLY request with greater
//	//     dollar amount than was previous APPROVED.
//	///////////////
//	transactionID = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];	
//	request.transactionRequest.refTransId = transactionID;
//	request.transactionRequest.amount = @"4.45";
//	[an captureWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Capture transaction should not be nil!");
//	STAssertTrue([((CreateTransactionResponse *) an.response).transactionResponse.responseCode isEqualToString:@"3"], @"Response Code for Capture was not ERROR");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertFalse([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"NEGATIVE TESTING: Response Code for Purchase(AUTH_CAPTURE) should not be APPROVED");
//	
//	a = ((CreateTransactionResponse *)an.response).transactionResponse.errors;
//	error = FALSE;
//	// Potentially multiple errors
//	for (Error * e in a) {
//		if([e.errorCode isEqualToString:@"47"])
//			error = TRUE;
//	}
//	STAssertTrue(error, @"Response Code for Capture was not 47");	
//	if (an.response == nil)
//		return;
//	
//	///////////////
//	// 4. NEGATIVE TESTING: Attempt to do PRIOR_AUTH_CAPTURE on invalid transaction id;
//	///////////////
//	request.transactionRequest.refTransId = @"12345";
//	request.transactionRequest.amount = nil;
//	[an captureWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	STAssertTrue([((CreateTransactionResponse *) an.response).transactionResponse.responseCode isEqualToString:@"3"], @"Response Code for Capture was not ERROR");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertFalse([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"NEGATIVE TESTING: Response Code for Purchase(AUTH_CAPTURE) should not be APPROVED");
//
//	a = ((CreateTransactionResponse *)an.response).transactionResponse.errors;
//	error = FALSE;
//	// Potentially multiple errors
//	for (Error * e in a) {
//		if([e.errorCode isEqualToString:@"16"])
//			error = TRUE;
//	}
//	STAssertTrue(error, @"Response Code for Capture was not 16");
//
//	if (an.response == nil)
//		return;
//}
//
//
//
//- (void) testAuthNetPurchase
//{	
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	request.transactionRequest.amount = @"7.89";
//
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//
//	///////////////
//	// 1. Attempt to do AUTH_CAPTURE;
//	///////////////
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	if (an.response == nil)
//		return;
//	
//	///////////////
//	// 2. NEGATIVE TESTING: Attempt to do a AUTH_CAPTURE with no x_amount
//	///////////////
//	request.transactionRequest.amount = nil;
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([((CreateTransactionResponse *) an.response).transactionResponse.responseCode isEqualToString:@"3"], @"Response Code for Purchase(AUTH_CAPTURE) with no amount was not ERROR");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertFalse([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"NEGATIVE TESTING: Response Code for Purchase(AUTH_CAPTURE) should not APPROVED");
//	NSArray *a = ((CreateTransactionResponse *)an.response).transactionResponse.errors;
//	BOOL error = FALSE;
//	// Potentially multiple errors
//	for (Error * e in a) {
//		if([e.errorCode isEqualToString:@"5"])
//			error = TRUE;
//	}
//	STAssertTrue(error, @"Response Code for Capture was not 5");
//
//}
//
//
//- (void) testAuthNetPurchaseAndVoid
//{
//	NSString *transactionID;
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	///////////////
//	// 1a. Attempt to do AUTH_CAPTURE;
//	///////////////
//	request.transactionRequest.amount = @"2.34";
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;	
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//	if (an.response == nil)
//		return;
//	
//	///////////////
//	// 1b. Attempt to do VOID from previous AUTH_CAPTURE transaction;
//	///////////////	
//	transactionID = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];
//	request.transactionRequest.refTransId = transactionID;
//	request.transactionRequest.amount = nil;   // amount not necessary
//	[an voidWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Void transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Void was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//}
//
//
//- (void) testAuthNetAuthAndCaptureAndVoid
//{
//	NSString *transactionID;
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	///////////////
//	// 1a. Attempt to do AUTH_ONLY;
//	///////////////
//	request.transactionRequest.amount = @"7.65";	
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Authorization was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	
//    if (an.response == nil)
//		return;
//	
//	///////////////
//	// 1b. Attempt to do PRIOR_AUTH_CAPTURE;
//	///////////////	
//	transactionID = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];	
//	request.transactionRequest.refTransId = transactionID;
//	[an captureWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Capture transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Capture was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	
//    if (an.response == nil)
//		return;
//	
//	///////////////
//	// 1c. Attempt to do VOID on previous transaction;
//	///////////////
//	[an voidWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Void transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Void was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//}
//
//
////Test ECheck with AUTH, PRIOR_AUTH_CAPTURE, and AUTH_CAPTURE.  x_echeck_type = WEB.
//
//- (void) testECheck {
//
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//    
//    AuthNet *an = [AuthNet getInstance];
//
//	//Force it to only use BankAccount
//	//request.creditCard = nil;
//	
//	BankAccountType *ec = [BankAccountType bankAccountType];
//	ec.routingNumber = @"322271627";
//	ec.accountNumber = @"123456789";
//	ec.accountType = @"checking";
//	ec.nameOnAccount = @"Joe Shmoe";
//	ec.checkNumber = @"1234";
//	ec.echeckType = @"WEB";
//	
//	request.transactionRequest.payment.bankAccount = ec;
//	
//	request.transactionRequest.amount = @"1.23";
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1a. Attempt to do AUTH_ONLY with valid eCheck;
//	///////////////
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	
//	STAssertTrue((an.response != nil), @"Response from AUTH ECheck transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Authorization ECheck was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//    if (an.response == nil)
//		return;
//	
//	
//	///////////////
//	// 1b. Attempt to do PRIOR_AUTH_CAPTURE with valid eCheck;
//	///////////////	
//	NSString *transactionID = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];	
//	request.transactionRequest.refTransId = transactionID;
//	[an captureWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from PRIOR_AUTH_CAPTURE ECheck transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for PRIOR_AUTH_CAPTURE ECheck was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//    if (an.response == nil)
//		return;
//	
//	///////////////
//	// 2. Attempt to do AUTH_CAPTURE with valid eCheck;
//	///////////////
//	request.transactionRequest.refTransId = nil;
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from AUTH_CAPTURE ECheck transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for AUTH_CAPTURE ECheck was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	
//    if (an.response == nil)
//		return;
//	
//	///////////////
//	// 3. Attempt to do AUTH_CAPTURE with valid eCheck of type PPD;
//	///////////////
//	request.transactionRequest.payment.bankAccount.echeckType = @"PPD";
//	request.transactionRequest.amount = @"3.21";
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from AUTH_CAPTURE ECheck transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for AUTH_CAPTURE ECheck was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//    if (an.response == nil)
//		return;
//	
//	///////////////
//	// 4. Attempt to do AUTH_CAPTURE with valid eCheck of type CCD;
//	//    NOTE to specify BUSINESS CHECKING
//	///////////////
//	request.transactionRequest.payment.bankAccount.echeckType = @"CCD";
//	request.transactionRequest.amount = @"2.31";
//	request.transactionRequest.payment.bankAccount.accountType = @"businessChecking";
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}
//	STAssertTrue((an.response != nil), @"Response from AUTH_CAPTURE ECheck transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for AUTH_CAPTURE ECheck was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//    if (an.response == nil)
//		return;
//	
//
//	///////////////
//	// 5. NEGATIVE TESTING: Invalid eCheck type
//	///////////////		
////	request.bankAccount.echeckType = ECHECK_TYPE_UNKNOWN;
////	[an purchaseWithRequest:request];
////	while (an.isPendingResponse == YES || an.response == nil) {
////		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
////	}
////	STAssertTrue((an.response != nil), @"Response from AUTH_CAPTURE ECheck transaction should not be nil!");
////	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.responseCode isEqualToString:@"3"], @"Response Code for unknown ECheck was not ERROR");
////
////	a = ((CreateTransactionResponse *)an.response).transactionResponse.errors;
////	error = FALSE;
////	// Potentially multiple errors
////	for (Error * e in a) {
////		if([e.errorCode isEqualToString:@"100"])
////			error = TRUE;
////	}
////	STAssertTrue(error, @"Response Reason Code for unknown ECheck was not 100");	
//
//}
//
//
//// Test x_test_request field
//
//- (void) testTestRequestFieldWithPurchase {
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	request.transactionRequest.amount = @"1.11";
//    
//    //Setting request as a test request
//    SettingType *s = [SettingType settingType];
//    s.name = @"testRequest";
//    s.value = @"true";
//    [request.transactionRequest.transactionSettings addObject:s];
//    
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1. Run a transaction with x_test_request = YES.  Test mode.
//	///////////////	
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    STAssertTrue(([[NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId] intValue] == 0), @"Transaction ID Purchase(AUTH_CAPTURE) in test mode should be 0");
//	if (an.response == nil)
//		return;
//	
//	///////////////
//	// 2. We can generate responseCode/responseReasonCode by the amount (in test mode).
//	///////////////
//	request.transactionRequest.amount = @"23.00";
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([((CreateTransactionResponse *) an.response).transactionResponse.responseCode isEqualToString:@"3"], @"Response Code for Purchase(AUTH_CAPTURE) was not ERROR");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertFalse([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"NEGATIVE TESTING: Response Code for Purchase(AUTH_CAPTURE) should not be APPROVED");
//	STAssertTrue(([[NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId] intValue] == 0), @"Transaction ID Purchase(AUTH_CAPTURE) in test mode should be 0");
//
//	NSArray *a = ((CreateTransactionResponse *)an.response).transactionResponse.errors;
//	BOOL error = FALSE;
//	// Potentially multiple errors
//	for (Error * e in a) {
//		if([e.errorCode isEqualToString:@"23"])
//			error = TRUE;
//	}
//	STAssertTrue(error, @"Response Reason Code for Purchase(AUTH_CAPTURE) does not match amount (TEST_MODE)");	
//}
//
//
//
///* 
//   Following uses a LIVE account to the LIVE environment 
//*/
//
///*
//- (void) testLiveAuthNetAuthorize
//{
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	///////////////
//	// 1. Run a AUTH_ONLY transaction on the live server. 
//	///////////////
//	request.amount = @"1.23";
//	AuthNet *an = [[AuthNet alloc] initWithAPILoginID:@"94xrmSW96x" andTransactionKey:@"76kj6LUpYy556Bgp" forEnvironment:ENV_LIVE];
//	an.duplicateWindowValue = 1;
//	
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Authorize transaction should not be nil!");
//	STAssertTrue([((AIMCreateTransactionResponse *)an.response).transactionResponse.responseCode isEqualToString:@"3"], @"Response Code for Authorization was not ERROR");
//    
//}
//
//- (void) testLiveAuthNetPurchase
//{	
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	request.amount = @"7.89";
//	AuthNet *an = [[AuthNet alloc] initWithAPILoginID:@"94xrmSW96x" andTransactionKey:@"76kj6LUpYy556Bgp" forEnvironment:ENV_LIVE];
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1. Run a AUTH_CAPTURE transaction on the live server. 
//	///////////////
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([((AIMCreateTransactionResponse *)an.response).transactionResponse.responseCode isEqualToString:@"3"], @"Response Code for Purchase(AUTH_CAPTURE) was not ERROR");
//
//}
//*/
//- (void) testAVSWithAuth {
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	
//	// Success condition
//	request.transactionRequest.amount = @"0.00";
//
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1. Run a AUTH_ONLY transaction with $0.00 amount = AVS test. 
//	///////////////
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from AVS (AUTH_ONLY) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for AVS(AUTH_ONLY) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.avsResultCode isEqualToString:@"Y"], @"AVS Result was not 'Y' ");	
//	if (an.response == nil)
//		return;
//
//	///////////////
//	// 2. NEGATIVE TESTING: Run a AUTH_ONLY transaction with $0.00 amount = AVS test with null out address and attempt.
//	///////////////
//	request.transactionRequest.billTo.address = nil;
//	request.transactionRequest.billTo.city = nil;
//	request.transactionRequest.billTo.state = nil;
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}		
//	STAssertTrue((an.response != nil), @"Negative testing: Response from AVS (AUTH_ONLY) transaction should not be nil!");
//	STAssertTrue([((CreateTransactionResponse *) an.response).transactionResponse.responseCode isEqualToString:@"3"], @"NEGATIVE TESTING: Response Code for AVS(AUTH_ONLY) was not ERROR");
//	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.avsResultCode isEqualToString:@"P"], @"NEGATIVE TESTING: AVS Result was not 'P' ");	
//}
//
//
//- (void) testMerchantFieldsAreEchoed {
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];	// Success condition
//	request.transactionRequest.amount = @"1.11";
//
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1. Run a regular AUTH_CAPTURE transaction. Make sure we are echoed the merchant defined field
//	///////////////
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from purchase (AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for purcase (AUTH_CAPTURE) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    
//	NSArray *n = (((CreateTransactionResponse *)an.response).transactionResponse.userFields);
//	
//	// Order should be maintained.
//	NSString *value = ((UserField *)[n objectAtIndex:0]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value1"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:1]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value2"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:2]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value3"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:3]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value4"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:4]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value5"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:5]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value6"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:6]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value7"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:7]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value8"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:8]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value9"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:9]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value10"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:10]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value11"], @"Merchant field value does not equal what was initially sent");
//
//	value = ((UserField *)[n objectAtIndex:11]).value;
//	STAssertTrue(value != nil, @"Merchant field value did not get echoed back");
//	STAssertTrue([value isEqualToString:@"MDF_Value12"], @"Merchant field value does not equal what was initially sent");
//}
//
//- (void) testDifferentTestCards {
///*	
//	3700 0000 0000 002 - American Express Test Card
//	6011 0000 0000 0012 - Discover Test Card
//	5424 0000 0000 0015 - MasterCard Test Card
//	4007 0000 0002 7 - Visa Test Card
//	4012 8888 1888 8 - Visa Test Card II
//	3088 0000 0000 0017 - JCB Test Card (Use expiration date 0905) (CURRENTLY NOT TESTING.  ACCOUNT NOT SET TO TEST THIS)
//	3800 0000 0000 06 - Diners Club/Carte Blanche Test (Use expiration date 0905) (CURRENTLY NOT TESTING.  ACCOUNT NOT SET TO TEST THIS)
//	
//	Use any non-expired date for cards without specific expiration dates.
//	
//*/	
//	
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	request.transactionRequest.amount = @"1.11";
//
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//
//	///////////////
//	// 1. Run a regular AUTH_CAPTURE transaction with AmEx card.
//	///////////////
//	request.transactionRequest.payment.creditCard.cardNumber = @"370000000000002";
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from authorize with AmEx (AUTH_ONLY) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for authorize with AmEx (AUTH_ONLY) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");    
//	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.accountType isEqualToString:@"AmericanExpress"],
//				 @"Authorize with AmEx test card didn't return same type in response");
//
//	///////////////
//	// 2. Run a regular AUTH_CAPTURE transaction with Discover Card.
//	///////////////
//	request.transactionRequest.payment.creditCard.cardNumber = @"6011000000000012";
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from authorize with Discover (AUTH_ONLY) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for authorize with Discover (AUTH_ONLY) was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.accountType isEqualToString:@"Discover"],
//				 @"Authorize with Discover test card didn't return same type in response");
//	
//	///////////////
//	// 3. Run a regular AUTH_CAPTURE transaction with MasterCard
//	///////////////
//	request.transactionRequest.payment.creditCard.cardNumber = @"5424000000000015";
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from authorize with MasterCard (AUTH_ONLY) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for authorize with MasterCard (AUTH_ONLY) was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.accountType isEqualToString:@"MasterCard"],
//				 @"Authorize with MasterCard test card didn't return same type in response");
//
//	///////////////
//	// 4. Run a regular AUTH_CAPTURE transaction with Visa Test Card I.
//	///////////////
//	request.transactionRequest.payment.creditCard.cardNumber = @"4007000000027";
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from authorize with VISA (AUTH_ONLY) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for authorize with VISA (AUTH_ONLY) was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.accountType isEqualToString:@"Visa"],
//	@"Authorize with VISA test card didn't return same type in response");
//	
//	///////////////
//	// 5. Run a regular AUTH_CAPTURE transaction with Visa Test Card II
//	///////////////
//	request.transactionRequest.payment.creditCard.cardNumber = @"4012888818888";
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from authorize with VISA (AUTH_ONLY) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for authorize with VISA (AUTH_ONLY) was not APPROVED");
//    createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	STAssertTrue([((CreateTransactionResponse *)an.response).transactionResponse.accountType isEqualToString:@"Visa"],
//				 @"Authorize with VISA test card didn't return same type in response");
//}
//
//- (void) testCreditCardCheck {
//	// Positive tests
//	NSString *cc = @"5328304431046754";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5103312845585953";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5310941494599177";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5502457933980793";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5526386293832793";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//
//	cc = @"5541030109388076";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5160933962299217";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5516418411392004";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5202598727749606";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"5319527039331431";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"4539642231959702";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"4916962068349733";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"4556574648962060";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"4556389698328918";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"4929771078260656";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//	cc = @"4532940023485978";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == YES), @"Luhn Algorithm for credit card should have been valid");
//
//	// Negative tests
//	cc = @"4916971931396181";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == NO), @"Luhn Algorithm for credit card should have been invalid");
//	cc = @"4485099272362583";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == NO), @"Luhn Algorithm for credit card should have been invalid");
//	cc = @"44850992723625823423453453325856467";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == NO), @"Luhn Algorithm for credit card should have been invalid");
//	cc = @"AbCDe12431325";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == NO), @"Luhn Algorithm for credit card should have been invalid");
//	cc = @"44850";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == NO), @"Luhn Algorithm for credit card should have been invalid");
//	cc = @"4916971931396181";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == NO), @"Luhn Algorithm for credit card should have been invalid");
//	cc = @"4485099272362583";
//	STAssertTrue (([CreditCardType isValidCreditCardNumber:cc] == NO), @"Luhn Algorithm for credit card should have been invalid");
//
//}
//
///*
//
//- (void) testCGIEscape {
//	NSString *testString1 = @"☃";
//	// Make sure that escaping the "snowman" character returns the correct escaped string sequence.
//	STAssertTrue(([[AuthNet cgiEscape:testString1] compare:@"%E2%98%83"] == NSOrderedSame), @"cgiEscape not returning correct hex value.");
//}
//
//
//- (void) testPKCS5_PBKDF2 {
//	NSString *password = [NSString stringWithString:@"Some password"];
//	NSString *salt = [NSString stringWithString:@"Some salt"];
//	NSLog(@"testing symmetric encrypt/decrypt ...");
//    
//	NSString *secret = @"this is some secret text";
//	NSData *secretData = [secret dataUsingEncoding:NSASCIIStringEncoding];
//	
//	NSData *key;
//	
//	key = [Encryption getPKCS5_PBKDF2Key:password salt:salt rounds:1000];
//	
//	// Default is CBC not EBC.  Which is what we want.
//	CCOptions padding = kCCOptionPKCS7Padding;
//	NSData *encryptedData = [Encryption encrypt:secretData key:key padding:&padding];
//	NSLog(@"encrypted data: %@", encryptedData);
//	NSData *data = [Encryption decrypt:encryptedData key:key padding:&padding];
//	NSLog(@"decrypted data: %@", data);
//	NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//	NSLog(@"decrypted string: %@", str);
//	NSLog(@"test finished.");
//	
//	STAssertTrue (([secret isEqualToString:str]), @"Decrypted string is not equal to original secret");
//	
//}
//*/
//
//- (void) testGetTransactionDetailsRequest {
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	request.transactionRequest.amount = @"1.23";
//
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1. Attempt to do AUTH_CAPTURE;
//	///////////////
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	if (an.response == nil)
//		return;
//    
//	///////////////
//	// 2. Attempt to getTransactionDetails for the previous transaction;
//	///////////////
//	
//	GetTransactionDetailsRequest *reportingRequest = [GetTransactionDetailsRequest getTransactionDetailsRequest];
//    NSString *transId = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];
//    
//    // This will create another instance of the AuthNet class and effectively destroy the response pointed to by local variable "an".
//    [self setupGetTransactionDetailsRequest:reportingRequest];
//    
//    an = [AuthNet getInstance];
//    
//	reportingRequest.transId = transId;
//    
//    [an getTransactionDetailsRequest:reportingRequest];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//    
//	if (an.response == nil)
//		return;
//}
//
//- (void) testCreateTransactionResponseParser {
//	CreateTransactionResponse *r;
//	r = [CreateTransactionResponse loadCreateTransactionResponseFromFilename:@"CreateTransactionResponse"];
//}
//
//- (void) testLogoutResponseParser {
//	LogoutResponse *l;
//	l = [LogoutResponse loadLogoutResponseFromFilename:@"LogoutResponse"];
//}
//
//- (void) testMobileDeviceLoginResponseParser {
//	MobileDeviceLoginResponse *m;
//	m = [MobileDeviceLoginResponse loadMobileDeviceLoginResponseFromFilename:@"MobileDeviceLoginResponse"];
//}
//
//- (void) testMobileDeviceRegistrationResponseParser {
//	MobileDeviceRegistrationResponse *m;
//	m = [MobileDeviceRegistrationResponse loadMobileDeviceRegistrationResponseFromFilename:@"MobileDeviceRegistrationResponse"];
//}
//
//
//- (void) testGetBatchStatisticsResponseParser {
//	GetBatchStatisticsResponse *p;
//	p = [GetBatchStatisticsResponse loadGetBatchStatisticsResponseFromFilename:@"GetBatchStatisticsResponse"];
//    NSLog(@"GetBatchStatisticsResponse = %@", p);
//}
//
//
//- (void) testTransactionDetailsResponseParser {
//	GetTransactionDetailsResponse *td;
//	td = [GetTransactionDetailsResponse loadTransactionDetailFromFilename:@"GetTransactionDetailsResponse"];
//}
//
//- (void) testGetSettledBatchListResponseParser {
//	GetSettledBatchListResponse *p;
//	p = [GetSettledBatchListResponse loadGetSettledBatchListResponseFromFilename:@"GetSettledBatchListResponse"];
//    NSLog(@"GetSettledBatchListResponse = %@", p);
//}
//
//
//- (void) testGetTransactionListResponseParser {
//	GetTransactionListResponse *p;
//	p = [GetTransactionListResponse loadGetTransactionListResponseFromFilename:@"GetTransactionListResponse"];
//    NSLog(@"GetTransactionListResponse = %@", p);
//}
//
//
//- (void) testGetUnsettledTransactionListResponseParser {
//	GetUnsettledTransactionListResponse *p;
//	p = [GetUnsettledTransactionListResponse loadGetUnsettledTransactionListResponseFromFilename:@"GetUnsettledTransactionListResponse"];
//    NSLog(@"GetUnsettledTransactionListResponse = %@", p);
//}
//
//- (void) testSendCustomerTransactionReceiptResponseParser {
//	SendCustomerTransactionReceiptResponse *s;
//	s = [SendCustomerTransactionReceiptResponse loadSendCustomerTransactionReceiptResponseFromFilename:@"SendCustomerTransactionReceiptResponse"];
//    NSLog(@"SendCustomerTransactionReceiptResponse = %@", s);
//}
//
//
//- (void) testGetSettledBatchListRequest {
//	
//	///////////////
//	// 1. Attempt to getSettleBatchListRequest for the batch list;
//	///////////////
//	
//	GetSettledBatchListRequest *reportingRequest = [GetSettledBatchListRequest getSettlementBatchListRequest];
//    [self setupGetSettledBatchListRequest:reportingRequest];
//
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//    
//    [an getSettledBatchListRequest:reportingRequest];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//    STAssertTrue((an.response != nil), @"Response from Get Settled Batch List should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code Get Settled Batch List was not APPROVED");
//    
//	if (an.response == nil)
//		return;
//    
//    NSLog(@"GetSettledBatchListResponse = %@", an.response);
//}
//
//
//- (void) testGetTransactionListRequest {
//	
//	///////////////
//	// 1. Attempt to getSettleBatchListRequest for the batch list;
//	///////////////
//	
//	GetSettledBatchListRequest *reportingRequest = [GetSettledBatchListRequest getSettlementBatchListRequest];
//    [self setupGetSettledBatchListRequest:reportingRequest];
//    
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//    
//    [an getSettledBatchListRequest:reportingRequest];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Get Settled Batch List should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code Get Settled Batch List was not APPROVED");
//    
//	if (an.response == nil)
//		return;
//    
//    NSLog(@"GetSettledBatchListResponse = %@", an.response);
//
//	///////////////
//	// 2. Attempt to getTransactionList for the batches returned from the previous call;
//	///////////////	
//    
//    NSMutableArray *batches = [NSMutableArray arrayWithArray:((GetSettledBatchListResponse *)an.response).batchList];
//
//    GetTransactionListRequest *request = [GetTransactionListRequest getTransactionListRequest];
//    [self setupGetTransactionListRequest:request];
//    
//    an = [AuthNet getInstance];
//    
//    int i = 0;
//    for (BatchDetailsType *b in batches) {
//        
//        // Let's just fetch 2 batches.
//        if (i > 2)
//            continue;
//        
//        request.batchId = b.batchId;
//        [an getTransactionListRequest:request];
//        while (an.isPendingResponse == YES || an.response == nil) {
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//        }	
//        STAssertTrue((an.response != nil), @"Response from Get Transaction List should not be nil!");
//        STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Result code for Get Transaction List was not APPROVED");
//        
//        if (an.response == nil)
//            return;
//        
//        NSLog(@"Batch %@: Response = %@", b.batchId, an.response);
//        
//        i++;
//    }
//}
//
//
//
//- (void) testGetBatchStatisticsRequest {
//	///////////////
//	// 1. Attempt to getSettleBatchListRequest for the batch list;
//	///////////////
//	
//	GetSettledBatchListRequest *reportingRequest = [GetSettledBatchListRequest getSettlementBatchListRequest];
//    [self setupGetSettledBatchListRequest:reportingRequest];
//    
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//    [an getSettledBatchListRequest:reportingRequest];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Get Settled Batch List should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code Get Settled Batch List was not APPROVED");
//    
//	if (an.response == nil)
//		return;
//    
//    NSLog(@"GetSettledBatchListResponse = %@", an.response);
//    
//	///////////////
//	// 2. Attempt to getTransactionList for the batches returned from the previous call;
//	///////////////	
//    
//    NSMutableArray *batches = [NSMutableArray arrayWithArray:((GetSettledBatchListResponse *)an.response).batchList];
//    
//    GetBatchStatisticsRequest *request = [GetBatchStatisticsRequest getBatchStatisticsRequest];
//    [self setupGetBatchStatisticsRequest:request];
//    
//    
//    an = [AuthNet getInstance];
//    
//    int i = 0;
//    for (BatchDetailsType *b in batches) {
//        
//        // Let's just fetch 2 batches.
//        if (i > 2)
//            continue;
//        
//        request.batchId = b.batchId;
//        [an getBatchStatisticsRequest:request];
//        while (an.isPendingResponse == YES || an.response == nil) {
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//        }	
//        STAssertTrue((an.response != nil), @"Response from Get Transaction List should not be nil!");
//        STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Result code for Get Transaction List was not APPROVED");
//        
//        if (an.response == nil)
//            return;
//        
//        NSLog(@"Batch %@: Response = %@", b.batchId, an.response);
//        
//        i++;
//    }
//}
//
//
// 
//- (void) testGetUnsettledTransactionListRequest {
//	
//	///////////////
//	// 1. Attempt to getSettleBatchListRequest for the batch list;
//	///////////////
//	
//	GetUnsettledTransactionListRequest *reportingRequest = [GetUnsettledTransactionListRequest getUnsettledTransactionListRequest];
//    [self setupGetUnsettledTransactionListRequest:reportingRequest];
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//    
//    [an getUnsettledTransactionListRequest:reportingRequest];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Get Settled Batch List should not be nil!");
//	STAssertTrue([((GetUnsettledTransactionListResponse *)an.response).anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code Get Settled Batch List was not APPROVED");
//    
//	if (an.response == nil)
//		return;
//    
//    NSLog(@"GetUnsettledTransactionListResponse = %@", an.response);
//    
//}
//
//- (void) testVoidingAllUnsettledTransactions {
//	
//	///////////////
//	// 1. Attempt to getSettleBatchListRequest for the batch list;
//	///////////////
//	
//	GetUnsettledTransactionListRequest *reportingRequest = [GetUnsettledTransactionListRequest getUnsettledTransactionListRequest];
//    [self setupGetUnsettledTransactionListRequest:reportingRequest];
//    CreateTransactionRequest *r = [CreateTransactionRequest createTransactionRequest];
//    [self setupSimpleRequest:r];
//    
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//    
//    [an getUnsettledTransactionListRequest:reportingRequest];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Get Settled Batch List should not be nil!");
//	STAssertTrue([((GetUnsettledTransactionListResponse *)an.response).anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code Get Settled Batch List was not APPROVED");
//    
//	if (an.response == nil)
//		return;
//
//    NSLog(@"GetUnsettledTransactionListResponse = %@", an.response);
//    
//    
//    NSArray *tarray = [NSArray arrayWithArray:((GetUnsettledTransactionListResponse *)an.response).transactions];
//    for (TransactionSummaryType *t in tarray) {
//        
//        r.transactionRequest.refTransId = t.transId;
//        [an voidWithRequest:r];
//        
//        while (an.isPendingResponse == YES || an.response == nil) {
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//        }	
//        STAssertTrue((an.response != nil), @"Response from Get Settled Batch List should not be nil!");
//        STAssertTrue([((GetUnsettledTransactionListResponse *)an.response).anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code Get Settled Batch List was not APPROVED");
//    }
//    
//}
//
//
//- (void) testSendCustomerTransactionReceipt {
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	
//	request.transactionRequest.amount = @"1.23";
//    
//    AuthNet *an = [AuthNet getInstance];
//	an.duplicateWindowValue = 1;
//	
//	///////////////
//	// 1. Attempt to do AUTH_CAPTURE;
//	///////////////
//	[an purchaseWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	STAssertTrue((an.response != nil), @"Response from Purchase(AUTH_CAPTURE) transaction should not be nil!");
//	STAssertTrue([an.response.anetApiResponse.messages.resultCode isEqualToString:@"Ok"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//    CreateTransactionResponse *createTransactionResponse = (CreateTransactionResponse *)an.response;
//	STAssertTrue([createTransactionResponse.transactionResponse.responseCode isEqualToString:@"1"], @"Response Code for Purchase(AUTH_CAPTURE) was not APPROVED");
//	if (an.response == nil)
//		return;
//    
//	///////////////
//	// 2. Attempt to sendCustomerTransactionReceipt for the previous transaction;
//	///////////////
//	
//	SendCustomerTransactionReceiptRequest *emailRequest = [SendCustomerTransactionReceiptRequest sendCustomerTransactionReceiptRequest];
//    NSString *transId = [NSString stringWithString:((CreateTransactionResponse *)an.response).transactionResponse.transId];
//    
//    // This will create another instance of the AuthNet class and effectively destroy the response pointed to by local variable "an".
//    [self setupSendCustomerTransactionReceiptRequest:emailRequest];
//    
//    an = [AuthNet getInstance];
//    
//	emailRequest.transId = transId;
//    
//    [an sendCustomerTransactionReceiptRequest:emailRequest];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//    
//    NSLog(@"SendCustomerTransactionReceipt = %@", an.response);
//	if (an.response == nil)
//		return;
//}
//
//
//- (void)testStringWithEscapedXMLValue {
//    NSString *testString = @"\"'<>&a quick fox jumped over the lazy dog.";
//    NSString *escapedString = @"&quot;&apos;&lt;&gt;&amp;a quick fox jumped over the lazy dog.";
//    NSString *resultString = [NSString stringWithEscapedXMLValue:testString];
//    NSLog(@"escaped string = %@", escapedString);
//    NSLog(@"result string = %@", resultString);
//    STAssertTrue([escapedString isEqualToString:resultString], @"Error escaping XML value");
//}
//
//- (void)testStringwithXMLTag {
//    NSString *escapedXMLTag = @"<Tag1>&quot;My quoted string is &gt; than yours!&quot;</Tag1>";
//    NSString *result = [NSString stringWithXMLTag:@"Tag1" andValue:@"\"My quoted string is > than yours!\""];
//    NSLog(@"result = %@", result);
//    STAssertTrue([escapedXMLTag isEqualToString:result], @"Error generating XML tag.");
//    
//}
//
//#ifdef FULLTEST
//
//// TODO:
//// Test not complete since currently the API is not returning the SplitTenderPayments section in the response. 
//- (void) testPartialAuthorization {
//	CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//	[self setupRequest:request];
//	request.transactionType = AUTH_ONLY;
//    
//	request.transactionRequest.amount = @"12.00";
//	[request addTransactionSetting:@"allowPartialAuth" withValue:@"true"];
//	request.transactionRequest.billTo.zip = @"46225";  // Magic zip code to test split tender payments
//	
//    AuthNet *an = [AuthNet getSharedInstance];
//	an.duplicateWindowValue = 1;
//
//	NSLog(@"request = %@", [request stringOfXMLRequest]);
//		
//	[an authorizeWithRequest:request];
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//	
//	if (an.response == nil)
//		return;
//    
//    NSLog(@"response SplitTender Id = %@", ((CreateTransactionResponse *) an.response).transactionResponse.splitTenderId);
//    request.transactionID = nil;
//    request.splitTenderId = ((CreateTransactionResponse *) an.response).transactionResponse.splitTenderId;
//    
//    request.transactionType = AUTH_CAPTURE;
////    request.creditCard = nil;
//    [an purchaseWithRequest:request];
//    
//	while (an.isPendingResponse == YES || an.response == nil) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:RUN_UNTIL_TIME]];
//	}	
//
//	if (an.response == nil)
//		return;
//
//    NSLog(@"RESPONSE %@", an.response);
//}
//#endif
//
//#else                           // all code under test must be linked into the Unit Test bundle
//
//- (void) testMath {
//    
//    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
//    
//}
//
//
//#endif
//
//@end
