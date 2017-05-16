//
//  TakePartModel.m
//  PeopleGuess
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TakePartModel.h"

@implementation TakePartModel
- (TakePartModel *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _buyNum = [dictionary objectForKey:@"buyNum"];
        _buyTime = [dictionary objectForKey:@"buyTime"];
        _id = [[dictionary objectForKey:@"id"] integerValue];
        _name = [dictionary objectForKey:@"name"];
        _picUrl = [dictionary objectForKey:@"picUrl"];
//        _progress = [dictionary objectForKey:@"progress"];
        _shareUrl = [dictionary objectForKey:@"shareUrl"];
        _reward = [dictionary objectForKey:@"reward"];
        _status = [[dictionary objectForKey:@"status"] integerValue];
//        _takePartNum = [[dictionary objectForKey:@"takePartNum"] integerValue];
        
    }
    return self;
    
}
@end
