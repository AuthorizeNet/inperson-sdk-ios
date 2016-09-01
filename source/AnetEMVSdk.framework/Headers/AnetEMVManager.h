//
//  AnetEMVManager.h
//  AnetEMVSdk
//
//  Created by Pankaj Taneja on 10/23/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnetEMVTransactionRequest.h"
#import <Foundation/Foundation.h>

@class AnetEMVError;
@class AnetEMVTransactionResponse;

typedef NS_ENUM (NSInteger, ANETEmvErrorCode) {
    ANETEmvTransactionTerminated = 1,
    ANETEmvTransactionDeclined,
    ANETEmvTransactionSetAmountCancelOrTimeout,
    ANETEmvTransactionCapkFail,
    ANETEmvTransactionNotIcc,
    ANETEmvTransactionCardBlocked,
    ANETEmvTransactionDeviceError,
    ANETEmvTransactionCardNotSupported,
    ANETEmvTransactionMissingMandatoryData,
    ANETEmvTransactionNoEmvApps,
    ANETEmvTransactionInvalidIccData,
    ANETEmvTransactionConditionsOfUseNotSatisfied,
    ANETEmvTransactionApplicationBlocked,
    ANETEmvTransactionEmvTransactionIccCardRemoved,
    ANETEmvErrorTypeInvalidInput,
    ANETEmvErrorTypeInvalidInput_NotNumeric,
    ANETEmvErrorTypeInvalidInput_InputValueOutOfRange,
    ANETEmvErrorTypeInvalidInput_InvalidDataFormat,
    ANETEmvErrorTypeInvalidInput_NoAcceptAmountForThisTransactionType,
    ANETEmvErrorTypeInvalidInput_NotAcceptCashbackForThisTransactionType,
    ANETEmvErrorTypeDeviceReset,
    ANETEmvErrorTypeUnknown,
    ANETEmvErrorTypeAudioFailToStart,
    ANETEmvErrorTypeAudioNotYetStarted,
    ANETEmvErrorTypeIllegalStateException,
    ANETEmvErrorTypeCommandNotAvailable,
    ANETEmvErrorTypeAudioRecordingPermissionDenied,
    ANETEmvErrorTypeBackgroundTimeout,
    ANETEmvErrorTypeAudioFailToStart_OtherAudioIsPlaying,
    ANETEmvErrorTypeRequestTimedout,
    ANETEmvErrorTypeSessionTimedout,
    AnetEmvErrorDeviceNotResponding
};

/**
 The completion handler, if provided, will be invoked on completion of EMV transaction
 * @param response AnetEMVTransactionResponse response object 
 * @param error AnetEMVError error object, on successful transaction this object will be Nil
 */
typedef void (^RequestCompletionBlock) (AnetEMVTransactionResponse * _Nullable response, AnetEMVError *_Nullable error);

/**
 The completion handler, if provided, will be invoked if cancel action is taken during the process
*/
typedef void (^CancelActionBlock) ();

@interface AnetEMVManager : NSObject

/**
 * Method for enabling/disabling logging.
 * @param iEnableLogging Flag to toggle logging, if enabled the logs will in EMV_SDK_Logs.txt under NSDocumentDirectory
 * file is excluded from iCloud backup
 */
- (void)setLoggingEnabled:(BOOL)iEnableLogging;

/**
 * Method for getting logging status
 * @returns A flag, status of logging
 */
- (BOOL)loggingEnabled;

/**
 * Initializer with Currency code and Terminal Id.
 * @param iCurrencyCode three digits of the currency code, e.g. “840” for USD
 * @param iTerminalID Merchant ternimal ID
 * @param iSkipSignature Skip Signature. EMV transactions are mandate to capture the cardholder signature for offline authentication.
 * @param iShowReceipt Show receipt. Some EMV transactions are mandate to capture the receipt.
 * @returns A new AnetEMVManager.
 */
+ (instancetype _Nonnull)initWithCurrecyCode:(NSString * _Nonnull)iCurrencyCode
                                  terminalID:(NSString * _Nonnull)iTerminalID
                               skipSignature:(BOOL)iSkipSignature
                                 showReceipt:(BOOL)iShowReceipt;

/**
 * Static method for AnetEMVManager sharedInstance.
 * @returns A sharedInstance AnetEMVManager.
 */
+ (AnetEMVManager * _Nonnull)sharedInstance;

/**
 * TransactionRequest.
 * @returns A AnetEMVTransactionRequest instance.
 */
- (AnetEMVTransactionRequest * _Nonnull)transactionRequest;

/**
 * Start an EMV transaction wuth EMV request, presenting view controller and completion block.
 * @param iTransactionRequest A request object of AnetEMVTransactionRequest
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 * @param iCompletionBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @param iDismissControllerBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @returns A new AnetEMVManager.
 */
- (void)startEMVWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest
               presentingViewController:(UIViewController * _Nonnull)iPresentingController
                    completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock
                        andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock;
@end

