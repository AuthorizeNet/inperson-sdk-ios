//
//  AnetViewController.h
//  AnetEMVSdk
//
//  Created by Pankaj Taneja on 10/23/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
//

#import "AuthNet.h"
#import "AnetEMVView.h"
#import "AnetEMVTransactionRequest.h"
#import "AnetEMVError.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AnetEMVState.h"

@class AnetEMVTransactionResponse;

typedef void (^EmvCompletionBlock) (AnetEMVTransactionResponse *iResponse, AnetEMVError *iError);
typedef void (^EmvCancelBlock) ();

@interface AnetViewController : UIViewController <AnetEMVViewDelegate, AuthNetDelegate>
@property (nonatomic, strong) AnetEMVTransactionRequest *transactionRequest;
@property (nonatomic, strong) AVAudioPlayer *backgroundMusicPlayer;

@property (nonatomic, copy) EmvCompletionBlock completionBlock;
@property (nonatomic, copy) EmvCancelBlock cancelBlock;
@property (nonatomic, copy) ReaderDeviceInfoBlock deviceInfoBlock;
@property (nonatomic, copy) CardIntercationProgressBlock cardIntercationProgressBlock;
@property (nonatomic, copy) CardIntercationCompletionBlock cardIntercationBlock;

@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, strong) IBOutlet AnetEMVView *emvView;
@property (nonatomic, strong) UILabel *cardRemoveOverlay;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) AnetEMVError *error;
@property (nonatomic, strong) AnetEMVTransactionResponse *emvResponse;

@property (nonatomic, strong) NSString  *currencyCode;
@property (nonatomic, strong) NSString  *terminalID;
@property (nonatomic, strong) NSArray *applications;

@property (nonatomic, assign) NSUInteger counter;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *cardholderName;

@property (nonatomic, strong) NSTimer *trackingTimer;
@property (nonatomic, strong) NSTimer *deviceWaitTimer;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isNetworkProblem;
@property (nonatomic, assign) BOOL isViewLoaded;

@property (nonatomic, assign) BOOL isSwipe;
@property (nonatomic, assign) BOOL skipSignature;
@property (nonatomic, assign) BOOL showReceipt;
@property (nonatomic, assign) BOOL signatureMode;
@property (nonatomic, assign) BOOL isPaperReceiptCase;

@property (atomic, assign) BOOL waitingForConfirmation;

@property (nonatomic, strong) NSString *tipAmount;
@property (nonatomic, strong) NSArray *tipOptions;


- (void)playSound;
- (void)setUIPreferences:(AnetEMVView *)iView;
- (void)showSwipeOrInsertError:(NSString *)iMesssage;
- (void)showAlertWithMessage:(NSString *)iMessage andTitle:(NSString *)iTitle destructive:(BOOL)iDestructive;
- (void)showAlertWithMessage:(NSString *)iMessage title:(NSString *)iTitle andWithAction:(NSArray *)iActions;
- (void)presentAlert;
- (void)dismissAlert;
- (void)executeBlock:(id)iResponse andError:(AnetEMVError *)iError;
- (AnetEMVError *)errorObject:(ANETEmvErrorCode)iErrorCode withMessage:(NSString *)iErrorMessage;
- (void)invalidateTimer;
- (void)exitAutomatically;
- (void)dismissController;
- (void)startTracking;
- (void)stopTracking;
- (void)checkConfirmationResponse;
@end
