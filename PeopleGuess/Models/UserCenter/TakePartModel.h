//
//  TakePartModel.h
//  PeopleGuess
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePartModel : NSObject
@property (nonatomic,copy  ) NSString *buyNum;
@property (nonatomic,copy  ) NSString *buyTime;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy  ) NSString *name;
@property (nonatomic,copy  ) NSString *picUrl;
@property (nonatomic,copy  ) NSString *shareUrl;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) NSString *reward;
- (TakePartModel *)initWithJSONDictionary:(NSDictionary *)dictionary;
@end
