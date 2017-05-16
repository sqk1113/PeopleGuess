//
//  LoginController.m
//  PeopleGuess
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LoginController.h"



@interface LoginController ()

@property (nonatomic,strong)UITextField *tfTelNum;
@property (nonatomic,strong)UITextField *tfCodeNum;

@end
static  int32_t gLunarHolDay[]=
{
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77, //1901
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X87, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78, //1902
    0X96, 0XA5, 0X87, 0X96, 0X87, 0X87, 0X79, 0X69, 0X69, 0X69, 0X78, 0X78, //1903
    0X86, 0XA5, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X78, 0X87 //1904
};
@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUIWithLoginVC];
}
- (void)getCodeWithPhoneNum
{
    if ([Tool isBlankString:_tfTelNum.text]) {
        [[Toast shareToast]makeText:@"请输入手机号" time:1];
        return;
    }
    MBProgressHUD *hud = [Tool showMBProgressHUDWithTitle:@"正在发送验证码" inView:self.view];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_tfTelNum.text forKey:@"mobile"];
    [dic setValue:@(1) forKey:@"type"];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];

    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,GETPHONECODE]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            hud.labelText = @"发送成功，请注意查收";
            [hud hide:YES afterDelay:1];
        }
        else
        {
            hud.labelText = response.msg;
            [hud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        hud.labelText = @"发送失败，请稍后再试";
        [hud hide:YES afterDelay:1];
    }];
}

- (void)loginWithPhoneNum
{
    if ([Tool isBlankString:_tfTelNum.text]) {
        [[Toast shareToast]makeText:@"请输入手机号" time:1];
        return;
    }
    if ([Tool isBlankString:_tfCodeNum.text]) {
        [[Toast shareToast]makeText:@"请输入验证码" time:1];
        return;
    }
    MBProgressHUD *hud = [Tool showMBProgressHUDWithTitle:@"正在登录" inView:self.view];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_tfTelNum.text forKey:@"mobile"];
    [dic setValue:_tfCodeNum.text forKey:@"validateCode"];
    [dic setValue:@"" forKey:@"umengToken"];
    [dic setValue:@"" forKey:@"jpushTocken"];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,USERLOGIN]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            hud.labelText = @"登录成功";
            [hud hide:YES afterDelay:1];
            [CoreArchive setStr:[response.data objectForKey:@"jpushToken"] key:KJpushToken];
            [CoreArchive setStr:[response.data objectForKey:@"lId"]        key:KLID];
            [CoreArchive setStr:[response.data objectForKey:@"nickName"]   key:KNickName];
            [CoreArchive setStr:[response.data objectForKey:@"umengToken"] key:KUmengToken];
            [CoreArchive setStr:[response.data objectForKey:@"userId"]     key:KUserID];
            [CoreArchive setStr:[response.data objectForKey:@"gender"]     key:KGender];
            [CoreArchive setStr:[response.data objectForKey:@"hasPayPass"]     key:KHasPayPass];
            [CoreArchive setStr:[response.data objectForKey:@"mobile"]     key:KMobile];
            [CoreArchive setStr:[response.data objectForKey:@"logo"]     key:KLogo];
            //赋值数据
            [ApplicationDelegate getValueForKeyInUserInfo];
            [ApplicationDelegate initDrawer];
        }
        else
        {
            hud.labelText = response.msg;
            [hud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        hud.labelText = @"登录失败，请稍后再试";
        [hud hide:YES afterDelay:1];
    }];

}
#pragma mark UI
- (void)creatUIWithLoginVC
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"bg_image_login.png"];
    [self.view addSubview:backImage];
    
    UILabel *lbPrompt = [[UILabel alloc]initWithFrame:CGRectMake(0, 318/2*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 15)];
    lbPrompt.text = @"登陆后方可参与竞猜活动";
    lbPrompt.textColor = [UIColor whiteColor];
    lbPrompt.backgroundColor = [UIColor clearColor];
    lbPrompt.textAlignment = NSTextAlignmentCenter;
    lbPrompt.font = [UIFont fontWithName:PFTHINFONT size:15];
    [self.view addSubview:lbPrompt];
    
    UIView *viewTel = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-230*SCREEN_WIDTH_RATE)/2, VIEWY(lbPrompt)+75*SCREEN_WIDTH_RATE, 230*SCREEN_WIDTH_RATE, 32*SCREEN_WIDTH_RATE)];
    viewTel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewTel];
    
    UIView *viewCode = [[UIView alloc]initWithFrame:CGRectMake(viewTel.frame.origin.x, VIEWY(viewTel)+20*SCREEN_WIDTH_RATE, 230*SCREEN_WIDTH_RATE, 32*SCREEN_WIDTH_RATE)];
    viewCode.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewCode];
    
    UIImageView *telicon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 12*SCREEN_WIDTH_RATE, 12*SCREEN_WIDTH_RATE)];
    telicon.image = [UIImage imageNamed:@"mine_login"];
    [viewTel addSubview:telicon];
    
    _tfTelNum = [[UITextField alloc]initWithFrame:CGRectMake(VIEWX(telicon)+13*SCREEN_WIDTH_RATE, 1, 230*SCREEN_WIDTH_RATE-VIEWX(telicon)-13*SCREEN_WIDTH_RATE, 30*SCREEN_WIDTH_RATE)];
    NSString *holderText = @"请输入手机号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xffffff)
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:PFTHINFONT size:13*SCREEN_WIDTH_RATE]
                        range:NSMakeRange(0, holderText.length)];
    _tfTelNum.attributedPlaceholder = placeholder;
    _tfTelNum.textColor = [UIColor whiteColor];
    _tfTelNum.font =[UIFont fontWithName:PFTHINFONT size:13*SCREEN_WIDTH_RATE];
    _tfTelNum.keyboardType = UIKeyboardTypeNumberPad;
    [viewTel addSubview:_tfTelNum];
    [Tool addSepLine:CGRectMake(0,32*SCREEN_WIDTH_RATE-0.5 , 230*SCREEN_WIDTH_RATE, 0.5) inView:viewTel];
    
    UIImageView *codeicon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 12*SCREEN_WIDTH_RATE, 12*SCREEN_WIDTH_RATE)];
    codeicon.image = [UIImage imageNamed:@"code_login"];
    [viewCode addSubview:codeicon];
    
    _tfCodeNum = [[UITextField alloc]initWithFrame:CGRectMake(VIEWX(codeicon)+13*SCREEN_WIDTH_RATE, 1, 230*SCREEN_WIDTH_RATE-VIEWX(codeicon)-13*SCREEN_WIDTH_RATE - 80*SCREEN_WIDTH_RATE, 30*SCREEN_WIDTH_RATE)];
    NSString *holderText2 = @"请输入验证码";
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc]initWithString:holderText2];
    [placeholder2 addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xffffff)
                        range:NSMakeRange(0, holderText2.length)];
    [placeholder2 addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:PFTHINFONT size:13*SCREEN_WIDTH_RATE]
                        range:NSMakeRange(0, holderText2.length)];
    _tfCodeNum.attributedPlaceholder = placeholder2;
    _tfCodeNum.textColor = [UIColor whiteColor];
    _tfCodeNum.font =[UIFont fontWithName:PFTHINFONT size:13*SCREEN_WIDTH_RATE];
    _tfCodeNum.keyboardType = UIKeyboardTypeNumberPad;
    [viewCode addSubview:_tfCodeNum];
    [Tool addSepLine:CGRectMake(0, 32*SCREEN_WIDTH_RATE-0.5, 230*SCREEN_WIDTH_RATE-80*SCREEN_WIDTH_RATE, 0.5) inView:viewCode];
    
    UIButton *btnGetCode = [[UIButton alloc]initWithFrame:CGRectMake(VIEWX(_tfCodeNum)+12*SCREEN_WIDTH_RATE, 1, 68*SCREEN_WIDTH_RATE, 30*SCREEN_WIDTH_RATE)];
    [btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnGetCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnGetCode setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    btnGetCode.titleLabel.font = [UIFont fontWithName:PFMEDIUMFONT size:12];
    [btnGetCode addTarget:self action:@selector(getCodeWithPhoneNum) forControlEvents:UIControlEventTouchUpInside];
    [viewCode addSubview:btnGetCode];
    
    UIButton *btnLogin = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-230*SCREEN_WIDTH_RATE)/2, VIEWY(viewCode)+36*SCREEN_WIDTH_RATE, 230*SCREEN_WIDTH_RATE, 40*SCREEN_WIDTH_RATE)];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"bg_login"] forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:17];
    [btnLogin addTarget:self action:@selector(loginWithPhoneNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    UILabel *lbThreeLogin = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEWY(btnLogin)+40*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 13*SCREEN_WIDTH_RATE)];
    lbThreeLogin.text = @"第三方登录";
    lbThreeLogin.textColor = [UIColor whiteColor];
    lbThreeLogin.textAlignment = NSTextAlignmentCenter;
    lbThreeLogin.font = [UIFont fontWithName:PFMEDIUMFONT size:13*SCREEN_WIDTH_RATE];
    [self.view addSubview:lbThreeLogin];
    
    UIButton *sinaLogin = [[UIButton alloc]initWithFrame:CGRectMake(65*SCREEN_WIDTH_RATE, VIEWY(lbThreeLogin)+57*SCREEN_WIDTH_RATE, 47*SCREEN_WIDTH_RATE, 47*SCREEN_WIDTH_RATE)];
    [sinaLogin setBackgroundImage:[UIImage imageNamed:@"microblog_login"] forState:UIControlStateNormal];
    [self.view addSubview:sinaLogin];
    
    UIButton *WXLogin = [[UIButton alloc]initWithFrame:CGRectMake(VIEWX(sinaLogin)+52*SCREEN_WIDTH_RATE, VIEWY(lbThreeLogin)+57*SCREEN_WIDTH_RATE, 47*SCREEN_WIDTH_RATE, 47*SCREEN_WIDTH_RATE)];
    [WXLogin setBackgroundImage:[UIImage imageNamed:@"wechat_login"] forState:UIControlStateNormal];
    [self.view addSubview:WXLogin];
    
    UIButton *QQLogin = [[UIButton alloc]initWithFrame:CGRectMake(VIEWX(WXLogin)+52*SCREEN_WIDTH_RATE, VIEWY(lbThreeLogin)+57*SCREEN_WIDTH_RATE, 47*SCREEN_WIDTH_RATE, 47*SCREEN_WIDTH_RATE)];
    [QQLogin setBackgroundImage:[UIImage imageNamed:@"QQ_login"] forState:UIControlStateNormal];
    [self.view addSubview:QQLogin];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 50*SCREEN_WIDTH_RATE)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50*SCREEN_WIDTH_RATE)];
    bottomImage.image = [UIImage imageNamed:@"bg_explain_login"];
    [bottomView addSubview:bottomImage];
    
    NSString *str = @"登录或注册即同意猜猜看";
    CGSize size =  [str sizeWithFont:[UIFont fontWithName:PFTHINFONT size:13*SCREEN_WIDTH_RATE]];
    
    UILabel *lbUserService = [[UILabel alloc]initWithFrame:CGRectMake(73*SCREEN_WIDTH_RATE, 19*SCREEN_WIDTH_RATE, size.width, size.height)];
    lbUserService.text = str;
    lbUserService.font = [UIFont fontWithName:PFTHINFONT size:13*SCREEN_WIDTH_RATE];
    lbUserService.textColor = [UIColor whiteColor];
    [bottomView addSubview:lbUserService];
    
    NSString *str1 = @"用户服务协议";
    CGSize size1 =  [str1 sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:13*SCREEN_WIDTH_RATE]];
    UIButton *btnUserService = [[UIButton alloc]initWithFrame:CGRectMake(VIEWX(lbUserService)+10, 19*SCREEN_WIDTH_RATE, size1.width, size1.height)];
    [btnUserService setTitle:str1 forState:UIControlStateNormal];
    [btnUserService setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnUserService.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:13*SCREEN_WIDTH_RATE];
    [bottomView addSubview:btnUserService];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
