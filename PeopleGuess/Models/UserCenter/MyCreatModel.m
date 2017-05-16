//
//  MyCreatModel.m
//  PeopleGuess
//
//  Created by mac on 17/2/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MyCreatModel.h"

@implementation MyCreatModel
- (MyCreatModel *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _commission = [dictionary objectForKey:@"commission"];
        _createTime = [dictionary objectForKey:@"createTime"];
        _id = [[dictionary objectForKey:@"id"] integerValue];
        _name = [dictionary objectForKey:@"name"];
        _picUrl = [dictionary objectForKey:@"picUrl"];
        _shareUrl = [dictionary objectForKey:@"shareUrl"];
        _rnum = [dictionary objectForKey:@"rnum"];
        _status = [[dictionary objectForKey:@"status"] integerValue];
        _progress = [dictionary objectForKey:@"progress"];
    }
    return self;
    
}
@end
