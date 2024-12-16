//
//  AuthNet.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 8/3/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

/**
 *  Authorize.Net Mobile Payment singleton.
 *  This is the singleton class created for doing
 *  AIM transactions with Authorize.Net.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ANetApiRequest.h"
#import "ANetApiResponse.h"
#import "AuthNetMessage.h"
#import "AuthNetRequest.h"
#import "AuthNetResponse.h"
#import "BankAccountType.h"
#import "BankAccountMaskedType.h"
#import "BatchDetailsType.h"
#import "BatchStatisticType.h"
#import "CCAuthenticationType.h"
#import "CreditCardType.h"
#import "CreditCardMaskedType.h"
#import "CreditCardTrackType.h"
#import "CustomerAddressType.h"
#import "CustomerDataType.h"
#import "Error.h"
#import "ExtendedAmountType.h"
#import "FDSFilterType.h"
#import "LineItemType.h"
#import "MerchantAuthenticationType.h"
#import "MerchantContactType.h"
#import "Messages.h"
#import "MobileDeviceType.h"
#import "NameAndAddressType.h"
#import "OrderExType.h"
#import "OrderType.h"
#import "PaymentType.h"
#import "PaymentMaskedType.h"
#import "PermissionType.h"
#import "SplitTenderPayment.h"
#import "TransactionDetailsType.h"
#import "TransactionRequestType.h"
#import "TransactionResponse.h"
#import "TransactionSummaryType.h"
#import "TransRetailInfoType.h"
#import "SettingType.h"
#import "UserField.h"

#import "CreateTransactionRequest.h"
#import "CreateTransactionResponse.h"
#import "GetBatchStatisticsRequest.h"
#import "GetBatchStatisticsResponse.h"
#import "GetMerchantDetailsRequest.h"
#import "GetSettledBatchListRequest.h"
#import "GetSettledBatchListResponse.h"
#import "GetTransactionDetailsRequest.h"
#import "GetTransactionDetailsResponse.h"
#import "GetTransactionListRequest.h"
#import "GetTransactionListResponse.h"
#import "GetUnsettledTransactionListRequest.h"
#import "GetUnsettledTransactionListResponse.h"
#import "LogoutRequest.h"
#import "LogoutResponse.h"
#import "MobileDeviceLoginRequest.h"
#import "MobileDeviceLoginResponse.h"
#import "MobileDeviceRegistrationRequest.h"
#import "MobileDeviceRegistrationResponse.h"
#import "GetMerchantDetailsResponse.h"
#import "SendCustomerTransactionReceiptRequest.h"
#import "SendCustomerTransactionReceiptResponse.h"
#import "TestAccountCaptchaRequest.h"
#import "TestAccountCaptchaResponse.h"
#import "TestAccountRegistrationRequest.h"
#import "TestAccountRegistrationResponse.h"
#import "AnetEMVTransactionResponse.h"
#import "AnetCustomerProfileTransactionResponse.h"
#import "AnetUpdateCustomerProfileResponse.h"
#import "AnetCreateCustomerPaymentProfileResponse.h"
#import "AnetCustomerProfileError.h"
#import "AnetUpdateCustomerPaymentProfileResponse.h"
#import "AnetGetCustomerPaymentProfileResponse.h"
#import "AnetGetCustomerProfileResponse.h"

extern NSString *kTestURL;
extern NSString *kLiveURL;

@class MerchantAuthenticationType;

/**
 * The LIVE or TEST server
 *
 */
typedef enum AuthNetEnvironment {
	ENV_LIVE,
	ENV_TEST,
} AUTHNET_ENVIRONMENT;


/**
 * AuthNet Delegate methods for each transaction paths.
 */
@protocol AuthNetDelegate <NSObject>
@optional
/**
 * Optional delegate: method is called when a CreateTransactionResponse response is returned from the server, including
 * non processing of payment.
 */
- (void) emvPaymentSucceeded:(AnetEMVTransactionResponse *)response;
/**
 * Optional delegate: method is called when a CreateTransactionResponse response is returned from the server, including
 * non processing of payment.
 */
- (void) paymentSucceeded:(CreateTransactionResponse *)response;

/**
 * Optional delegate: method is called when a non is CreateTransactionResponse is returned from the server.  
 * The errorType data member of response should indicate TRANSACTION_ERROR or SERVER_ERROR.  
 * TRANSACTION_ERROR are non-APRROVED response code.  SERVER_ERROR are due to non
 * non gateway responses.  Typically these are non successful HTTP responses.  The actual
 * HTTP response is returned in the AuthNetResponse object's responseReasonText instance variable.
 */
- (void) requestFailed:(AuthNetResponse *)response;
/**
 * Optional delegate: method is called when a connection error occurs while connecting to the server..  
 * The errorType data member of response should indicate CONNECTION_ERROR.  More detail
 * may be included in the AuthNetResponse object's responseReasonText.
 */
- (void) connectionFailed:(AuthNetResponse *)response;

// REPORTING DELEGATE METHODS
/**
 * Optional delegate: method is called when a GetBatchStatisticsResponse response is returned from the server,
 * including GetBatchStatisticsResponse error responses.
 */
- (void) getBatchStatisticsSucceeded:(GetBatchStatisticsResponse *)response;
/**
 * Optional delegate: method is called when a GetSettledBatchListResponse response is returned from the server,
 * including GetSettledBatchListResponse error responses.
 */
- (void) getSettledBatchListSucceeded:(GetSettledBatchListResponse *)response;
/**
 * Optional delegate: method is called when a GetTransactionDetailsResponse response is returned from the server,
 * including GetTransactionDetailsResponse error responses.
 */
- (void) getTransactionDetailsSucceeded:(GetTransactionDetailsResponse *)response;
/**
 * Optional delegate: method is called when a GetTransactionListResponse response is returned from the server,
 * including GetTransactionListResponse error responses.
 */
- (void) getTransactionListSucceeded:(GetTransactionListResponse *)response;
/**
 * Optional delegate: method is called when a GetUnsettledTransactionListResponse response is returned from the server,
 * including GetUnsettledTransactionListResponse error responses.
 */
- (void) getUnsettledTransactionListSucceeded:(GetUnsettledTransactionListResponse *)response;

// EMAIL RECEIPT DELEGATE METHOD
/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) sendCustomerTransactionReceiptSucceeded:(SendCustomerTransactionReceiptResponse *)response;

// GET MERCHANT DETAILS METHOD
/**
 * Optional delegate: method is called when a GETMERCHANTDETAILS response is returned from the server,
 * including GetMerchantDetailsResponse error responses.
 */
- (void) getMerchantDetailsResponseSucceeded:(GetMerchantDetailsResponse *)response;

// MOBILE DELEGATE METHODS
/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response;

// MOBILE DELEGATE METHODS
/**
 * Optional delegate: method is called when a cpatchaImage response is returned from the server,
 * including CaptchaImage error responses.
 */
 - (void) CaptchaImageSucceeded:(TestAccountCaptchaResponse *)response;

// Customer Profile DELEGATE METHODS
/**
 * Optional delegate: method is called when a createCustomerProfileTransaction response is returned from the server,
 * including status and error responses.
 */
- (void) createCustomerProfileTransactionSucceeded:(AnetCustomerProfileTransactionResponse *)response withError:(AnetCustomerProfileError *)error;

/**
 * Optional delegate: method is called when a updateCustomerProfile response is returned from the server,
 * including status and error responses.
 */
- (void) updateCustomerProfileSucceeded:(AnetUpdateCustomerProfileResponse *)response withError:(AnetCustomerProfileError *)error;

/**
 * Optional delegate: method is called when a createCustomerPaymentProfile response is returned from the server,
 * including status and error responses.
 */
- (void) createCustomerPaymentProfileSucceeded:(AnetCreateCustomerPaymentProfileResponse *)response withError:(AnetCustomerProfileError *)error;

/**
 * Optional delegate: method is called when a updateCustomerProfile response is returned from the server,
 * including status and error responses.
 */
- (void) updateCustomerPaymentProfileSucceeded:(AnetUpdateCustomerPaymentProfileResponse *)response withError:(AnetCustomerProfileError *)error;

/**
 * Optional delegate: method is called when a updateCustomerProfile response is returned from the server,
 * including status and error responses.
 */
- (void) getCustomerProfileSucceeded:(AnetGetCustomerProfileResponse *)response withError:(AnetCustomerProfileError *)error;

/**
 * Optional delegate: method is called when a updateCustomerProfile response is returned from the server,
 * including status and error responses.
 */
- (void) getCustomerPaymentProfileSucceeded:(AnetGetCustomerPaymentProfileResponse *)response withError:(AnetCustomerProfileError *)error;

// MOBILE DELEGATE METHODS
/**
 * Optional delegate: method is called when a testAccountRegistration response is returned from the server,
 * including Account creation status and error responses.
 */
- (void) testAccountRegistrationSucceeded:(TestAccountRegistrationResponse *)response;
/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) mobileDeviceRegistrationSucceeded:(MobileDeviceRegistrationResponse *)response;
/**
 * Optional delegate: method is called when a LogoutResponse response is returned from the server,
 * including LogoutResponse error responses.
 */
- (void) logoutSucceeded:(LogoutResponse *)response;
@end

/**
 * The main AuthNet module that handles the request/response handling of the
 * various Authorize.Net Gateway APIs
 */

@interface AuthNet : NSObject {
@private
    /**
	 * request The current outstanding request. 
	 */
	AuthNetRequest *request;   
	/**
	 * environment Determine whether we are hitting the live or test servers.
	 */
    AUTHNET_ENVIRONMENT environment;

	/**
	 * merchantAuthentication MerchantAuthentication object that holds the username/password login information.
	 */
	MerchantAuthenticationType *merchantAuthentication;
	/**
	 * sessionToken SessionToken that is used to interact with the API Gateway.
	 */
	NSString *sessionToken;	
	/**
	 * isPendingResponse Indicate there is still an outstanding Authorize.Net API request.  
	 * No new request will be initiated till the outstanding finishes.
	 */	
	BOOL isPendingResponse;
	/**
	 * merchantFields The dictionary of merchant defined fields.
	 */	
	NSMutableDictionary *merchantFields;
	/**
	 * requestType The current outstand request's API Request message type.  
	 * This variable is needed to distinguish the NSURLConnection response and process them appropriately
	 */		
	NSInteger requestType;
    /**
	 * response The response to the last request.  
	 * An application may use the response to retrieve the various fields of the response.
	 */	
	AuthNetResponse *response;
}

@property (nonatomic, weak) id <AuthNetDelegate> delegate;
@property (nonatomic, strong) AuthNetRequest *request;
@property (nonatomic) AUTHNET_ENVIRONMENT environment;
@property (nonatomic, strong) MerchantAuthenticationType *merchantAuthentication;
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic) BOOL isPendingResponse;
@property (nonatomic, strong) AuthNetResponse *response;
@property (nonatomic, readonly) SEL checkoutSelector;
@property (nonatomic, retain) NSMutableDictionary *merchantFields;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) NSURLSession *session;


/**
 * Initialization of the AuthNet Singleton with the development server type.
 * @param e The environment either live or test server.
 */
+(AuthNet *)authNetWithEnvironment:(AUTHNET_ENVIRONMENT)e;

/**
 * Get reference to singleton.
 */
+(AuthNet *)getInstance;

/**
 * Set Delegate to controller. 
 * @param vc The Class that should be the delegate for AuthNetDelegate methods.
 */
+ (void) setDelegate:(id<AuthNetDelegate>)vc;

// The following APIs are meant for making transactions
// at the payment gateway without invoking the
// modal mobile payment checkout UI.
// NOTE: Implementing the AuthNetDelegate protocol
// is still possible for receiving transaction responses.
/**
 * Perform AUTH transaction with request.
 * @param r The request to send.
 */
- (void) authorizeWithRequest:(CreateTransactionRequest *)r;

/**
 * Perform AUTH_CAPTURE transaction with request.
 * @param r The request to send.
 */
- (void) purchaseWithRequest:(CreateTransactionRequest *)r;

/**
 * Perform PRIOR_AUTH_CAPTURE transaction with request.
 * @param r The request to send.
 */
- (void) captureWithRequest:(CreateTransactionRequest *)r;

/**
 * Perform CAPTURE_ONLY transaction with request.
 * NOTE: The 's authCode must be set.
 * @param r The request to send.
 */
- (void) captureOnlyWithRequest:(CreateTransactionRequest *)r;

/**
 * Perform VOID transaction with request.
 * @param r The request to send.
 */
- (void) voidWithRequest:(CreateTransactionRequest *)r;

/**
 * Perform CREDIT transaction with request.
 * @param r The request to send.
 */
- (void) creditWithRequest:(CreateTransactionRequest *)r;

/**
 * Perform unlinked CREDIT transaction with request.
 * NOTE: The  should not include an x_trans_id or a 
 * regular CREDIT request will be attempted.
 * @param r The request to send.
 */
- (void) unlinkedCreditWithRequest:(CreateTransactionRequest *)r;

////////////////////////
//REPORTING API CALLS
///////////////////////
/**
 * Perform getSettledBatchListRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getBatchStatisticsRequest:(GetBatchStatisticsRequest *) r;

/**
 * Perform getSettledBatchListRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getSettledBatchListRequest:(GetSettledBatchListRequest *) r;

/**
 * Perform getTransactionDetailsRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getTransactionDetailsRequest:(GetTransactionDetailsRequest *) r;

/**
 * Perform getTransactionDetailsRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getTransactionListRequest:(GetTransactionListRequest *) r;

/**
 * Perform getUnsettledTransactionListRequest on the Reporting API.
 * @param r The reporting request to send.
 */
- (void) getUnsettledTransactionListRequest:(GetUnsettledTransactionListRequest *) r;

////////////////////////
//EMAIL RECEIPT CALL
///////////////////////
/**
 * Perform sendCustomerTransactionReceiptRequest on the AIM API.
 * @param r The request to send.
 */
- (void) sendCustomerTransactionReceiptRequest:(SendCustomerTransactionReceiptRequest *) r;

////////////////////////
//GET MERCHANT DETAILS
///////////////////////
/**
 * Perform getMerchantDetailsRequest on the AIM API.
 * @param r The request to send.
 */
- (void) getMerchantDetailsRequest:(GetMerchantDetailsRequest *) r;

////////////////////////
//MOBILE API CALLS
///////////////////////
/**
 * Perform mobileDeviceLoginRequest on the AIM API.
 * @param r The request to send.
 */
- (void) mobileDeviceLoginRequest:(MobileDeviceLoginRequest *)r;

/**
 * Perform mobileDeviceRegistrationRequest on the AIM API.
 * @param r The request to send.
 */
- (void) mobileDeviceRegistrationRequest:(MobileDeviceRegistrationRequest *) r;

/**
 * Perform logoutRequest on the AIM API.
 * @param r The request to send.
 */
- (void) LogoutRequest:(LogoutRequest *)r;

/**
 * Perform TestAccountCaptchaRequest on the mobile web service.
 * @param r The request to send.
 */
- (void) GetCaptchaRequest:(TestAccountCaptchaRequest *)r;

/**
 * Perform TestAccountRegistrationRequest on the mobile web service.
 * @param r The request to send.
 */
- (void) testAccountRegistrationRequest:(TestAccountRegistrationRequest *)r;

/**
 * Method for enabling/disabling logging.
 * @param iEnableLogging Flag to toggle logging, if enbled the logs will in EMV_SDK_Logs.txt under NSDocumentDirectory
  * file is excluded from iCloud backup
 */
- (void)setLoggingEnabled:(BOOL)iEnableLogging;

/**
 * Method for getting logging status
 * @returns A flag, status of logging
 */
- (BOOL)loggingEnabled;

@end


