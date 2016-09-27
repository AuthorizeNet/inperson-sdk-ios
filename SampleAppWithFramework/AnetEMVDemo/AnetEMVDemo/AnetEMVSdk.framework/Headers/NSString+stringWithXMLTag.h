//
//  NSString+stringWithXMLTag.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Method extension that generates an autorelease string with the
 * value encomposed by a tag.
 */
@interface NSString (stringWithXMLTag)

+ (NSString *)stringWithXMLTag:(NSString *)t andValue:(NSString *)v;

@end
