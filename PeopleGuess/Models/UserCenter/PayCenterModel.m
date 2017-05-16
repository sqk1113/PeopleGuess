//
//  PayCenterModel.m
//  PeopleGuess
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayCenterModel.h"

@implementation PayCenterModel
- (PayCenterModel *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _exchangeCoin = [[dictionary objectForKey:@"exchangeCoin"] integerValue];
        _remain = [[dictionary objectForKey:@"remain"] integerValue];
        NSLog(@"%@---%ld",[dictionary objectForKey:@"jump"],[[dictionary objectForKey:@"jump"] integerValue]);
        _jump = [[dictionary objectForKey:@"jump"] integerValue];
        NSMutableArray *chargeItems = [dictionary objectForKey:@"chargeItems"];
        _chargeItems = [NSMutableArray new];
        _payTypes = [NSMutableArray new];
        for (NSDictionary *dic in chargeItems) {
            ChargeModel *m = [[ChargeModel alloc]initWithJSONDictionary:dic];
            [_chargeItems addObject:m];
        }
        NSMutableArray *payTypes = [dictionary objectForKey:@"payTypes"];
        for (NSDictionary *dic in payTypes) {
            PayTypeModel *m  = [[PayTypeModel alloc]initWithJSONDictionary:dic];
            [_payTypes addObject:m];
        }
        _url = [dictionary objectForKey:@"url"];
        
    }
    return self;

}
@end


@implementation ChargeModel
- (ChargeModel *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _giftCoinNum = [[dictionary objectForKey:@"giftCoinNum"] integerValue];
        _payPrice = [[dictionary objectForKey:@"payPrice"] floatValue];
        _price = [[dictionary objectForKey:@"price"] floatValue];
        _name = [dictionary objectForKey:@"name"];
        _remark = [dictionary objectForKey:@"remark"];
    }
    return self;

}
@end

@implementation PayTypeModel

- (PayTypeModel *)initWithJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _payType = [[dictionary objectForKey:@"payType"] integerValue];
        _payDec = [dictionary objectForKey:@"payDec"];
    }
    return self;
}
@end

