//
//  AnetCustomerViewController.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/27/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnetQuickChipViewController.h"

@interface AnetCustomerViewController : AnetQuickChipViewController

- (void)setUpWithCurrencyCode:(NSString *)iCurrencyCode
          forPaperReceiptCase:(BOOL)iPaperReceiptCase
                   terminalID:(NSString *)iTerminalID
           transactionRequest:(AnetEMVTransactionRequest *)iTransactionRequest
                skipSignature:(BOOL)iSkipSignature
                  showReceipt:(BOOL)iShowReceipt
     showProfileConsentBefore:(BOOL)iShowConsentBefore
              completionBlock:(ProfileCompletionBlock)iCompletionBlock
   transactionCompletionBlock:(TransactionCompletionBlock)iTransactionCompletionBlock
               andCancelBlock:(EmvCancelBlock)iCancelBlock;

- (void)setUpWithCurrencyCodeAdditionalPaymentProfile:(NSString *)iCurrencyCode
          forPaperReceiptCase:(BOOL)iPaperReceiptCase
                   terminalID:(NSString *)iTerminalID
           transactionRequest:(AnetEMVTransactionRequest *)iTransactionRequest
                skipSignature:(BOOL)iSkipSignature
                  showReceipt:(BOOL)iShowReceipt
     showProfileConsentBefore:(BOOL)iShowConsentBefore
            customerProfileID:(NSString *)iProfileID
              completionBlock:(ProfileCompletionBlock)iCompletionBlock
   transactionCompletionBlock:(TransactionCompletionBlock)iTransactionCompletionBlock
               andCancelBlock:(EmvCancelBlock)iCancelBlock;

@end
