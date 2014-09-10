//
//  NSString+HMAC_MD5.m
//  iDev_Encryption
//
//  Created by Niketan Mishra on 4/24/13.
//  Copyright (c) 2013 SparshInc. All rights reserved.
//

#import "NSString+HMAC_MD5.h"

//Included Classes
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

@implementation NSString (HMAC_MD5)
+ (NSString*) HMAC_MD5_WithTransactionKey:(NSString*)secret  fromValue:(NSString*)value{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [value UTF8String];
    unsigned char    mac[CC_MD5_DIGEST_LENGTH];
    char             hexmac[2 * CC_MD5_DIGEST_LENGTH + 1];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgMD5, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}
@end