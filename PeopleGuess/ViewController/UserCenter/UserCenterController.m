//
//  UserCenterController.m
//  PeopleGuess
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UserCenterController.h"
#import "UserCenterCell.h"
#import "PayCenterController.h"
#import "CreatAndTakeController.h"
#import "SelfSetController.h"
#import "MyWaterListController.h"
@interface UserCenterController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIButton *btnHeadIcon;
@property (nonatomic ,strong) UILabel *lbUserName;
@property (nonatomic ,strong) UIImageView *LvImg;
@property (nonatomic ,strong) UILabel *Lvlb;
@property (nonatomic ,strong) UILabel *lbMyHaveNum;
@property (nonatomic ,strong) UILabel *lbMyWaterNum;
@property (nonatomic ,strong) UILabel *lbMyCreatNum;
@property (nonatomic ,strong) UITableView *table;
@property (nonatomic ,strong) NSMutableArray *iconArr;
@property (nonatomic ,strong) NSMutableArray *textArr;
@end

@implementation UserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    _iconArr = [NSMutableArray arrayWithObjects:@"recharge_mine",@"exchanfe_mine",@"helpcenter_mine",@"set_mine" ,nil];
    _textArr = [NSMutableArray arrayWithObjects:@"充值中心",@"兑换中心",@"帮助中心",@"设置" ,nil];
    [self creatUIWithUserCenter];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestDataWithUserCenter];
    });
    
}
#pragma mark RequestData
- (void)requestDataWithUserCenter
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,USERINFO]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {

            WS(weakSelf);
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if ([Tool isBlankString:[Singleton sharedSingleton].logo]) {
                    [_btnHeadIcon setImage:[UIImage imageNamed:@"image_mine"] forState:UIControlStateNormal];
                }
            else{
                    [_btnHeadIcon sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_mine"]];
                }
            weakSelf.lbUserName.text = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"nickName"]];
            weakSelf.lbMyWaterNum.text =[NSString stringWithFormat:@"%@",[response.data objectForKey:@"buyNum"]];
            weakSelf.lbMyHaveNum.text = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"takePartNum"]];
            weakSelf.lbMyCreatNum.text = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"createNum"]];
            weakSelf.Lvlb.text = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"level"]];
            }];
        }
        else
        {
           
        }
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCenterCell * cell = [UserCenterCell cellWithTableView:tableView];
    cell.icon.image = [UIImage imageNamed:[_iconArr objectAtIndex:indexPath.row]];
    cell.lbText.text = [_textArr objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*SCREEN_WIDTH_RATE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        PayCenterController *vc = [[PayCenterController alloc]init];
        TMNavigationController *nav = (TMNavigationController *)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:NO];
        return;
    }
    if (indexPath.row==3) {
        SelfSetController *vc = [[SelfSetController alloc]init];
        TMNavigationController *nav = (TMNavigationController *)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:NO];
        return;
    }
}

#pragma mark UI
- (void)creatUIWithUserCenter
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300*SCREEN_WIDTH_RATE, 368/2*SCREEN_WIDTH_RATE)];
    topView.backgroundColor = UIColorFromRGB(0xe7e5e7);
    [self.view addSubview:topView];
    
    _btnHeadIcon = [[UIButton alloc]initWithFrame:CGRectMake(28*SCREEN_WIDTH_RATE, 38*SCREEN_WIDTH_RATE, 50*SCREEN_WIDTH_RATE, 50*SCREEN_WIDTH_RATE)];
    _btnHeadIcon.layer.cornerRadius = 50*SCREEN_WIDTH_RATE/2;
    _btnHeadIcon.layer.borderWidth = 2;
    _btnHeadIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnHeadIcon.layer.masksToBounds = YES;
    if ([Tool isBlankString:[Singleton sharedSingleton].logo]) {
        [_btnHeadIcon setImage:[UIImage imageNamed:@"image_mine"] forState:UIControlStateNormal];
    }
    else{
        [_btnHeadIcon sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_mine"]];
    }
    [topView addSubview:_btnHeadIcon];
    
    _lbUserName =[[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_btnHeadIcon)+11, 56*SCREEN_WIDTH_RATE, 110*SCREEN_WIDTH_RATE, 17*SCREEN_WIDTH_RATE)];
    _lbUserName.text = [Singleton sharedSingleton].nickName;
    _lbUserName.textColor = [UIColor blackColor];
    _lbUserName.font = [UIFont fontWithName:PFREGULARFONT size:17*SCREEN_WIDTH_RATE];
    [topView addSubview:_lbUserName];
    
    _LvImg = [[UIImageView alloc]initWithFrame:CGRectMake(VIEWX(_lbUserName)+10, 55*SCREEN_WIDTH_RATE, 17*SCREEN_WIDTH_RATE, 17*SCREEN_WIDTH_RATE)];
    _LvImg.image = [UIImage imageNamed:@""];
    [topView addSubview:_LvImg];
    
    _Lvlb = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_LvImg)+5, 57*SCREEN_WIDTH_RATE, 35*SCREEN_WIDTH_RATE, 15*SCREEN_WIDTH_RATE)];
    _Lvlb.text = @"VIP1";
    _Lvlb.textColor = UIColorFromRGB(0x010101);
    _Lvlb.font = [UIFont fontWithName:PFREGULARFONT size:15*SCREEN_WIDTH_RATE];
    [topView addSubview:_Lvlb];
    
    UIImageView *LvToicon = [[UIImageView alloc]initWithFrame:CGRectMake(VIEWX(_Lvlb)+5, _Lvlb.frame.origin.y+1*SCREEN_WIDTH_RATE, 8*SCREEN_WIDTH_RATE, 12*SCREEN_WIDTH_RATE)];
    LvToicon.image = [UIImage imageNamed:@"foward_mine"];
    [topView addSubview:LvToicon];
    
    _lbMyHaveNum = [[UILabel alloc]initWithFrame:CGRectMake(8*SCREEN_WIDTH_RATE, VIEWY(_btnHeadIcon)+20*SCREEN_WIDTH_RATE, 95*SCREEN_WIDTH_RATE, 43*SCREEN_WIDTH_RATE)];
    _lbMyHaveNum.textColor = UIColorFromRGB(0xfd6049);
    _lbMyHaveNum.text = @"0";
    _lbMyHaveNum.font = [UIFont fontWithName:PFMEDIUMFONT size:17*SCREEN_WIDTH_RATE];
    _lbMyHaveNum.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_lbMyHaveNum];
    
    _lbMyWaterNum = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_lbMyHaveNum), VIEWY(_btnHeadIcon)+20*SCREEN_WIDTH_RATE, 95*SCREEN_WIDTH_RATE, 43*SCREEN_WIDTH_RATE)];
    _lbMyWaterNum.textColor = UIColorFromRGB(0xfd6049);
    _lbMyWaterNum.text = @"0";
    _lbMyWaterNum.font = [UIFont fontWithName:PFMEDIUMFONT size:17*SCREEN_WIDTH_RATE];
    _lbMyWaterNum.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_lbMyWaterNum];
    
    _lbMyCreatNum = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_lbMyWaterNum), VIEWY(_btnHeadIcon)+20*SCREEN_WIDTH_RATE, 95*SCREEN_WIDTH_RATE, 43*SCREEN_WIDTH_RATE)];
    _lbMyCreatNum.textColor = UIColorFromRGB(0xfd6049);
    _lbMyCreatNum.text = @"0";
    _lbMyCreatNum.font = [UIFont fontWithName:PFMEDIUMFONT size:17*SCREEN_WIDTH_RATE];
    _lbMyCreatNum.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_lbMyCreatNum];
    
    UILabel *lbMyHave = [[UILabel alloc]initWithFrame:CGRectMake(8*SCREEN_WIDTH_RATE, VIEWY(_lbMyHaveNum), 95*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE)];
    lbMyHave.text = @"我参与的";
    lbMyHave.textColor = [UIColor blackColor];
    lbMyHave.textAlignment = NSTextAlignmentCenter;
    lbMyHave.font = [UIFont fontWithName:PFREGULARFONT size:14*SCREEN_WIDTH_RATE];
    [topView addSubview:lbMyHave];
    
    UILabel *lbMyCreat = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(lbMyHave), VIEWY(_lbMyHaveNum), 95*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE)];
    lbMyCreat.text = @"我发布的";
    lbMyCreat.textColor = [UIColor blackColor];
    lbMyCreat.textAlignment = NSTextAlignmentCenter;
    lbMyCreat.font = [UIFont fontWithName:PFREGULARFONT size:14*SCREEN_WIDTH_RATE];
    [topView addSubview:lbMyCreat];
    
    UILabel *lbMyWater = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(lbMyCreat), VIEWY(_lbMyHaveNum), 95*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE)];
    lbMyWater.text = @"我的流水";
    lbMyWater.textColor = [UIColor blackColor];
    lbMyWater.textAlignment = NSTextAlignmentCenter;
    lbMyWater.font = [UIFont fontWithName:PFREGULARFONT size:14*SCREEN_WIDTH_RATE];
    [topView addSubview:lbMyWater];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, VIEWY(_btnHeadIcon)+20*SCREEN_WIDTH_RATE, 100*SCREEN_WIDTH_RATE, 73*SCREEN_WIDTH_RATE)];
    [btn1 addTarget:self action:@selector(toCreatAndTakeVC) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(VIEWX(btn1), VIEWY(_btnHeadIcon)+20*SCREEN_WIDTH_RATE, 100*SCREEN_WIDTH_RATE, 73*SCREEN_WIDTH_RATE)];
    [btn2 addTarget:self action:@selector(toCreatAndTakeVC) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(VIEWX(btn2), VIEWY(_btnHeadIcon)+20*SCREEN_WIDTH_RATE, 100*SCREEN_WIDTH_RATE, 73*SCREEN_WIDTH_RATE)];
    [btn3 addTarget:self action:@selector(toMyWaterListVC) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn3];

    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, VIEWY(topView)+39*SCREEN_WIDTH_RATE, 300*SCREEN_WIDTH_RATE, SCREEN_HEIGHT-topView.frame.size.height)];
    _table.dataSource = self;
    _table.delegate   = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.scrollEnabled = NO;
    [self.view addSubview:_table];
}

- (void)toCreatAndTakeVC
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    CreatAndTakeController *vc = [[CreatAndTakeController alloc]init];
    TMNavigationController *nav = (TMNavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:vc animated:NO];
}

- (void)toMyWaterListVC
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    MyWaterListController *vc = [[MyWaterListController alloc]init];
    TMNavigationController *nav = (TMNavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:vc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
