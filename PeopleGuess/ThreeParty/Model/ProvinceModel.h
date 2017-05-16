//
//  ProvinceModel.h
//  WaSai
//
//  Created by Hasson on 15-1-14.
//  Copyright (c) 2015年 Hasson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, strong) NSArray *citys;

//- (instancetype)initWithDictionary:(NSDictionary *)dic;

+ (NSArray *)getProvinces;

@end
