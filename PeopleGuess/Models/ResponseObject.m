//
//  ResponseObject.m
//  LoyalServant
//
//  Created by CAI on 15/3/26.
//  Copyright (c) 2015年 IS Studio. All rights reserved.
//

#import "ResponseObject.h"

@implementation ResponseObject

- (ResponseObject *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _code = [[[dictionary objectForKey:@"errorVo"] objectForKey:@"code"] integerValue];
        _msg = [[dictionary objectForKey:@"errorVo"]objectForKey:@"msg"];
        _data = [dictionary objectForKey:@"data"];
    }
    return self;
}

@end
