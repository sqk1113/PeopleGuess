//
//  ResponseObject.h
//  LoyalServant
//
//  Created by CAI on 15/3/26.
//  Copyright (c) 2015年 IS Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) id data;

- (ResponseObject *)initWithJSONDictionary:(NSDictionary *)dictionary;

@end
