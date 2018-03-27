//
//  ViewController.m
//  WS_MVVM_RAC
//
//  Created by ws on 16/11/8.
//  Copyright © 2016年 王松. All rights reserved.
//

#import "ViewController.h"
#import "MVVMTableViewCell.h"
#import "MVVMViewModel.h"
#import "MVVMModel.h"
#import <MJRefresh/MJRefresh.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)MVVMViewModel *viewModel;
@property (nonatomic) UITableView *tableView;

@end

@implementation ViewController
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MVVM_RAC";
    //分支1111
    __weak typeof(self)weakSelf = self;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MVVMTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.viewModel = [[MVVMViewModel alloc]init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[self.viewModel.refreshDataCommand execute:nil] subscribeNext:^(id x) {
            [weakSelf.tableView.mj_header endRefreshing];
             [weakSelf.tableView.mj_footer resetNoMoreData];
            if (self.dataSource.count > 0) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource  addObjectsFromArray:x];
            [self.tableView reloadData];
        }];
    }];
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [[self.viewModel.nextPageCommand execute:nil] subscribeNext:^(id x) {
            
            [weakSelf.tableView.mj_footer endRefreshing];
            [self.dataSource  addObjectsFromArray:x];
            
            [self.tableView reloadData];
        }];
        
    }];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MVVMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
        MVVMModel *model = self.dataSource[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
