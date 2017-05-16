//
//  Toast.m
//  进度条自定义
//
//  Created by emc  2559 on 15/10/6.
//  Copyright (c) 2015年 lanqiao. All rights reserved.
//

#import "Toast.h"
static Toast *singalsincase = nil;
@implementation Toast
+(Toast *)shareToast{
    @synchronized(self){
    if (singalsincase==nil) {
        singalsincase=[[Toast alloc]init];
    }
    }
    return singalsincase;
}
-(void)makeText:(NSString *)textContent time:(int)time{
    UIView *backView=[[UIView alloc]init];
    UIFont *font=[UIFont systemFontOfSize:16];
    CGRect rect = [textContent boundingRectWithSize:CGSizeMake(280,150) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    backView.frame=CGRectMake(0, 0, rect.size.width+20, rect.size.height+20);
    backView.center =CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen ].bounds.size.height/2 );
    backView.backgroundColor=[UIColor blackColor];
    backView.alpha=0.6;
    backView.layer.cornerRadius=5.0f;
    backView.layer.masksToBounds=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:rect];
    lable.text=textContent;
    lable.font=font;
    lable.numberOfLines = 0;
    [lable setTextColor:[UIColor whiteColor]];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen ].bounds.size.height/2 );
    [[UIApplication sharedApplication].keyWindow addSubview:lable];
    NSArray *arr=@[backView,lable];
    [self performSelector:@selector(hide:) withObject:arr afterDelay:time];
    
}
-(void)hide:(NSArray *)arr{
    UIView *view =[arr objectAtIndex:0];
    UILabel *lable = [arr objectAtIndex:1];
    [view removeFromSuperview];
    [lable removeFromSuperview];
}
+(NSString *)docment:(NSString *)plistName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentPath=[paths objectAtIndex:0];
    NSString *str=[NSString stringWithFormat:@"%@/%@",documentPath,plistName];
    return str;
}
@end
