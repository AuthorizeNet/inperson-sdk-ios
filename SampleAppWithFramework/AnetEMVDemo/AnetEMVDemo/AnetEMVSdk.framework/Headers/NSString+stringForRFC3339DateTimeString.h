//
//  stringForRFC3339DateTimeString.h
//  MobileMerchant
//
//  Created by Shiun Hwang on 5/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (stringForRFC3339DateTimeString)

+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString dateStyle:(NSDateFormatterStyle)dStyle timeStyle:(NSDateFormatterStyle)tStyle;

@end
