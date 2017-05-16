//
//  Toast.h
//  进度条自定义
//
//  Created by emc  2559 on 15/10/6.
//  Copyright (c) 2015年 lanqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Toast : NSObject
+(Toast *)shareToast;
-(void)makeText:(NSString *)textContent time:(int)time;
+(NSString *)docment:(NSString *)plistName;
@end
