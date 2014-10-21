//
//  Address.h
//  AuthnetLab
//
//  Created by Senthil Kumar Periyasamy on 10/9/14.
//  Copyright (c) 2014 Paragyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *street1;
@property (nonatomic, copy) NSString *street2;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;


@end
