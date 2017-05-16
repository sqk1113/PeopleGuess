//
//  Tool.h
//  btTemplate
//
//  Created by bt on 14-11-20.
//  Copyright (c) 2014年 zhanglinxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@class MBProgressHUD;
@interface Tool : NSObject

// IOS 开发中判断字符串是否为空字符的方法
+ (BOOL) isBlankString:(NSString *)string;

+ (UIView *)addSepLine:(CGRect)rect inView:(UIView*)view;
//按键声音
+ (void)buttonSoundPlay;
//裁剪图片
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+(NSString*)getFileMD5:(NSString *)filePath;


+ (void)removeLoadingView:(UIView *)view;
+ (void)removeNullView:(UIView *)view;
+ (void)removeErrorView:(UIView *)view;
+ (void)addLoadinView:(UIView *)view center:(CGPoint)point;
+ (void)addNullView:(UIView *)view center:(CGPoint)point imageName:(NSString *)imageName title:(NSString *)titleString;
+ (void)addErrorView:(UIView *)view center:(CGPoint)point title:(NSString *)titleString target:(id)target selector:(SEL)action;
+ (MBProgressHUD *)showMBProgressHUDWithImageStr:(NSString *)imageStr withTitle:(NSString *)str inView:(UIView *)view;
+ (MBProgressHUD *)showMBProgressHUDWithTitle:(NSString *)str inView:(UIView *)view;

+ (UIAlertView *)showAlertWithTitle:(NSString *)titleStr message:(NSString *)messageStr;
+ (UIAlertView *)showAlertWithTitleTwoButton:(NSString *)titleStr message:(NSString *)messageStr oneTitle:(NSString *)oneStr twoTitle:(NSString *)twoStr;

@end

