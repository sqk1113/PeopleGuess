//
//  TMNavigationController.m
//  Demo
//
//  Created by TianMing on 16/3/10.
//  Copyright © 2016年 TianMing. All rights reserved.
//


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#import "TMNavigationController.h"
#import "objc/runtime.h"

@interface navigationBarView ()
@end
@implementation navigationBarView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bottomLine];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 35)];
        _titleLabel.text = self.title;
        _titleLabel.font = [UIFont fontWithName:PFMEDIUMFONT size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 20, 100, 44);
        [_backButton addTarget:self action:@selector(backLastView:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self addSubview:_backButton];
    }
    return self;
}
-(void)backLastView:(UIButton*)button{
    if (self.click) {
        self.click(button);
    }
}
-(void)clickBackButton:(clickBackButton)block{
    self.click = block;
}
-(void)setTitle:(NSString *)title{
    _title = title;
    if (!title) {
        _titleLabel.hidden = YES;
        return;
    }
    if ([title isEqualToString:_titleLabel.text]) {
        return;
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    _titleLabel.text = title;
    _titleLabel.hidden = NO;
    [self setNeedsDisplay];
}

@end

@implementation UIViewController (navigationBar)
@dynamic navigationBar;
@dynamic navigationBarHidden;
@dynamic title;
@dynamic navigationBarBackgroundColor;
@dynamic navgationBarBottomLineHidden;

-(navigationBarView *)navigationBar{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setNavigationBar:(navigationBarView *)navigationBar{
    objc_setAssociatedObject(self, @selector(navigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(BOOL)isNavigationBar{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setNavigationBarHidden:(BOOL)navigationBarHidden{
    objc_setAssociatedObject(self, @selector(isNavigationBar), @(navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

-(NSString *)title{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setTitle:(NSString *)title{
    objc_setAssociatedObject(self, @selector(title), title, OBJC_ASSOCIATION_COPY);
}

-(UIColor*)navigationBarBackgroundColor{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor{
    objc_setAssociatedObject(self, @selector(navigationBarBackgroundColor), navigationBarBackgroundColor, OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)isBottomLine
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(BOOL)navgationBarBottomLineHidden
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setNavgationBarBottomLineHidden:(BOOL)navgationBarBottomLineHidden
{
    objc_setAssociatedObject(self, @selector(isBottomLine), @(navgationBarBottomLineHidden),OBJC_ASSOCIATION_ASSIGN);
}


@end


static navigationBarView *barView;
@interface TMNavigationController ()<UIGestureRecognizerDelegate>
//@property (strong , nonatomic) navigationBarView * barView;
@end


@implementation TMNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
    }
    return self;
}
-(void)loadView{
    [super loadView];
    [self createBarView];
    [self popGesture];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)createBarView{
    self.navigationBarHidden = YES;
    barView  = [[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [barView clickBackButton:^(UIButton *button) {
        [self popViewControllerAnimated:YES];
    }];
    [self.topViewController.view addSubview:barView];
    barView.title = self.topViewController.title;
    if (self.viewControllers.count==0) {
        barView.backButton.hidden = YES;
    }
}
-(void)popGesture{
    self.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
    pan.delegate = self;
    pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:pan];
    NSMutableArray * _targets = [self.interactivePopGestureRecognizer valueForKey:@"_targets"];
    id _UINavigationInteractiveTransition = [[_targets firstObject] valueForKey:@"_target"];
    SEL popAction = NSSelectorFromString(@"handleNavigationTransition:");
    [pan addTarget:_UINavigationInteractiveTransition action:popAction];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    barView = [[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [barView clickBackButton:^(UIButton *button) {
        [self popViewControllerAnimated:YES];
    }];
    [viewController.view addSubview:barView];
    if (self.viewControllers.count==0) {
        barView.backButton.hidden = YES;
    }
    if(self.viewControllers.count>0){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if (viewController.navigationBarHidden) {
        barView.hidden = YES;
    }
    if (viewController.navigationBarBackgroundColor) {
        barView.backgroundColor = viewController.navigationBarBackgroundColor;
    }
    if (viewController.navgationBarBottomLineHidden) {
        barView.bottomLine.hidden = YES;
    }
    if (viewController.navigationBar) {
        [barView addSubview:viewController.navigationBar];
    }
    barView.title = viewController.title;
    [super pushViewController:viewController animated:animated];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

+(void)chanegAlphaWith:(CGFloat)alpha
{
    barView.alpha = alpha;
}

+(void)changeViewWith:(UIView *)placeView
{
    [barView addSubview:placeView];
}

+(void)removePlaceView:(UIView *)placeView
{
    
}

+(void)addOtherView:(UIView *)otherView withFrame:(CGRect)frame
{
    otherView.frame = frame;
    [barView addSubview:otherView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end





