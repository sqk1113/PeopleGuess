//
//  PayCenterController.m
//  PeopleGuess
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayCenterController.h"
#import "PayCenterPayCell.h"
#import "HeadView.h"
#import "PayCenterModel.h"
#import "WXApi.h"
#import "Order.h"
#import "NSString+Additions.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "THUtility.h"
#import "PayeDetailController.h"
@interface PayCenterController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_appstoreHud;
    BOOL isPaying; //正在充值的状态
    NSString *spkey;
    SKPaymentTransaction *_curPayment;
    NSString *_curProduct;
    NSString *_curGivedMoney;
    NSString *_curRemark;//提示语
    NSString *_curGiftB;//额外赠送
    NSString *_curPayMoney;//实际价格（支付价格）
    NSString *_curMoney;//本来价格
    int _curPayType;//支付类型
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSString *totalCount;
@property (nonatomic,strong) NSString *exchangeCount;
@property (nonatomic,strong) NSMutableArray *buyListArr;
@property (nonatomic,strong) NSMutableArray *typeListArr;
@property (nonatomic,strong) UILabel *lbPrice;
@property (nonatomic,strong) UILabel *lbRemark;
@property (nonatomic,strong) UILabel *lbTotalText;

@property (nonatomic, strong) NSString *orderId; //订单id
@end

@implementation PayCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buyListArr = [NSMutableArray array];
    _typeListArr = [NSMutableArray array];
    self.title = @"充值中心";
    self.navigationBarBackgroundColor = NAVBARMAINCOLOR;
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:17];
    [rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget: self action:@selector(toDetailWithPay) forControlEvents:UIControlEventTouchUpInside];
    [TMNavigationController addOtherView:rightBtn withFrame:CGRectMake(SCREEN_WIDTH-55, 24, 55, 40)];
    [self refreshData];
}

- (void)refreshData
{
    [Tool removeErrorView:self.view];
    [Tool addLoadinView:self.view center:CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2)];
    [self requestDataWithPayCenter];
}

#pragma mark 逻辑处理
-(void)logicHandle
{
    
}

//初始选择金额和支付方式
- (void)selectWithBegin
{
    ChargeModel *m = [_buyListArr firstObject];
    m.isSelected = YES;
    _curGiftB =[NSString stringWithFormat:@"%ld",m.giftCoinNum];
    _curMoney =[NSString stringWithFormat:@"%.2f",m.price] ;
    _curPayMoney = [NSString stringWithFormat:@"%.2f",m.payPrice] ;
    _curRemark = m.remark;

    PayTypeModel *m1 = [_typeListArr firstObject];
    m1.isSelected = YES;
    _curPayType = (int)m1.payType;
}

//底部价格改变
- (void)changeBottomLabelText
{
    if (_curPayType!=102) {
        NSString *str = [NSString stringWithFormat:@"￥%@",_curPayMoney];
        CGSize size = [str sizeWithFont:[UIFont fontWithName:PFMEDIUMFONT size:17] maxW:200];
        _lbPrice.text = str;
        _lbPrice.frame = CGRectMake(VIEWX(_lbTotalText), 0, size.width, 50*SCREEN_WIDTH_RATE);
        
        NSString *remark = [NSString stringWithFormat:@"%@",_curRemark];
        CGSize size1 = [remark sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:15]];
        _lbRemark.frame = CGRectMake(VIEWX(_lbPrice)+6,0 , size1.width, 50*SCREEN_WIDTH_RATE);
        _lbRemark.text = _curRemark;
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"￥%@",_curMoney];
        CGSize size = [str sizeWithFont:[UIFont fontWithName:PFMEDIUMFONT size:17] maxW:200];
        _lbPrice.text = str;
        _lbPrice.frame = CGRectMake(VIEWX(_lbTotalText), 0, size.width, 50*SCREEN_WIDTH_RATE);
        NSString *remark = [NSString stringWithFormat:@"%@",_curRemark];
        CGSize size1 = [remark sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:15]];
        _lbRemark.frame = CGRectMake(VIEWX(_lbPrice)+6,0 , size1.width, 50*SCREEN_WIDTH_RATE);
        _lbRemark.text = _curRemark;
    }
}


#pragma mark RequestData
- (void)requestDataWithPayCenter
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,CHARGECENTER]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        [Tool removeLoadingView:self.view];
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            PayCenterModel *payCenter = [[PayCenterModel alloc] initWithJSONDictionary:response.data];
            _buyListArr  = payCenter.chargeItems;
            _typeListArr = payCenter.payTypes;
            _totalCount  = [NSString stringWithFormat:@"%ld", payCenter.remain];
            _exchangeCount = [NSString stringWithFormat:@"%ld", payCenter.exchangeCoin];
            [self creatUIWithPayCenter];
            [self creatBottomUI];
            [self selectWithBegin];
            [_table reloadData];
        }
        else
        {
            [Tool addErrorView:self.view center:self.view.center title:response.msg target:self selector:@selector(refreshData)];
        }
        
    } failure:^(NSError *error) {
        [Tool removeLoadingView:self.view];
        [Tool addErrorView:self.view center:self.view.center title:@"连接超时" target:self selector:@selector(refreshData)];
    }];
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _buyListArr.count;
    }
    else{
        return _typeListArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        PayCenterPayCell * cell = [PayCenterPayCell cellWithTableView:tableView];
        ChargeModel *m = [_buyListArr objectAtIndex:indexPath.row];
        cell.icon.image = [UIImage imageNamed:@"beans_rechargecenter"];
        cell.lbText.text = m.name;
        if (m.isSelected == YES) {
            cell.imgisSelected.image = [UIImage imageNamed:@"choose_rechargecenter"];
        }
        else
        {
            cell.imgisSelected.image = [UIImage imageNamed:@"unchoose_rechargecenter"];
        }
        if (indexPath.row!=_buyListArr.count-1) {
            [Tool addSepLine:CGRectMake(17*SCREEN_WIDTH_RATE, 44*SCREEN_WIDTH_RATE-0.5, SCREEN_WIDTH-17*SCREEN_WIDTH_RATE, 0.5) inView:cell];
        }
        return cell;
    }
    else
    {
        PayCenterPayCell * cell = [PayCenterPayCell cellWithTableView:tableView];
        PayTypeModel *m = [_typeListArr objectAtIndex:indexPath.row];
        
        cell.lbText.text = m.payDec;
        if (m.isSelected == YES) {
            cell.imgisSelected.image = [UIImage imageNamed:@"choose_rechargecenter"];
        }
        else
        {
            cell.imgisSelected.image = [UIImage imageNamed:@"unchoose_rechargecenter"];
        }
        if (m.payType==100)
        {
            cell.icon.image = [UIImage imageNamed:@"alipay_rechargecenter"];
        }
        else if (m.payType==101)
        {
            cell.icon.image = [UIImage imageNamed:@"wechat_rechargecenter"];
        }
        else
        {
            cell.icon.image = [UIImage imageNamed:@"apple_pay_rechargecenter"];
        }
        if (indexPath.row!=_typeListArr.count-1) {
            [Tool addSepLine:CGRectMake(17*SCREEN_WIDTH_RATE, 44*SCREEN_WIDTH_RATE-0.5, SCREEN_WIDTH-17*SCREEN_WIDTH_RATE, 0.5) inView:cell];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(13*SCREEN_WIDTH_RATE, 18*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 14*SCREEN_WIDTH_RATE)];
    view.backgroundColor = BACKGROINDCOLOR;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13*SCREEN_WIDTH_RATE, 18*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 14*SCREEN_WIDTH_RATE)];
    label.textColor = UIColorFromRGB(0x888888);
    label.font = [UIFont fontWithName:PFREGULARFONT size:14*SCREEN_WIDTH_RATE];
    [view addSubview:label];
    if (section==0)
    {
        label.text = @"购买金豆";
    }
    else
    {
        label.text = @"支付方式";
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*SCREEN_WIDTH_RATE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42*SCREEN_WIDTH_RATE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    if (indexPath.section==0)
    {
        for (int i=0; i<_buyListArr.count; i++) {
            ChargeModel *m = [_buyListArr objectAtIndex:i];
            if (i==indexPath.row) {
                m.isSelected = YES;
                _curGiftB =[NSString stringWithFormat:@"%ld",m.giftCoinNum];
                _curMoney =[NSString stringWithFormat:@"%.2f",m.price] ;
                _curPayMoney = [NSString stringWithFormat:@"%.2f",m.payPrice] ;
                _curRemark = m.remark;
            }
            else{
                m.isSelected = NO;
            }
        }
    }
    else
    {
        for (int i=0; i<_typeListArr.count; i++) {
            PayTypeModel *m = [_typeListArr objectAtIndex:i];
            if (i==indexPath.row) {
                m.isSelected = YES;
                _curPayType = (int)m.payType;
            }
            else{
                m.isSelected = NO;
            }
        }
    }
    [self changeBottomLabelText];
    [tableView reloadData];
}

#pragma mark payMethod点击支付逻辑处理
- (void)clickBtnWithPay
{
    [self toPayWith:_curPayType withCurrentMoneny:@""];
}

- (void)toPayWith:(int)payType withCurrentMoneny:(NSString *)curMoneny
{
    isPaying = YES;
    if(payType == 101)
    {
        [self wxPay];
    }
    else if(payType == 102){
        if ([SKPaymentQueue canMakePayments]) {
            [self performSelector:@selector(RequestProductData) withObject:nil afterDelay:0.3];
            NSLog(@"允许程序内付费购买");
        }
        else
        {
            NSLog(@"不允许程序内付费购买");
            [Tool showAlertWithTitle:@"温馨提示" message:@"你没允许应用程序内购买"];
        }
    }
    else if(payType == 100){
        [self performSelector:@selector(alixPay) withObject:nil afterDelay:0.3];
    }

}

#pragma mark 微信
- (void)wxPay{
    _appstoreHud = [Tool showMBProgressHUDWithTitle:@"正在发送购买请求" inView:ApplicationDelegate.window];
    //_curMoney
//    [ApplicationDelegate.myEngine validatePayResultWithUserId:[Singleton sharedSingleton].userID receipt:@"" price:_curMoney payPrice:_curPayMoney giftCoinNum:_curGiftB payType:@"105" completionHandler:^(NSDictionary *dictionary) {
//        int code = [[dictionary objectForKey:@"code"]intValue];
//        if(code == 0){
//            
//            NSDictionary *sendStrDic = [dictionary objectForKey:@"data"];
//            NSString *str = [sendStrDic objectForKey:@"wxData"];
//            
//            NSDictionary *param = [THUtility dictionaryWithJsonString:str];
//            
//            
//            //            NSString    *package, *time_stamp, *nonce_str;
//            //            //设置支付参数
//            //            time_t now;
//            //            time(&now);
//            //            time_stamp  = [NSString stringWithFormat:@"%ld", now];
//            //            nonce_str	= [time_stamp md5];
//            //            //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
//            //            //package       = [NSString stringWithFormat:@"Sign=%@",package];
//            //            package         = @"Sign=WXPay";
//            //            //第二次签名参数列表
//            //            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
//            //            [signParams setObject: [param objectForKey:@"appid"]        forKey:@"appid"];
//            //            [signParams setObject: nonce_str    forKey:@"noncestr"];
//            //            [signParams setObject: package      forKey:@"package"];
//            //            [signParams setObject: [param objectForKey:@"partnerid"]        forKey:@"partnerid"];
//            //            [signParams setObject: time_stamp   forKey:@"timestamp"];
//            //            [signParams setObject: [param objectForKey:@"prepayid"]     forKey:@"prepayid"];
//            //
//            //            spkey = @"1225438902";
//            //
//            //            //生成签名
//            //            NSString *sign  = [self createMd5Sign:signParams];
//            //
//            //
//            //            PayReq *request = [[PayReq alloc] init];
//            //            request.openID  = [param objectForKey:@"appid"];
//            //            request.partnerId = [param objectForKey:@"partnerid"];
//            //            request.prepayId = [param objectForKey:@"prepayid"];
//            //            request.package = package;
//            //            request.nonceStr = nonce_str;
//            //            request.timeStamp = [time_stamp intValue];
//            //            request.sign = sign;
//            //
//            
//            PayReq *request = [[PayReq alloc] init];
//            request.openID  = [param objectForKey:@"appid"];
//            request.partnerId = [param objectForKey:@"partnerid"];
//            request.prepayId = [param objectForKey:@"prepayid"];
//            request.package = [param objectForKey:@"package"];
//            request.nonceStr = [param objectForKey:@"noncestr"];
//            request.timeStamp = [[param objectForKey:@"timestamp"] intValue];
//            request.sign = [param objectForKey:@"sign"];
//            
//            _orderId = [param objectForKey:@"orderId"];
//            //NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.openID,request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
//            
//            
//            [WXApi sendReq:request];
//        }
//        else{
//            [_appstoreHud hide:NO];
//            NSString *alertInfo = [dictionary objectForKey:@"codeInfo"];
//            [OwnerTool showAlertWithTitle:@"请求失败" message:alertInfo];
//        }
//        
//    } errorHandler:^(NSError *error) {
//        [_appstoreHud hide:NO];
//        [UIAlertView showWithError:error];
//    }];
//    
}


//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", spkey];
    //得到MD5 sign签名
    NSString *md5Sign =[contentString md5];
    return md5Sign;
}


- (void)wxPaySuccess:(NSNotification *)notification{
    NSLog(@"success");
    //充值成功
    [self showSuccess];
}

#pragma mark 支付宝
- (void)alixPay{
    _appstoreHud = [Tool showMBProgressHUDWithTitle:@"正在发送购买请求" inView:ApplicationDelegate.window];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@(100) forKey:@"payType"];
    [dic setValue:_curMoney forKey:@"price"];
    [dic setValue:_curPayMoney forKey:@"payPrice"];
    [dic setValue:API_VERSON forKey:@"giftCoin"];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,USERCHARGE]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            [_appstoreHud hide:YES afterDelay:1];
            NSDictionary *sendStrDic = response.data;
            NSDictionary *str = [sendStrDic objectForKey:@"aliPayData"];
//            NSDictionary *param = [THUtility dictionaryWithJsonString:str];
            CGFloat fee = [[str objectForKey:@"total_fee"] floatValue];
            //订单id
            _orderId = [str objectForKey:@"out_trade_no"];
            NSString *urlStr = [str objectForKey:@"notify_url"];
            [self beginAlipayWithTradeNO:[str objectForKey:@"out_trade_no"] productName:[str objectForKey:@"subject"] productDescription:[str objectForKey:@"body"] amount:fee notifyURL:urlStr withSigStr:[response.data objectForKey:@"sendStr"]];
        }
        else
        {
            _appstoreHud.labelText = response.msg;
            [_appstoreHud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        _appstoreHud.labelText = @"连接超时，请稍后再试";
        [_appstoreHud hide:YES afterDelay:1];
    }];
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)beginAlipayWithTradeNO:(NSString *)tradeNO productName:(NSString *)productName productDescription:(NSString *)productDescription amount:(CGFloat )amount notifyURL:(NSString *)notifyURL withSigStr:(NSString*)singStr{
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088911439658303";
    NSString *seller = @"sinocall_caiwu@163.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL7hk9teN3rcBPehLqgjNz4pfWqcQ83MFNbQXiJDD4ipqyxwBUGzR62X8lnyBK1qHGTn8pRYQVemzNxMNdUtw1ViqCIC7Ya7lnfqnFop4qTAQK6ohw7EQiktzbOkoCZGySL3HIUnDlYaHpq29eBdUMvjTtoYaij17anMAmb8F4E1AgMBAAECgYAlGDFjsCuX9KoCdZBbnHxf2DBHR5blp4NlO5kPj3i1VkOtnxdmbTDAy4aNdDr0eGqMMYcyzPPl1MR7C1Rq2TncR9th46c0Tf8QLjolCbdl7hKKa6C5OHOxdhVsvlOhbTLhcq8ELk3Mf2ixWDrKWRKFtanfbOqvdYBOQeBsTHs1AQJBAO/g1Wx6X5Z6awiDlvM3PXR38l8Ih/PnDAo7LTZ2FV4FYZZP/2E7JcNg/Y4QwTDrtKkk+Ht0pL+zkhkWQyfuMpMCQQDLtbyG1HCwTFQDVh/CUa6VQxjyb6Kb/u9GKukWre4orZd1DQcc8OGZ2jjMq9Lf6kLNJZkdZibxFf82fJQh1vIXAkAJhwmTDG09gdE8flWBhYEoXhc/VQxpUJT21xDdp+UDXf1ZRgYjq4C9eN25RcsWkVYUncZMyP4+KvizjGHQdTKHAkEAmrRDH7Y4ensNFpeSePWle2/Ag2VqfcPnHUe7SuD+TGBA9MDXFRCOlFQY7L7U3/49iySxmpUYn+DPuCZ2LRjbMwJAaHyiig3a4KLN6BOqbK+sXDDXPTaKcCLRUrYE4BgP05IkszbBHU281ZX2ial7Zk27aB2ehI2IiOww40DUSW1edg==";
//    NSString *privateKey = @"rRASMbzNGz7qzcjZGgMfqo2A2g5oyegKrymvOkNVGUcpmtTjGEc5JCzFZfrHPL5IWysObdeD9y87OLtUFw5a+KfWVH4x0Rxy/ZYHLb6k8w7Fc4mjEGvvyRQyu3fuQQMejcLSHSl74Rcvs1/yzaMOYid34vjaQ842LcIlD/sZNpo=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    order.notifyURL = notifyURL;
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"PeopleGuess";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString111 = [signer signString:orderSpec];
    NSLog(@"%@",signedString111);
    
    NSString *signedString = singStr;
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:singStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //NSLog(@"reslut = %@",resultDic);
            [_appstoreHud hide:NO];
            if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]){
                NSString *resultSting = [resultDic objectForKey:@"result"];
                NSArray *resultStringArray =[resultSting componentsSeparatedByString:NSLocalizedString(@"&", nil)];
                for (NSString *str in resultStringArray){
                    NSString *newstring = nil;
                    newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                    for (int i = 0 ; i < [strArray count] ; i++)
                    {
                        NSString *st = [strArray objectAtIndex:i];
                        if ([st isEqualToString:@"success"])
                        {
                            //NSLog(@"%@",[strArray objectAtIndex:1]);
                            if([[strArray objectAtIndex:1]isEqualToString:@"true"]){
                                //充值成功
                                [self showSuccess];
                                return;
                            }
                        }
                    }
                }
                
                [Tool showAlertWithTitle:@"充值失败" message:[resultDic objectForKey:@"memo"]];
            }
            else{
                [Tool showAlertWithTitle:@"充值失败" message:[resultDic objectForKey:@"memo"]];
            }
        }];
        
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark  appstore支付
-(void)RequestProductData
{
    
    _appstoreHud = [Tool showMBProgressHUDWithTitle:@"正在发送购买请求" inView:ApplicationDelegate.window];
    
    NSLog(@"---------请求对应的产品信息------------");
    //_curProduct= @"com.sinocall.phonerecorder.68";
    NSArray *product =[[NSArray alloc] initWithObjects:_curProduct,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *skRequest=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    skRequest.delegate = self;
    [skRequest start];
}

//// 以上查询的回调函数
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    NSArray *myProduct = response.products;
//    if (myProduct.count == 0) {
//        NSLog(@"无法获取产品信息，购买失败。");
//        return;
//    }
//    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//}

//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %lu", (unsigned long)[myProduct count]);
    // populate UI
    SKPayment *payment = nil;
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        payment = [SKPayment paymentWithProduct:product];
        NSString *_storePrice = [NSString stringWithFormat:@"%@",product.price];
        NSLog(@"价格: %@" , _storePrice);
        
    }
    NSLog(@"---------发送购买请求------------");
    if(payment)
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    else{
        [_appstoreHud hide:NO];
        [Tool showAlertWithTitle:@"提示" message:@"商品反馈为空，或不存在该商品，请选择其他商品尝试购买"];
    }
}


//----监听购买结果
//用户购买的操作有结果的时候 触发
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                // NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
//                [self completeTransaction:transaction];
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"商品添加进列表");
                _curPayment = transaction;
            }
                break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                NSLog(@"-----交易失败 --------");
                [_appstoreHud hide:NO];
                [self failedTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                NSLog(@"-----已经购买过该商品 --------");
                [_appstoreHud hide:NO];
                [self restoreTransaction:transaction];
                
            default:
                break;
        }
    }
}


//- (void)completeTransaction:(SKPaymentTransaction *)transaction{
//    // Your application should implement these two methods.
//    NSString * productIdentifier = transaction.payment.productIdentifier;
//    if ([productIdentifier length] > 0) {
//        // 向自己的服务器验证购买凭证
//        NSString *transactionReceiptString= nil;
//        NSURLRequest*appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
//        
//        NSError *error = nil;
//        
//        NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
//        
//        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//        
//        //<7.0
//        //        NSData * receiptData = transaction.transactionReceipt;
//        //        transactionReceiptString = [receiptData base64EncodedString];
//        
//        //        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];//苹果推荐
//        //        NSError *error = nil;
//        //        NSData *receiptData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
//        //
//        //        NSString* encodingStr = [THUtility encodeBase64WithData:receiptData];
//        
//        _appstoreHud.labelText = @"正在验证交易凭证";
//        
//        [ApplicationDelegate.myEngine validatePayResultWithUserId:[Singleton sharedSingleton].userID receipt:transactionReceiptString price:_curMoney payPrice:_curPayMoney giftCoinNum:_curGiftB payType:@"103" completionHandler:^(NSDictionary *dictionary) {
//            [_appstoreHud hide:NO];
//            int code = [[dictionary objectForKey:@"code"]intValue];
//            if(code == 0){
//                
//                NSString *numberStr = [[dictionary objectForKey:@"data"]objectForKey:@"recordCoin"];
//                
//                if([Tool isBlankString:numberStr])
//                    iconLb.text = @"N";
//                else
//                    iconLb.text = [NSString stringWithFormat:@"%@",numberStr];
//                
//                [Singleton sharedSingleton].VoiceBNumber =  iconLb.text;
//                //修改成功后ui界面
//                NSString *showString = [NSString stringWithFormat:@"充值成功，%d个录音币已经到账，请注意查收！",[_curGivedMoney intValue]];
//                
//                [OwnerTool showAlertWithTitle:@"充值提醒" message:showString];
//            }
//            else{
//                [_appstoreHud hide:NO];
//                NSString *alertInfo = [dictionary objectForKey:@"codeInfo"];
//                [OwnerTool showAlertWithTitle:@"购买凭证验证失败" message:alertInfo];
//            }
//            
//        } errorHandler:^(NSError *error) {
//            [_appstoreHud hide:NO];
//            [UIAlertView showWithError:error];
//        }];
//        
//        //[self verifyPruchase];
//        NSArray *tt = [productIdentifier componentsSeparatedByString:@"."];
//        NSString *bookid = [tt lastObject];
//        if ([bookid length] > 0) {
//            [self recordTransaction:bookid];
//            [self provideContent:bookid];
//        }
//        
//    }
//    // Remove the transaction from the payment queue.
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//    
//}


//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
        [Tool showAlertWithTitle:@"温馨提示" message:@"您购买失败，请重新尝试购买"];
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


//#pragma mark 验证购买凭据
//- (void)verifyPruchase{
//      // 验证凭据，获取到苹果返回的交易凭据
//    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
//        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
//        // 从沙盒中获取到购买凭据
//        NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
//
//         // 发送网络POST请求，对购买凭据进行验证
//         NSURL *url = [NSURL URLWithString:ITMS_SANDBOX_VERIFY_RECEIPT_URL];
//         // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
//         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
//
//        request.HTTPMethod = @"POST";
//
//        // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
//        // 传输的是BASE64编码的字符串
//        /**
//                BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
//                BASE64是可以编码和解码的
//            */
//    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//
//    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
//    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = payloadData;
//    // 提交验证请求，并获得官方的验证JSON结果
//    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    // 官方验证结果为空
//    if (result == nil) {
//        NSLog(@"验证失败");
//    }
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@", dict);
//    if (dict != nil) {
//        // 比对字典中以下信息基本上可以保证数据安全
//        // bundle_id&application_version&product_id&transaction_id
//            NSLog(@"验证成功");
//         [OwnerTool showAlertWithTitle:@"恭喜" message:@"您购买成功啦，录音币已存入你的账号，请注意查收"];
//    }
//}

//展示充值成功
- (void)showSuccess{
    MBProgressHUD *hub;
    hub = [Tool showMBProgressHUDWithTitle:@"正在验证交易凭证" inView:self.view];
    _orderId = [Tool isBlankString:_orderId]?@"":_orderId;
    
//    [ApplicationDelegate.myEngine isPaySuccessWithOrderId:_orderId userId:[Singleton sharedSingleton].userID completionHandler:^(NSDictionary *dictionary) {
//        [hub hide:NO];
//        int code = [[dictionary objectForKey:@"code"]intValue];
//        
//        if(code == 0){
//            NSString *numberStr = [[dictionary objectForKey:@"data"]objectForKey:@"recordCoin"];
//            
//            if([Tool isBlankString:numberStr])
//                iconLb.text = @"N";
//            else
//                iconLb.text = [NSString stringWithFormat:@"%@",numberStr];
//            
//            [Singleton sharedSingleton].VoiceBNumber =  iconLb.text;
//            
//            NSString *showString = [NSString stringWithFormat:@"充值成功，%d个录音币已经到账，请注意查收！",[_curGivedMoney intValue]];
//            
//            //    NSRange rangeStr0 = [showString rangeOfString:@"，"];
//            //    NSRange rangeStr1 = [showString rangeOfString:@"个"];
//            //    NSRange rangeFinish0 = NSMakeRange(rangeStr0.location, rangeStr1.location - rangeStr0.location + 1);
//            //    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:showString];
//            //    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangeFinish0];
//            //    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:NumberFont size:13.5] range:rangeFinish0];
//            
//            [OwnerTool showAlertWithTitle:@"充值提醒" message:showString];
//        }
//        else{
//            NSString *str = [dictionary objectForKey:@"codeInfo"];
//            [OwnerTool showAlertWithTitle:@"充值结果" message:str];
//            //[OwnerTool showMBProgressHUDWithImageStr:@"" withTitle:@"充值成功，更新数据异常" inView:self.view];
//        }
//    } errorHandler:^(NSError *error) {
//        [hub hide:NO];
//        [UIAlertView showWithError:error];
//        
//    }];
//    
}

//- (void)willEnterForeground:(NSNotification *)notification{
////    NSLog(@"将要进入后台%s",__func__);
////    if(isPaying){
////        //删除手势密码
////        MainViewController *mainVC = (MainViewController *)ApplicationDelegate.window.rootViewController;
////        //[mainVC.mainLockVC dismiss:0];
////        if(mainVC.mainLockVC){
////            [mainVC.mainLockVC.view removeFromSuperview];
////            [mainVC.mainLockVC removeFromParentViewController];
////            mainVC.mainLockVC = nil;
////        }
////    }
//}


- (void)dealloc{
    NSLog(@"%s,line=%d",__func__,__LINE__);
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wxPaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}


#pragma mark UI
- (void)creatUIWithPayCenter
{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = BACKGROINDCOLOR;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    //headView
    HeadView *headView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 133*SCREEN_WIDTH_RATE)];
    headView.backgroundColor = BACKGROINDCOLOR;
    headView.lbYuE.text = @"金豆余额";
    headView.lbTotal.text = @"总账户";
    headView.lbCanExchange.text = @"可兑换";
    headView.lbTotalCount.text = _totalCount;
    headView.lbCanExCount.text = _exchangeCount;
    _table.tableHeaderView = headView;
    
    
}

//创建底部支付UI
- (void)creatBottomUI
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 50*SCREEN_WIDTH_RATE)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    _lbTotalText = [[UILabel alloc]initWithFrame:CGRectMake(10, 16*SCREEN_WIDTH_RATE, 37*SCREEN_WIDTH_RATE, 16*SCREEN_WIDTH_RATE)];
    _lbTotalText.text = @"合计:";
    _lbTotalText.textColor = UIColorFromRGB(0x353535);
    _lbTotalText.font = [UIFont fontWithName:PFREGULARFONT size:16*SCREEN_WIDTH_RATE];
    [bottomView addSubview:_lbTotalText];
    
    _lbPrice = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_lbTotalText), 0, 0, 0)];
    _lbPrice.textColor = UIColorFromRGB(0xfe624b);
    _lbPrice.font = [UIFont fontWithName:PFMEDIUMFONT size:17];
    [bottomView addSubview:_lbPrice];
    
    _lbRemark = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_lbPrice), 0, 0, 0)];
    _lbRemark.textColor = UIColorFromRGB(0xfe624b);
    _lbRemark.font = [UIFont fontWithName:PFREGULARFONT size:15];
    [bottomView addSubview:_lbRemark];
    
    UIButton *toPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-108*SCREEN_WIDTH_RATE, 0, 108*SCREEN_WIDTH_RATE, 50*SCREEN_WIDTH_RATE)];
    [toPayBtn setBackgroundColor:NAVBARMAINCOLOR];
    [toPayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [toPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toPayBtn addTarget:self action:@selector(clickBtnWithPay) forControlEvents:UIControlEventTouchUpInside];
    toPayBtn.titleLabel.font = [UIFont fontWithName:PFMEDIUMFONT size:18*SCREEN_WIDTH_RATE];
    [bottomView addSubview:toPayBtn];
}

//前往充值明细界面
- (void)toDetailWithPay
{
    PayeDetailController *vc = [[PayeDetailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
