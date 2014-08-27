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
 * @param t The tag that encapsulates an XML block.
 * @param v The value that is encapsulated in the XML block.
 @ @return NSString - an autorelease string of the XML block.
 */
@interface NSString (stringWithXMLTag)

+ (NSString *)stringWithXMLTag:(NSString *)t andValue:(NSString *)v;

@end
