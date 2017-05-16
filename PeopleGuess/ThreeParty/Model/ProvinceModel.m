//
//  ProvinceModel.m
//  WaSai
//
//  Created by Hasson on 15-1-14.
//  Copyright (c) 2015年 Hasson. All rights reserved.
//

#import "ProvinceModel.h"
#import "CityModel.h"

@implementation ProvinceModel

- (instancetype)initWithDictionary:(NSDictionary *)dic with:(NSInteger)provinceId
{
    if (self = [super init]) {
        self.name = [dic objectForKey:@"State"];
        self.provinceId = provinceId;
        self.citys = [CityModel getCitysWithArray:[dic objectForKey:@"Cities"]];
    }
    return self;
}

+ (NSArray *)getProvinces
{
    NSArray *provinces = [self getProvincesFromLocal];
    
    NSMutableArray *array = [NSMutableArray array];
    int i = 0;
    for (NSDictionary *dic in provinces) {
        ProvinceModel *province = [[ProvinceModel alloc] initWithDictionary:dic with:i++];
        
        [array addObject:province];
    }
    
    return array;
}

+ (NSArray *)getProvincesFromLocal
{
    NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities" ofType:@"plist"]];
    
    return array;
}




@end
