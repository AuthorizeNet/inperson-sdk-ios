//
//  AnetEMVTag.h
//  AnetEMVSdk
//
//  Created by Senthil Kumar Periyasamy on 12/2/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface AnetEMVTag : NSObject {
    
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *formatted;
@property (nonatomic, strong) NSString *tagDesciption;

+ (AnetEMVTag *) tag;
+ (AnetEMVTag *) buildTag:(GDataXMLElement *)element;
+ (NSString *)tagDescription:(NSString *)iTagName;
@end
