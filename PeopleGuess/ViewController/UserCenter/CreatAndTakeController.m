//
//  CreatAndTakeController.m
//  PeopleGuess
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CreatAndTakeController.h"
#import "HeadView.h"
#import "ZFActionSheet.h"
#import "TakePartModel.h"
#import "TakePartCell.h"
#import "MyCreatModel.h"
static int size = 10;
@interface CreatAndTakeController ()<UITableViewDelegate,UITableViewDataSource,ZFActionSheetDelegate>
@property (nonatomic,strong)NSString *todayCount;
@property (nonatomic,strong)NSString *totalCount;
@property (nonatomic,strong)UIButton *navleftBtn;
@property (nonatomic,strong)UIButton *navrightBtn;
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *arrList;
@property (nonatomic,assign)int type;//0我参与的  1我发布的
@property (nonatomic,assign)int page;//当前页数
//@property (nonatomic,assign)int size;//页数大小
@end

@implementation CreatAndTakeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarBackgroundColor = NAVBARMAINCOLOR;
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:17];
    [rightBtn setTitle:@"新建" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget: self action:@selector(toCreatNewExam) forControlEvents:UIControlEventTouchUpInside];
    [TMNavigationController addOtherView:rightBtn withFrame:CGRectMake(SCREEN_WIDTH-55, 24, 55, 40)];
    
    UIView *navMidView = [[UIView alloc]init];
    navMidView.layer.cornerRadius = 4;
    navMidView.layer.borderWidth = 1;
    navMidView.layer.borderColor = [[UIColor whiteColor]CGColor];
    navMidView.layer.masksToBounds = YES;
    
    _navleftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 93, 30)];
    _navleftBtn.backgroundColor = [UIColor whiteColor];
    [_navleftBtn setTitle:@"我参与的" forState:UIControlStateNormal];
    [_navleftBtn setTitleColor:NAVBARMAINCOLOR forState:UIControlStateNormal];
    _navleftBtn.titleLabel.font = [UIFont fontWithName:PFMEDIUMFONT size:14];
    [_navleftBtn addTarget:self action:@selector(changeNavMidStateAndRefreshData:) forControlEvents:UIControlEventTouchUpInside];
    [navMidView addSubview:_navleftBtn];
    
    _navrightBtn = [[UIButton alloc]initWithFrame:CGRectMake(93, 0, 93, 30)];
    _navrightBtn.backgroundColor = NAVBARMAINCOLOR;
    [_navrightBtn setTitle:@"我发布的" forState:UIControlStateNormal];
    [_navrightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _navrightBtn.titleLabel.font = [UIFont fontWithName:PFMEDIUMFONT size:14];
    [_navrightBtn addTarget:self action:@selector(changeNavMidStateAndRefreshData:) forControlEvents:UIControlEventTouchUpInside];
    [navMidView addSubview:_navrightBtn];
    
    [TMNavigationController addOtherView:navMidView withFrame:CGRectMake((SCREEN_WIDTH-186)/2, 27, 186, 30)];
    [self refreshData];
}

-(NSMutableArray *)arrList
{
    if (_arrList==nil) {
        _arrList = [NSMutableArray new];
    }
    return _arrList;
}

#pragma mark 导航栏顶部UI创建
-(void)toCreatNewExam
{
    ZFActionSheet *actionSheet = [ZFActionSheet actionSheetWithTitle:nil confirms:@[@"拍摄",@"从手机相册选择"] cancel:@"取消" style:ZFActionSheetStyleCancel];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view.window];
}

-(void)changeNavMidStateAndRefreshData:(UIButton *)sender
{
    if (sender ==_navleftBtn) {
        _navleftBtn.backgroundColor = [UIColor whiteColor];
        [_navleftBtn setTitleColor:NAVBARMAINCOLOR forState:UIControlStateNormal];
        _navrightBtn.backgroundColor = NAVBARMAINCOLOR;
        [_navrightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _type = 0;
        [self refreshData];
        return;
    }
    if (sender==_navrightBtn) {
        _navleftBtn.backgroundColor = NAVBARMAINCOLOR;
        [_navleftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _navrightBtn.backgroundColor = [UIColor whiteColor];
        [_navrightBtn setTitleColor:NAVBARMAINCOLOR forState:UIControlStateNormal];
        _type = 1;
        [self refreshData];
        return;
    }
}

#pragma mark - ZFActionSheetDelegate
- (void)clickAction:(ZFActionSheet *)actionSheet atIndex:(NSUInteger)index
{
    NSLog(@"选中了 %zd",index);
}

#pragma mark requestData

- (void)refreshData
{
    [Tool removeErrorView:self.view];
    [Tool addLoadinView:self.view center:CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2)];
    _page = 1;
    [_arrList removeAllObjects];
    [_table removeFromSuperview];
    _table = nil;
    [self requestDataWithMyTakePartWithPage:_page];
}


- (void)requestDataWithMyTakePartWithPage:(int)page
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@(size) forKey:@"ps"];
    [dic setValue:@(page) forKey:@"pn"];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    NSString *url = [NSString string];
    _type==0?(url =TAKEPARYTOPIC):(url = MYCREATELIST);
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,url]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        [Tool removeLoadingView:self.view];
        [_table.mj_footer endRefreshing];
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            if (_type==0) {
                _todayCount  = [NSString stringWithFormat:@"%@/%@", [response.data objectForKey:@"dayWinNum"],[response.data objectForKey:@"dayTotalNum"]];
                _totalCount = [NSString stringWithFormat:@"%@/%@", [response.data objectForKey:@"winNum"], [response.data objectForKey:@"totalNum"]];
                NSMutableArray *arr = [response.data objectForKey:@"historyTopic"];
                for (NSDictionary *dic in arr) {
                    TakePartModel *m = [[TakePartModel alloc]initWithJSONDictionary:dic];
                    [self.arrList addObject:m];
                }
            }
            else
            {
                _todayCount  = [NSString stringWithFormat:@"%@", [response.data objectForKey:@"dayCreate"]];
                _totalCount = [NSString stringWithFormat:@"%@", [response.data objectForKey:@"totalCreate"]];
                NSMutableArray *arr = [response.data objectForKey:@"createList"];
                for (NSDictionary *dic in arr) {
                    MyCreatModel *m = [[MyCreatModel alloc]initWithJSONDictionary:dic];
                    [self.arrList addObject:m];
                }
            }
            
            if (!_table) {
                [self creatUIWithVc];
            }
            if (self.arrList.count<_page * size) {
                _table.mj_footer.hidden = YES;
            }
            [_table reloadData];
        }
        else
        {
            if (!_table) {
                [Tool addErrorView:self.view center:self.view.center title:response.msg target:self selector:@selector(refreshData)];
            }
            else{
                [[Toast shareToast]makeText:@"连接超时" time:1];
            }
        }
        
    } failure:^(NSError *error) {
        [_table.mj_footer endRefreshing];
        [Tool removeLoadingView:self.view];
        if (!_table) {
            [Tool addErrorView:self.view center:self.view.center title:@"连接超时" target:self selector:@selector(refreshData)];
        }
        else{
            [[Toast shareToast]makeText:@"连接超时" time:1];
        }
    }];
    
}



#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakePartCell * cell = [TakePartCell cellWithTableView:tableView];
    if (_type==0) {
        cell.model = [self.arrList objectAtIndex:indexPath.row];
    }
    else
    {
        cell.myModel = [self.arrList objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.5*SCREEN_WIDTH_RATE;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(13*SCREEN_WIDTH_RATE, 18*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 14*SCREEN_WIDTH_RATE)];
    view.backgroundColor = BACKGROINDCOLOR;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13*SCREEN_WIDTH_RATE, 18*SCREEN_WIDTH_RATE, SCREEN_WIDTH, 14*SCREEN_WIDTH_RATE)];
    label.textColor = UIColorFromRGB(0x888888);
    label.font = [UIFont fontWithName:PFREGULARFONT size:14*SCREEN_WIDTH_RATE];
    [view addSubview:label];
    label.text = @"参与过的";
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42*SCREEN_WIDTH_RATE;
}
#pragma mark UI
-(void)creatUIWithVc
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
    if (_type==0) {
        headView.lbYuE.text = @"参与统计";
        headView.lbTotal.text = @"今日";
        headView.lbCanExchange.text = @"战绩";

    }
    else
    {
        headView.lbYuE.text = @"发布统计";
        headView.lbTotal.text = @"今日";
        headView.lbCanExchange.text = @"累计";

    }
    headView.lbTotalCount.text = _todayCount;
    headView.lbCanExCount.text = _totalCount;
    _table.tableHeaderView = headView;
    /***********MJRefresh-上拉刷新************/
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self requestDataWithMyTakePartWithPage:_page];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
