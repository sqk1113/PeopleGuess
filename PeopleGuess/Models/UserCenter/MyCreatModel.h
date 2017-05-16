//
//  MyCreatModel.h
//  PeopleGuess
//
//  Created by mac on 17/2/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCreatModel : NSObject
@property (nonatomic,copy  ) NSString *commission;
@property (nonatomic,copy  ) NSString *createTime;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy  ) NSString *name;
@property (nonatomic,copy  ) NSString *picUrl;
@property (nonatomic,copy  ) NSString *rnum;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *progress;
- (MyCreatModel *)initWithJSONDictionary:(NSDictionary *)dictionary;
@end
