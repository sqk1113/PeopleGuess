//
//  PayeDetailController.m
//  PeopleGuess
//
//  Created by mac on 17/2/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayeDetailController.h"
#import "MyConsumCell.h"
#import "MyConsumModel.h"
#import "NSString+DateCommon.h"
@interface PayeDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) int size;
@end

@implementation PayeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换明细";
    
    self.navigationBarBackgroundColor = NAVBARMAINCOLOR;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [self refresh];
}
-(NSMutableArray *)dataArr
{
    if (_dataArr ==nil) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (void)requestDataWithPage:(int)page withSize:(int)size
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@(size) forKey:@"ps"];
    [dic setValue:@(page) forKey:@"pn"];
    [dic setValue:API_VERSON forKey:@"v"];
    [dic setValue:@(TIMESTAMP) forKey:@"t"];
    NSString * signature = [DESEncryptFile getMd5ForDic:dic];
    [dic setValue:signature forKey:@"s"];
    [ZZHttpTool getWithURL:[NSString stringWithFormat:@"%@%@",SERVER_HOST,EXCHANGELIST] params:dic success:^(id json) {
        NSLog(@"%@",json);
        [Tool removeLoadingView:self.view];
        ResponseObject *response = [[ResponseObject alloc]initWithJSONDictionary:json];
        if (response.code==1000)
        {
            for (NSDictionary *dic in [response.data objectForKey:@"exchangeList"]) {
                MyConsumModel *m = [[MyConsumModel alloc]initWithJSONDictionary:dic];
                [self.dataArr addObject:m];
            }
            if (_page == 1)
            {
                if(self.dataArr.count >0){
                    _tableView.backgroundColor = BACKGROINDCOLOR;
                    [Tool removeNullView:self.view];
                }
                else{
                    _tableView.backgroundColor = [UIColor clearColor];
                    [Tool addNullView:self.view center:CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT)/2) imageName:@"nullDownloadRecord" title:@"您还没有兑换记录"];
                }
            }
            [_tableView reloadData];
        }
        else
        {
            if(_page > 1){
                _page--;
                [Tool showAlertWithTitle:@"请求失败" message:[json objectForKey:@"codeInfo"]];
            }
            else{
                [Tool addErrorView:self.view center:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) title:[NSString stringWithFormat:@"%@，请重新加载",[json objectForKey:@"codeInfo"]] target:self selector:@selector(refresh)];
                
            }
        }

       
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        _tableView.backgroundColor = [UIColor clearColor];
        [Tool removeLoadingView:self.view];
        [Tool addErrorView:self.view center:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) title:@"网络异常，请重新加载" target:self selector:@selector(refresh)];
    }];
}
-(void)refresh
{
    _page = 1;
    _size = 10;
    if (_page==1)
    {
        [self requestDataWithPage:_page withSize:_size];
        [Tool removeErrorView:self.view];
        [Tool addLoadinView:self.view center:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    }
    
}
#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"MyConsumCell";
    MyConsumCell *cell = (MyConsumCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        cell = [[MyConsumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MyConsumModel *model = [_dataArr objectAtIndex:indexPath.row];
    cell.dateLabel.text = [model.createTime getMonthAndDay];
    cell.timeLabel.text = [model.createTime getHoursAndMin];
    cell.withHoldLabel.text =[NSString stringWithFormat:@"%@",model.num];
    cell.reasonLabel.text= model.reason;
    return cell;
}

#pragma mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffSet = scrollView.contentOffset.y;
    CGFloat distance = scrollView.contentSize.height - contentYoffSet;
    NSLog(@"height = %f  content= %f  distance = %f",height,contentYoffSet,distance);
    if(distance==height)
    {
        NSLog(@"1111");
        if (_dataArr.count==_page*_size) {
            _page++;
            [self requestDataWithPage:_page withSize:_size];
        }
        else
        {
            _tableView.bounces= YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
