//
//  MyConsumModel.m
//  PhoneRecord
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 sinocall. All rights reserved.
//

#import "MyConsumModel.h"

@implementation MyConsumModel
- (MyConsumModel *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _createTime = [dictionary objectForKey:@"createTime"];
        _num = [dictionary objectForKey:@"num"];
        _reason = [dictionary objectForKey:@"reason"];
        _remainCoin = [dictionary objectForKey:@"remainCoin"];
        
    }
    return self;
    
}
@end
