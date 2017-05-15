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
    AnetEmvErrorDeviceNotResponding,
    ANETEmvErrorCouldNotRetrieveCardData
};

typedef NS_ENUM (NSInteger, AnetEMVCardInteractionProgress) {
    AnetEMVWaitingForCard,
    AnetEMVRetryInsertOrSwipe,
    AnetEMVSwipeOrTryAnotherCard,
    AnetEMVSwipe,
    AnetEMVProcessingCard,
    AnetEMVDoneWithCard,
};

typedef NS_ENUM (NSInteger, AnetEMVTerminalMode) {
    AnetEMVModeSwipe,
    AnetEMVModeInsertOrSwipe
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

/**
 The completion handler, Will be executed once CARD intercation is successful with SDK
 */
typedef void (^CardIntercationProgressBlock) (AnetEMVCardInteractionProgress progressState);

/**
 The completion handler, Will be executed once CARD intercation is successful with SDK
 */
typedef void (^CardIntercationCompletionBlock) (BOOL isSuccess, AnetEMVError *_Nullable error);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^ReaderDeviceInfoBlock)(NSDictionary * _Nonnull deviceInfo);


@interface AnetEMVManager : NSObject

/**
 * Method for retrieving SDK version
 * @returns SDK version
 */
+ (NSString * _Nonnull)anetSDKVersion;

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
 * Method for setting the terminal mode.
 * @param iTerminalMode Terminal mode can be swipe or insertOrSwipe, if value is AnetEMVModeSwipe, SDK will only accept MSR/swipe transaction
 */
- (void)setTerminalMode:(AnetEMVTerminalMode)iTerminalMode;

/**
 * Method for getting AnyWhereReaderInfo
 * @param iReaderDeviceInfoBlock A block will be executed with the device info
 */
- (void)getAnyWhereReaderInfo:(ReaderDeviceInfoBlock _Nonnull)iReaderDeviceInfoBlock;

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
 * Start an EMV transaction with EMV request, presenting view controller and completion block.
 * @param iTransactionRequest A request object of AnetEMVTransactionRequest
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 * @param iRequestCompletionBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @param iCancelActionBlock A Cancel block. Block will be executed when cancel action is taken
 */
- (void)startEMVWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest
               presentingViewController:(UIViewController * _Nonnull)iPresentingController
                    completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock
                        andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock;

/**
 * Start a Quick Chip transaction in background with presenting view controller, this will interact with the card to accept the insert/swipe, Card interaction message like insert or remove the card should be shown by merchant app.
 * @param iViewController A presenting controller object. EMV controller will be presented on top of it
 * @param iEmvTransactionType Transaction Type
 * @param iCardInteractionProgressBlock A Card Intercation progress block. Block wil be executed on successful retreival of card data by SDK
 * @param iCardIntercationCompletionBlock A Card Intercation completion block. Block wil be executed on successful retreival of card data by SDK
 */
- (void)readQuickChipCardDataWithPredeterminedAmountOnViewController:(UIViewController * _Nonnull)iViewController
                                                     transactionType:(EMVTransactionType)iEmvTransactionType
                                    withCardInteractionProgressBlock:(CardIntercationProgressBlock _Nonnull)iCardInteractionProgressBlock
                                        andCardIntercationCompletionBlock:(CardIntercationCompletionBlock _Nonnull)iCardIntercationCompletionBlock;

/**
 * Discard the previously processed card data. If merchant application called readQuickChipCardDataWithPredeterminedAmountOnViewController and now it doesn't want to process that card then this method should be called to discard that card.
 */
- (BOOL)discardQuickChipCardDataWithPredeterminedAmount;

/**
 * Start a Quick Chip transaction with EMV request, presenting view controller and completion block.
 * @param iTransactionRequest A request object of AnetEMVTransactionRequest
 * @param iPaperReceiptCase if this is true then the Merchant needs to get the paper receipt signed by the customer and settle the transaction later on. 
                            AnetEMVManager will leave the trasaction in Auth_Only state.
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 * @param iRequestCompletionBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @param iCancelActionBlock A Cancel block. Block will be executed when cancel action is taken
 */
- (void)startQuickChipWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest
                         forPaperReceiptCase:(BOOL)iPaperReceiptCase
              presentingViewController:(UIViewController * _Nonnull)iPresentingController
                       completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock
                  andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock;

/**
 * Start a Quick Chip transaction with EMV request, presenting view controller and completion block.
 * @param iTransactionRequest A request object of AnetEMVTransactionRequest
 * @param iTipAmount A tip amount which will be added to the total amount and captured
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 * @param iRequestCompletionBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @param iCancelActionBlock A Cancel block. Block will be executed when cancel action is taken
 */
- (void)startQuickChipWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest
                                   tipAmount:(NSString * _Nonnull)iTipAmount
                    presentingViewController:(UIViewController * _Nonnull)iPresentingController
                             completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock
                        andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock;

/**
 * Start a Quick Chip transaction with EMV request, presenting view controller and completion block.
 * @param iTransactionRequest A request object of AnetEMVTransactionRequest
 * @param iTipOptions Tip options which will be presented on Signature screen to allow user to tip
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 * @param iRequestCompletionBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @param iCancelActionBlock A Cancel block. Block will be executed when cancel action is taken
 */
- (void)startQuickChipWithTransactionRequest:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest
                                   tipOptions:(NSArray * _Nonnull)iTipOptions
                    presentingViewController:(UIViewController * _Nonnull)iPresentingController
                             completionBlock:(RequestCompletionBlock _Nonnull)iRequestCompletionBlock
                        andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock;

/**
 * Start OTA Update
 * @param iPresentingController A presenting controller object. OTA controller will be presented on top of it
 * @param isTestReader if this is true then SDK will treat the reader as test reader and will try to update form demo site else it will connect the prod version of tms site
                       please make sure that the reader is registered at tms website
 */
- (void)startOTAUpdateFromPresentingViewController:(UIViewController * _Nonnull) iPresentingController isTestReader:(BOOL)isTestReader;

@end

