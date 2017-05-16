//
//  TMNavigationViewController.h
//  Demo
//
//  Created by TianMing on 16/3/10.
//  Copyright © 2016年 TianMing. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface TMNavigationController : UINavigationController

/**
 改变navBar的透明度
 @param alpha
 */
+(void)chanegAlphaWith:(CGFloat)alpha;

/**
 替换navBarView
 */
+(void)changeViewWith:(UIView *)placeView;


/**
 添加view
 @param otherView
 @param frame
 */
+(void)addOtherView:(UIView *)otherView withFrame:(CGRect)frame;


@end

typedef void(^clickBackButton)(UIButton * button);
@interface navigationBarView : UIView
@property (  copy ,nonatomic) clickBackButton click;
@property (  copy ,nonatomic) NSString * title;
@property (strong ,nonatomic) UIView *barMainView;//主View
@property (strong ,nonatomic) UILabel * titleLabel;//标题
@property (strong ,nonatomic) UIButton * backButton;//返回按钮
@property (strong ,nonatomic) UIView *bottomLine;//底部线条

-(instancetype)initWithFrame:(CGRect)frame;
-(void)clickBackButton:(clickBackButton)block;

@end


@interface UIViewController (navigationBar)

@property (nonatomic,strong) navigationBarView * navigationBar;
@property (nonatomic,copy  ) NSString * title;
@property (nonatomic,strong) UIColor * navigationBarBackgroundColor;//设置nav背景颜色
@property (nonatomic,getter=isNavigationBar)BOOL navigationBarHidden;//是否影藏navBar
@property (nonatomic,getter=isBottomLine) BOOL navgationBarBottomLineHidden;//是否影藏nav底部线条

@end
