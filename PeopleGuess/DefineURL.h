//
//  DefineURL.h
//  FYZKitchen
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenUDID.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "Toast.h"
#import "Singleton.h"
#import "Tool.h"
#import "Masonry.h"
#import "NSString+Extension.h"
#import "TMNavigationController.h"
#import "DatasHandler.h"
#import "ZZHttpTool.h"
#import "DESEncryptFile.h"
#import "ResponseObject.h"
#import "CoreArchive.h"
#import <AdSupport/AdSupport.h>

#define SERVER_HOST                   @"http://192.168.20.102:8080/"  //正式环境
//#define SERVER_HOST                   @"http://cms.orenda.com.cn/"   //线上环境
//#define SERVER_HOST                   @"http://cms.orenda.com.cn:4910/"   //线上环境
//#define SERVER_HOST                   @"http://450530a0.nat123.net/"   //测试环境
//#define SERVER_HOST                   @"http://wp.joyi.cn/"   //测试环境
#define DOMAIN_NAME                   @"www.baidu.com"                //域名
#define API_VERSON                    @"20160616"                     //api版本号
#define TIMESTAMP                     [[NSDate date] timeIntervalSince1970]   //接口请求时间戳
#define GETPHONECODE                  @"api/common/sendSms"           //获取手机验证码
#define USERLOGIN                     @"api/user/login"               //用户登录
#define USERINFO                      @"api/user/userInfo"            //用户信息
#define CHARGECENTER                  @"api/userCharge/chargeCenter"  //充值中心
#define USERCHARGE                    @"api/userCharge/payInit"       //充值验证
#define TAKEPARYTOPIC                 @"api/stTakePart/takePartTopic"   //我参与的
#define MYCREATELIST                  @"api/sysChildTopic/createList"   //我发布的
#define MYWATERLIST                   @"api/userTakePart/takePartList"   //我的流水
#define EXCHANGELIST                  @"api/userIncreaseConsume/exchangeList"//兑换明细
#define USERUPDATE                    @"api/user/update"              //设置个人中心
#define UPDATELOGO                    @"api/user/updateLogo"          //上传头像
#define LOGINOUT                      @"api/user/logout"              //登出
//网络类型
#define k_NetworkType [AppDelegate networkStatus]
#define k_Apn  ([Reachability getWifiName]?[Reachability getWifiName]:@"")
#define k_deviceId  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
#define k_imei   [[OpenUDID value] stringByReplacingOccurrencesOfString:@"-" withString:@""]
#define k_mac  @"000000000000"
#define k_latitude [@([[DatasHandler defaultProvincesHandle] coordinate2D].latitude) stringValue]
#define k_longitude [@([[DatasHandler defaultProvincesHandle] coordinate2D].longitude) stringValue]
#define k_ua     [[UIDevice currentDevice] model]
#define k_os     @"1"
#define k_osv    [[UIDevice currentDevice] systemVersion]
#define k_ver    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define k_r      [NSString stringWithFormat:@"%.0f*%.0f", [[UIScreen mainScreen] bounds].size.width*[UIScreen mainScreen].scale, [[UIScreen mainScreen] bounds].size.height*[UIScreen mainScreen].scale]
#define k_brand  [[UIDevice currentDevice] model]
//appstore:21   //企业版:
#define k_channelId @"100000"
#define k_platform @"0"

//信息存储
#define KUserID      @"kuserid"
#define KLID         @"klid"
#define KJpushToken  @"kjpushToken"
#define KNickName    @"knickName"
#define KUmengToken  @"kumengToken"
#define KGender      @"gender"
#define KHasPayPass  @"hasPayPass"
#define KMobile      @"mobile"
#define KLogo        @"logo"
