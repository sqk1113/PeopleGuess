//
//  MyWaterModel.h
//  PeopleGuess
//
//  Created by mac on 17/2/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWaterModel : NSObject
@property (strong, nonatomic) NSString *choice;//原因
@property (strong, nonatomic) NSString *createTime;//日期
@property (strong, nonatomic) NSString *name;//
@property (strong, nonatomic) NSString *num;//数量
- (MyWaterModel *)initWithJSONDictionary:(NSDictionary *)dictionary;
@end
