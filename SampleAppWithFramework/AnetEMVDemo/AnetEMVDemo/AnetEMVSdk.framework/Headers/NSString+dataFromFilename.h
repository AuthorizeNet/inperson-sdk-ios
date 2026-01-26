//
//  NSString+dataFromFilename.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (dataFromFilename)

/**
 * Method extension that returns the string of the content contained
 * in a file from the application bundle.
 * @param f The filename in the application bundle to open.
 * @return NSString The NSString data from the file opened..
 */
+ (NSString *)dataFromFilename:(NSString *)f;


@end
