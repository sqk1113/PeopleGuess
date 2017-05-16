//
//  MyWaterModel.m
//  PeopleGuess
//
//  Created by mac on 17/2/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MyWaterModel.h"

@implementation MyWaterModel
- (MyWaterModel *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _createTime = [dictionary objectForKey:@"createTime"];
        _num = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"num"]];
        _choice = [dictionary objectForKey:@"choice"];
        _name = [dictionary objectForKey:@"name"];
        
    }
    return self;
    
}
@end
