//
//  PayCenterModel.h
//  PeopleGuess
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChargeModel;
@class PayTypeModel;
@interface PayCenterModel : NSObject
@property (nonatomic, assign)NSInteger exchangeCoin;
@property (nonatomic, assign)NSInteger jump;
@property (nonatomic, assign)NSInteger remain;
@property (nonatomic, copy  )NSString *url;
@property (nonatomic, strong)NSMutableArray *chargeItems;
@property (nonatomic, strong)NSMutableArray *payTypes;
- (PayCenterModel *)initWithJSONDictionary:(NSDictionary *)dictionary;
@end


@interface ChargeModel : NSObject
@property (nonatomic, assign)NSInteger giftCoinNum;
@property (nonatomic, assign)float payPrice;
@property (nonatomic, assign)float price;
@property (nonatomic, copy  )NSString  *name;
@property (nonatomic, copy  )NSString  *remark;
@property (nonatomic, assign)BOOL isSelected;
- (ChargeModel *)initWithJSONDictionary:(NSDictionary *)dictionary;
@end


@interface PayTypeModel : NSObject
@property (nonatomic, assign)NSInteger payType;
@property (nonatomic, copy  )NSString  *payDec;
@property (nonatomic, assign)BOOL isSelected;
- (PayTypeModel *)initWithJSONDictionary:(NSDictionary *)dictionary;
@end
