//
//  Tool.m
//  btTemplate
//
//  Created by bt on 14-11-20.
//  Copyright (c) 2014年 zhanglinxu. All rights reserved.
//

#import "Tool.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <stdio.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>
@implementation Tool

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class] ]  &&  [string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] && [string length]==0) {
        return YES;
    }
    return NO;
}

+ (UIView *)addSepLine:(CGRect)rect inView:(UIView*)view{
    CGFloat pixelAdjustOffset = 0;
    if (((int)(1 / [UIScreen mainScreen].scale * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = (1 / [UIScreen mainScreen].scale) / 2;
    }
    CGFloat yPos = rect.origin.y - pixelAdjustOffset;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, yPos, rect.size.width, rect.size.height)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [view addSubview:lineView];
    return lineView;
}

//按键声音
+ (void)buttonSoundPlay
{
    SystemSoundID soundID;
    NSString *soundString = [[NSBundle mainBundle] pathForResource:@"TabbarSound" ofType:@"wav"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundString];
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &soundID);
    if (error)
    {
        NSLog(@"Error occurred assigning system sound!");
        return;
    }
    AudioServicesPlaySystemSound(soundID);
}

+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
+(NSString*)getFileMD5:(NSString *)filePath{
    NSString * ret = @"";
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: filePath];
    if( handle== nil ) {
        return ret;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    ret = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
           digest[0], digest[1],
           digest[2], digest[3],
           digest[4], digest[5],
           digest[6], digest[7],
           digest[8], digest[9],
           digest[10], digest[11],
           digest[12], digest[13],
           digest[14], digest[15]];
    return ret;
}

+ (void)removeLoadingView:(UIView *)view{
    [[view viewWithTag:1000]removeFromSuperview];
    view = nil;
}

+ (void)removeNullView:(UIView *)view{
    [[view viewWithTag:1001]removeFromSuperview];
    view = nil;
}

+ (void)removeErrorView:(UIView *)view{
    [[view viewWithTag:1002]removeFromSuperview];
    view = nil;
}

+ (void)addLoadinView:(UIView *)view center:(CGPoint)point{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.tag = 1000;
    activityView.frame = CGRectMake(0,0, 44, 44);
    [activityView startAnimating];
    [view addSubview:activityView];
    [activityView setCenter:point];
    
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(-activityView.frame.origin.x, activityView.frame.size.height , SCREEN_WIDTH, 20)];
    bgLabel.backgroundColor = [UIColor clearColor];
    bgLabel.textColor  = [UIColor lightGrayColor];
    bgLabel.font = [UIFont fontWithName:PFTHINFONT size:14];
    bgLabel.text = @"正在加载";
    bgLabel.textAlignment = NSTextAlignmentCenter;
    [activityView addSubview:bgLabel];
}


+ (void)addNullView:(UIView *)view center:(CGPoint)point imageName:(NSString *)imageName title:(NSString *)titleString{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*140/2/320, SCREEN_WIDTH*140/2/320)];
    bgImageView.tag = 1001;
    bgImageView.image = [UIImage imageNamed:imageName];
    [view addSubview:bgImageView];
    [bgImageView setCenter:CGPointMake(point.x, point.y)];
    
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(-bgImageView.frame.origin.x,bgImageView.frame.size.height + 10, SCREEN_WIDTH, 30)];
    bgLabel.backgroundColor = [UIColor clearColor];
    bgLabel.textColor  = [UIColor lightGrayColor];
    bgLabel.font = [UIFont fontWithName:PFTHINFONT size:15.5];
    bgLabel.text = titleString;
    bgLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:bgLabel];
    
    
}

+ (void)addErrorView:(UIView *)view center:(CGPoint)point title:(NSString *)titleString target:(id)target selector:(SEL)action{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*140/2/320, SCREEN_WIDTH*140/2/320)];
    bgImageView.tag = 1002;
    bgImageView.image = [UIImage imageNamed:@"noNeticon"];
    [view addSubview:bgImageView];
    [bgImageView setCenter:point];
    
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(-bgImageView.frame.origin.x,bgImageView.frame.size.height + 10, SCREEN_WIDTH, 30)];
    bgLabel.backgroundColor = [UIColor clearColor];
    bgLabel.textColor  = [UIColor lightGrayColor];
    bgLabel.font = [UIFont fontWithName:PFTHINFONT size:15.5];
    bgLabel.text = titleString;
    bgLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:bgLabel];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    bgImageView.userInteractionEnabled = YES;
    bgLabel.userInteractionEnabled = YES;
    [bgImageView addGestureRecognizer:gesture];
}

+ (MBProgressHUD *)showMBProgressHUDWithImageStr:(NSString *)imageStr withTitle:(NSString *)str inView:(UIView *)view{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    if(![Tool isBlankString:imageStr])
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelFont = [UIFont fontWithName:PFTHINFONT size:15];
    HUD.labelText = str;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    return HUD;
}

+ (MBProgressHUD *)showMBProgressHUDWithTitle:(NSString *)str inView:(UIView *)view{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.tag = 2130;
    [view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelFont = [UIFont fontWithName:PFTHINFONT size:15];
    HUD.labelText = str;
    [HUD show:YES];
    return HUD;
}


+ (UIAlertView *)showAlertWithTitle:(NSString *)titleStr message:(NSString *)messageStr{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return alert;
}

+ (UIAlertView *)showAlertWithTitleTwoButton:(NSString *)titleStr message:(NSString *)messageStr oneTitle:(NSString *)oneStr twoTitle:(NSString *)twoStr{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:oneStr otherButtonTitles:twoStr,nil];
    [alert show];
    return alert;
}


@end



