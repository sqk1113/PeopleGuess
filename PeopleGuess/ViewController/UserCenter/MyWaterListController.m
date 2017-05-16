//
//  MyWaterListController.m
//  PeopleGuess
//
//  Created by mac on 17/2/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MyWaterListController.h"
#import "HeadView.h"
#import "MyWaterModel.h"
#import "MyConsumCell.h"
#import "NSString+DateCommon.h"
static int size = 10;
@interface MyWaterListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *arrList;
@property (nonatomic,strong)NSString *todayCount;
@property (nonatomic,strong)NSString *totalCount;
@property (nonatomic,assign)int page;//当前页数
@end

@implementation MyWaterListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的流水";
    _arrList = [NSMutableArray array];
    self.navigationBarBackgroundColor = NAVBARMAINCOLOR;
    [self refreshData];
}
#pragma mark requestData

- (void)refreshData
{
    [Tool removeErrorView:self.view];
    [Tool addLoadinView:self.view center:CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2)];
    _page = 1;
    [_arrList removeAllObjects];
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
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,MYWATERLIST]  params:dic success:^(id json) {
        NSLog(@"%@",json);
        [Tool removeLoadingView:self.view];
        [_table.mj_footer endRefreshing];
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            _todayCount  = [NSString stringWithFormat:@"%@", [response.data objectForKey:@"todayNum"]];
            _totalCount = [NSString stringWithFormat:@"%@", [response.data objectForKey:@"totalNum"]];
            NSMutableArray *arr = [response.data objectForKey:@"takePartList"];
            for (NSDictionary *dic in arr) {
                    MyWaterModel *m = [[MyWaterModel alloc]initWithJSONDictionary:dic];
                    [self.arrList addObject:m];
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
    static NSString *cellID = @"MyConsumCell";
    MyConsumCell *cell = (MyConsumCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        cell = [[MyConsumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MyWaterModel *model = [_arrList objectAtIndex:indexPath.row];
    cell.dateLabel.text = [model.createTime getMonthAndDay];
    cell.timeLabel.text = [model.createTime getHoursAndMin];
    cell.withHoldLabel.text =[NSString stringWithFormat:@"%@",model.num];
    cell.reasonLabel.text= [NSString stringWithFormat:@"%@：%@",model.name,model.choice];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 70.0f;
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
    headView.lbYuE.text = @"流水统计";
    headView.lbTotal.text = @"今日";
    headView.lbCanExchange.text = @"累计";
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
}



@end
