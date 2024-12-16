//
//  AnetEMVManager.h
//  AnetEMVSdk
//
//  Created by Pankaj Taneja on 10/23/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnetEMVTransactionRequest.h"
#import "AnetCreateCustomerProfileFromTransactionRequest.h"
#import "AnetUpdateCustomerPaymentProfileRequest.h"
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class AnetEMVError;
@class AnetEMVTransactionResponse;

@class AnetCustomerProfileError;
@class AnetCustomerProfileTransactionResponse;

typedef NS_ENUM (NSUInteger, BBDeviceErrorType);

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
    AnetEmvErrorBTSettingsOff,
    ANETEmvErrorCouldNotRetrieveCardData
};

typedef NS_ENUM(NSInteger, AnetOTAErrorCode) {
    AnetOTASuccess,
    AnetOTASetupError,
    AnetOTABatteryLowError,
    AnetOTADeviceCommError,
    AnetOTAServerCommError,
    AnetOTAFailed,
    AnetOTAStopped,
    AnetOTANoUpdateRequired,
    AnetOTAInvalidControllerStateError,
    AnetOTAIncompatibleFirmwareHex,
    AnetOTAConfigHex,
    AnetOTAErrorInvalidInputs,
    AnetOTAErrorCommError,
    AnetOTAErrorDeviceBusy,
    AnetOTAErrorCommLinkUninitialized,
    AnetOTAErrorBTv4NotSupported,
    AnetOTAErrorFailedToStart,
    AnetOTAErrorIllegalException,
    AnetOTABTSettingsOff,
    AnetOTAErrorAlreadyConnected
};

typedef NS_ENUM (NSInteger, AnetEMVCardInteractionProgress) {
    AnetEMVWaitingForCard,
    AnetEMVRetryInsertOrSwipe,
    AnetEMVSwipeOrTryAnotherCard,
    AnetEMVSwipe,
    AnetEMVProcessingCard,
    AnetEMVDoneWithCard,
};

typedef NS_ENUM (NSInteger, OTAStatus) {
    AnetEMVWaitingForAudioDevice,
    AnetEMVScanningForBTDevices,
    ContactingBTDevice,
    CheckingForUpdate,
    UpdatingDeviceFirmwareOrConfig
};


typedef NS_ENUM (NSInteger, AnetEMVTerminalMode) {
    AnetEMVModeSwipe,
    AnetEMVModeInsertOrSwipe
};

typedef NS_ENUM (NSInteger, AnetEMVConnectionMode) {
    AnetEMVConnectionModeAudio,
    AnetEMVConnectionModeBluetooth
};

typedef NS_ENUM (NSInteger, OTAUpdateType) {
    NONE,
    OTAFirmwareUpdate,
    OTAConfigUpdate
};

typedef NS_ENUM(NSInteger, AnetBTDeviceStatusCode) {
    AnetBTDeviceNoError = 0,
    AnetBTDeviceConnected,
    AnetBTDeviceDisconnected,
    AnetBTDeviceConnectionTimeout,
    AnetBTDeviceAlreadyConnectedError,
    AnetBTDeviceFailToStart,
    AnetBTDeviceIllegalStateException,
    AnetBTDeviceScanStarted,
    AnetBTDeviceScanStopped,
    AnetBTDeviceScanSuccess,
    AnetBTDeviceScanTimeout,
    AnetBluetoothSettingsOff,
    AnetBTDeviceGenericError
};




//-----------------------------EVENTS BLOCK-----------------------------//
/**
 The completion handler, if provided, will be invoked on completion of EMV transaction
 * @param response AnetEMVTransactionResponse response object 
 * @param error AnetEMVError error object, on successful transaction this object will be Nil
 */
typedef void (^RequestCompletionBlock) (AnetEMVTransactionResponse * _Nullable response, AnetEMVError *_Nullable error);

typedef void (^ProfileCompletionBlock) (AnetCustomerProfileTransactionResponse * _Nullable response, AnetCustomerProfileError *_Nullable error);

typedef void (^TransactionCompletionBlock) (AnetEMVTransactionResponse * _Nullable response);
/**
 The completion handler, will be invoked on error of Customer Profile request
 * @param error AnetCustomerProfileError object
 */
typedef void (^FailureBlock) (AnetCustomerProfileError *_Nullable error);

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

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^OTAUpdateStatusBlock)(OTAStatus iStatus);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^OTACheckUpdateRequiredBlock)(BOOL iFirmwareUpdateRequired, BOOL iConfigurationUpdateRequired, AnetOTAErrorCode iErrorCode, NSString * _Nullable iErrorString);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^OTACheckUpdateCompletedBlock)(BOOL iUpdateSuccessful, AnetOTAErrorCode iErrorCode, NSString * _Nullable iErrorString);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^OTAUpdateProgressBlock)(float iPercentage, OTAUpdateType iUpdateType);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^BTScanDeviceListBlock)(NSArray * _Nullable iBTDeviceList, AnetBTDeviceStatusCode status);

/**
 The completion handler, it will be invoked with device info
 */
typedef void (^BTDeviceConnected)(BOOL isConnectionSuccessful, NSString * _Nullable iDeviceName, AnetBTDeviceStatusCode status);




@interface AnetEMVManager : NSObject
    
    //-----------------------------PROPERTIES-----------------------------//
@property (nonatomic, copy) BTScanDeviceListBlock _Nullable deviceListBlock;
@property (nonatomic, copy) BTDeviceConnected _Nullable deviceConnectedBlock;

    
    //-----------------------------SDK VERSION-----------------------------//
/**
 * Method for retrieving SDK version
 * @returns SDK version
 */
+ (NSString * _Nonnull)anetSDKVersion;


    //-----------------------------LOGGING-----------------------------//
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

    
    
    //-----------------------------CONNCETION/TERMINAL/AUTO EJECT-----------------------------//
/**
 * Method for setting the terminal mode.
 * @param iTerminalMode Terminal mode can be swipe or insertOrSwipe, if value is AnetEMVModeSwipe, SDK will only accept MSR/swipe transactions
 */
- (void)setTerminalMode:(AnetEMVTerminalMode)iTerminalMode;

/**
 * Method for setting the Connection mode.
 * @param iConnectionMode Connection mode can be AUDIO/BLUETOOTH, Default is AUDIO connection
 */
- (void)setConnectionMode:(AnetEMVConnectionMode)iConnectionMode;

/**
 * Method for Auto Dismiss Confirmation, In case user doesn't take action when transaction gets completed
 * @param iAutoDismissConfirmation
 */
- (void)setAutoDismissConfirmation:(BOOL)iAutoDismissConfirmation;
    
/**
 * Method for refrshing/discovering the nearby bluetooth devices
    If the application sets the connection as Bluetooth then in headless OTA update SDK will return the near by BT devices list in BTScanDeviceListBlock
    application must display this list to the user to select the preferred BT reader
    Application can call this method to refresh the list. BTScanDeviceListBlock will be executed with the new list
 */
- (void)scanBTDevicesList;

/**
 * Method for refrshing/discovering the specified nearby bluetooth devices
 * @param namesArray Array of device names to scan
    Application can call this method to refresh the list. BTScanDeviceListBlock will be executed with the new list
 */
- (void)scanBTDevicesWithNamesArray:(NSArray * _Nonnull)namesArray;

/**
 * Method for stop scanning for bluetooth devices
 */
- (void)stopScanBTDevices;

/**
 * Method for stop scanning for bluetooth devices and disconnect any connected bluetooth device
 */
- (void)stopScanAndDisconnectBTDevices;

/**
 * Method for disconnecting any connected bluetooth device
 */
- (void)disconnectBTDevices;

/**
 * Method for reseting BT handlers
 */
- (void)resetBTHandlers;

/**
 * Method for connecting to the preferred BT device.
 * @param iIndex Index of the preferred BT device from the BTDevicesList, once device is connected BTDeviceConnted will be executed to notify about the successfull connection
 */
- (void)connectBTDeviceAtIndex:(NSInteger)iIndex;

/**
 * Method for connecting to the preferred BT device.
 * @param peripheralData BT device data to connect, once device is connected BTDeviceConnted will be executed to notify about the successfull connection
 */
- (void)connectBTDeviceWithPeripheralData:(CBPeripheral * _Nonnull)peripheralData;

/**
 * Method for connecting to the preferred BT device.
 * @param deviceName BT device name to connect, once device is connected BTDeviceConnted will be executed to notify about the successfull connection
 */
- (void)connectBTDeviceWithName:(NSString * _Nonnull)deviceName;

    //-----------------------------INITIALIZATION-----------------------------//
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
 * Static method for reseting AnetEMVManager sharedInstance, in case takes too long to process or doesn't respond
 */
+ (void)resetEMVManager;
    
    
    
    //-----------------------------TRANSACTION PROCESSING-----------------------------//
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
 * Create a Customer Profile and Start a Quick Chip transaction with EMV request, presenting view controller and completion block.
 * @param iTransactionRequest A request object of AnetEMVTransactionRequest
 * @param iTipOptions Tip options which will be presented on Signature screen to allow user to tip
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 * @param iRequestCompletionBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @param iCancelActionBlock A Cancel block. Block will be executed when cancel action is taken
 */
- (void)createCustomerProfile:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest
                         forPaperReceiptCase:(BOOL)iPaperReceiptCase
                        isConsentBefore:(BOOL)iConsentBefore
                    presentingViewController:(UIViewController * _Nonnull)iPresentingController
                             completionBlock:(ProfileCompletionBlock _Nonnull)iRequestCompletionBlock
                             transactionCompletionBlock:(TransactionCompletionBlock _Nonnull)iTransactionCompletionBlock
                        andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock;

/**
 * Create an Additional Payment Profile and Start a Quick Chip transaction with EMV request, presenting view controller and completion block.
 * @param iTransactionRequest A request object of AnetEMVTransactionRequest
 * @param iTipOptions Tip options which will be presented on Signature screen to allow user to tip
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 * @param iRequestCompletionBlock A completion block. Block will be executed on success or failure of EMV transaction
 * @param iCancelActionBlock A Cancel block. Block will be executed when cancel action is taken
 */
- (void)createAdditionalPaymentProfile:(AnetEMVTransactionRequest * _Nonnull)iTransactionRequest
  forPaperReceiptCase:(BOOL)iPaperReceiptCase
      isConsentBefore:(BOOL)iConsentBefore
    withCustomerProfileID:(NSString *_Nonnull)iProfileID
presentingViewController:(UIViewController * _Nonnull)iPresentingController
      completionBlock:(ProfileCompletionBlock _Nonnull)iRequestCompletionBlock
transactionCompletionBlock:(TransactionCompletionBlock _Nonnull)iTransactionCompletionBlock
 andCancelActionBlock:(CancelActionBlock _Nonnull)iCancelActionBlock;


    
    //-----------------------------READER DEVICE INFOMARTION-----------------------------//
/**
 * Method for getting AnyWhereReaderInfo
 * @param iReaderDeviceInfoBlock A block will be executed with the device info
 * @param iPresentingController A presenting controller object. EMV controller will be presented on top of it
 */
- (void)getAnyWhereReaderInfo:(ReaderDeviceInfoBlock _Nonnull)iReaderDeviceInfoBlock presentingViewController:(UIViewController * _Nonnull)iPresentingController;
    
    
    
    
    
    
    
    //-----------------------------READER DEVICE UPDATE-----------------------------//
/**
 * Start OTA Update
 * @param iPresentingController A presenting controller object. OTA controller will be presented on top of it
 * @param isTestReader if this is true then SDK will treat the reader as test reader and will try to update from TMS demo site else it will connect the TMS live version site
        please make sure that the reader is registered at tms website
        https://tms-demo.bbpos.com/login
        https://tms.bbpos.com/login
 */
- (void)startOTAUpdateFromPresentingViewController:(UIViewController * _Nonnull) iPresentingController
                                      isTestReader:(BOOL)isTestReader;

/**
 * Start OTA Update
 * @param isTestReader if this is true then SDK will treat the reader as test reader and will try to update from TMS demo site else it will connect the TMS live version site
        please make sure that the reader is registered at tms website
        https://tms-demo.bbpos.com/login
        https://tms.bbpos.com/login
 * @param iUpdateCheckBlock This block will be executed once SDK finds the status of the update, application will be notified if any of the following is outdated
    i)  Reader Device Firmware
    ii) Reader Device Configuration
 */
- (void)checkForOTAUpdateIsTestReader:(BOOL)isTestReader
                  withOTAUpdateStatus:(OTACheckUpdateRequiredBlock _Nonnull)iUpdateCheckBlock;

/**
 * Start OTA Update
 * @param isTestReader if this is true then SDK will treat the reader as test reader and will try to update from TMS demo site else it will connect the TMS live version site
        please make sure that the reader is registered at tms website
        https://tms-demo.bbpos.com/login
        https://tms.bbpos.com/login
 * @param iOTAProgressBlock This block will be exceuted on change in progress of update, Application will be notified about the progress of the update
 * @param iUpdateCompleteBlock This block will be executed on completion of update, Application will be notified about the update in case of success or failure
 */
- (void)startOTAUpdateIsTestReader:(BOOL)isTestReader
                      withProgress:(OTAUpdateProgressBlock _Nonnull)iOTAProgressBlock
             andOTACompletionBlock:(OTACheckUpdateCompletedBlock _Nonnull)iUpdateCompleteBlock;

/**
 * Stop OTA Update, Application can only stop the update in case application called 
    "- (void)startOTAUpdateIsTestReader:(BOOL)isTestReader withProgress:(OTAUpdateProgressBlock _Nonnull)iOTAProgress andOTACompletionBlock:(OTACheckUpdateCompletedBlock _Nonnull)iUpdateCompleteBlock"
    to update
 */
- (void)stopOTAUpdate;

@end

