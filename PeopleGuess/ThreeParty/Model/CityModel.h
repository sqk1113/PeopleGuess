//
//  CityModel.h
//  WaSai
//
//  Created by Hasson on 15-1-14.
//  Copyright (c) 2015年 Hasson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger cityId;

+ (NSArray *)getCitysWithArray:(NSArray *)citys;

@end
