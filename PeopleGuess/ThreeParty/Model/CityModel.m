//
//  CityModel.m
//  WaSai
//
//  Created by Hasson on 15-1-14.
//  Copyright (c) 2015年 Hasson. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (instancetype)initWithDictionary:(NSDictionary *)dic with:(NSInteger)cityId
{
    if (self = [super init]) {

        self.name = [dic objectForKey:@"city"];
        self.cityId = cityId;
        
    }
    
    return self;
}

+ (NSArray *)getCitysWithArray:(NSArray *)citys
{
    NSMutableArray *array = [NSMutableArray array];
    int i = 0;
    for (NSDictionary *dic in citys) {
        CityModel *city = [[CityModel alloc] initWithDictionary:dic with:i++];
        
        [array addObject:city];
    }
    
    return array;
}

@end
