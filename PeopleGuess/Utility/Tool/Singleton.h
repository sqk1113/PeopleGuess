//
//  Singleton.h
//  vjifen
//
//  Created by zhanglinxu on 14-7-17.
//
//

#import <Foundation/Foundation.h>
@interface Singleton : NSObject
+(Singleton *)sharedSingleton;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *jpushToken;
@property (nonatomic,strong) NSString *lId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *umengToken;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *hasPayPass;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *logo;
@end
