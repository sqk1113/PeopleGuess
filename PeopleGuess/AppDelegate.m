//
//  AppDelegate.m
//  PeopleGuess
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "Reachability.h"
#import "UserCenterController.h"
#import "TMNavigationController.h"
#import "MainController.h"
#import "CoreArchive.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self getValueForKeyInUserInfo];
    if ([Tool isBlankString:[Singleton sharedSingleton].userId])
    {
        LoginController *vc = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
        [self.window setRootViewController:vc];
    }
    else
    {
        [self initDrawer];
    }
    return YES;
}


-(void)initDrawer{
    UserCenterController *leftController = [[UserCenterController alloc]init];
    TMNavigationController * nav = [[TMNavigationController alloc]initWithRootViewController:[MainController new]];
    _drawerController=[[MMDrawerController alloc]initWithCenterViewController:nav leftDrawerViewController:leftController];
    [_drawerController setShowsShadow:NO];
    [_drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*0.80];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.window setRootViewController:_drawerController];
}

//清空数据
- (void)clearUserInfo
{
    [CoreArchive removeStrForKey:KUserID];
    [CoreArchive removeStrForKey:KLID];
    [CoreArchive removeStrForKey:KJpushToken];
    [CoreArchive removeStrForKey:KNickName];
    [CoreArchive removeStrForKey:KUmengToken];
    [CoreArchive removeStrForKey:KHasPayPass];
    [CoreArchive removeStrForKey:KGender];
    [CoreArchive removeStrForKey:KMobile];
    [CoreArchive removeStrForKey:KLogo];
    [Singleton sharedSingleton].userId=nil;
    [Singleton sharedSingleton].lId=nil;
    [Singleton sharedSingleton].nickName=nil;
    [Singleton sharedSingleton].jpushToken=nil;
    [Singleton sharedSingleton].umengToken=nil;
    [Singleton sharedSingleton].hasPayPass=nil;
    [Singleton sharedSingleton].gender=nil;
    [Singleton sharedSingleton].mobile=nil;
    [Singleton sharedSingleton].logo=nil;
    
}

//赋值数据
- (void)getValueForKeyInUserInfo
{
    [Singleton sharedSingleton].userId     = [CoreArchive strForKey:KUserID];
    [Singleton sharedSingleton].lId        = [CoreArchive strForKey:KLID];
    [Singleton sharedSingleton].nickName   = [CoreArchive strForKey:KNickName];
    [Singleton sharedSingleton].jpushToken = [CoreArchive strForKey:KJpushToken];
    [Singleton sharedSingleton].umengToken = [CoreArchive strForKey:KUmengToken];
    [Singleton sharedSingleton].gender     = [CoreArchive strForKey:KGender];
    [Singleton sharedSingleton].hasPayPass = [CoreArchive strForKey:KHasPayPass];
    [Singleton sharedSingleton].mobile     = [CoreArchive strForKey:KMobile];
    [Singleton sharedSingleton].logo       = [CoreArchive strForKey:KLogo];
}
#pragma mark - 获取网络类型

+ (NSString *)networkStatus
{
    NSString *networkType = nil;
    NetworkStatus net = [self getCurrentNetStatus];
    switch (net)
    {
        case NotReachable:
        {
            networkType = @"unicom";
        }
            break;
        case ReachableViaWiFi:
        {
            networkType = @"4-0";
        }
            break;
        case ReachableVia2G:
        {
            networkType = @"0-2";
        }
            break;
        case ReachableVia3G:
        {
            networkType = @"0-3";
        }
            break;
        default:
        {
            networkType = @"0-0";
        }
            break;
    }
    return networkType;
}

+ (NetworkStatus)getCurrentNetStatus
{
    Reachability *reach = [Reachability reachabilityWithHostName:DOMAIN_NAME];
    NetworkStatus networks = [reach currentReachabilityStatus];
    return networks;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
