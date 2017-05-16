//
//  popView.m
//  popView
//
//  Created by mac on 16/12/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LoginOutView.h"
#import <objc/runtime.h>

@interface LoginOutView()
@property (nonatomic, strong) UIWindow* window;

@property (nonatomic, strong) UIView* showView;

@end

@implementation LoginOutView
{
    UIButton *btn2;
}


-(instancetype)initWith:(ChooseAction)block
{
    if (self = [super init]) {
        //初始化窗体
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.windowLevel = UIWindowLevelAlert;
        
        self.frame =[UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        UIView *blackView =[[UIView alloc]init];
        blackView.frame = [UIScreen mainScreen].bounds;
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.4;
        UITapGestureRecognizer  *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [blackView addGestureRecognizer:singleRecognizer];
        [self addSubview:blackView];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310*SCREEN_WIDTH_RATE, 148*SCREEN_WIDTH_RATE)];
        backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 4;
        backView.layer.masksToBounds = YES;
        CAKeyframeAnimation *am = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        am.duration = 0.2;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        am.values = values;
        [backView.layer addAnimation:am forKey:nil];
        [self addSubview:backView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40*SCREEN_WIDTH_RATE, backView.frame.size.width, 18*SCREEN_WIDTH_RATE)];
        label.text = @"确认退出登录吗?";
        label.font = [UIFont fontWithName:PFREGULARFONT size:18*SCREEN_WIDTH_RATE];
        label.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:label];
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(9*SCREEN_WIDTH_RATE, 98*SCREEN_WIDTH_RATE, 137*SCREEN_WIDTH_RATE, 40*SCREEN_WIDTH_RATE)];
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn1.backgroundColor = UIColorFromRGB(0xcccccc);
        btn1.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:18*SCREEN_WIDTH_RATE];
        [btn1 addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn1];
        
        btn2 = [[UIButton alloc]initWithFrame:CGRectMake(VIEWX(btn1)+18*SCREEN_WIDTH_RATE, 98*SCREEN_WIDTH_RATE,137*SCREEN_WIDTH_RATE, 40*SCREEN_WIDTH_RATE)];
        [btn2 setTitle:@"确认" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.backgroundColor = NAVBARMAINCOLOR;
        btn2.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:18*SCREEN_WIDTH_RATE];
        [backView addSubview:btn2];
        [btn2 handleControlEvent:UIControlEventTouchUpInside withBlock:block];
        [btn2 addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (void)show{
    
    [self.window becomeKeyWindow];
    [self.window makeKeyAndVisible];
    [self.window addSubview:self];
    
}
- (void)dismiss{
    
    [self.window resignKeyWindow];
    
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication].delegate.window becomeKeyWindow];
    
    [self removeFromSuperview];
}
+(void)showPopView:(ChooseAction)block
{
    LoginOutView *pop = [[LoginOutView alloc]initWith:block];
    [pop show];
}
@end

@implementation UIButton(block)

static char overviewKey;


-(void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ChooseAction)action
{
    objc_setAssociatedObject(self, &overviewKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvent];
}

- (void)callActionBlock:(id)sender {
    ChooseAction block = (ChooseAction)objc_getAssociatedObject(self, &overviewKey);
    
    if (block) {
        __weak typeof(self) weakSelf = self;
        block(weakSelf);
    }
}
@end
