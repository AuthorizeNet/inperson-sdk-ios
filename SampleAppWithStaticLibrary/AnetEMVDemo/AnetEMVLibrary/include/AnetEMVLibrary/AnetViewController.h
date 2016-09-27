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

@class AnetEMVTransactionResponse;

typedef void (^EmvCompletionBlock) (AnetEMVTransactionResponse * _Nullable iResponse, AnetEMVError * _Nullable iError);
typedef void (^EmvCancelBlock) ();

@interface AnetViewController : UIViewController <AnetEMVViewDelegate, AuthNetDelegate>
@property (nonatomic, strong) AnetEMVTransactionRequest * _Nonnull transactionRequest;
@property (nonatomic, strong) AVAudioPlayer * _Nullable backgroundMusicPlayer;
- (void)playSound;
@end
