//
//  NSString+HMAC_MD5.h
//  iDev_Encryption
//
//  Created by Niketan Mishra on 4/24/13.
//  Copyright (c) 2013 SparshInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMAC_MD5)
+ (NSString*) HMAC_MD5_WithTransactionKey:(NSString*)secret fromValue:(NSString*)value;
@end