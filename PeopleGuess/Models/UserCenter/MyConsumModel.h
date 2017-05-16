//
//  MyConsumModel.h
//  PhoneRecord
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 sinocall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyConsumModel : NSObject
@property (strong, nonatomic) NSString *createTime;//日期
@property (strong, nonatomic) NSString *num;//消费录音币数量
@property (strong, nonatomic) NSString *reason;//消费原因
@property (strong, nonatomic) NSString *remainCoin;//剩余数量
- (MyConsumModel *)initWithJSONDictionary:(NSDictionary *)dictionary;
@end
