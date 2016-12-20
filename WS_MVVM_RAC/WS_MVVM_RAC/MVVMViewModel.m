//
//  MVVMViewModel.m
//  WS_MVVM_RAC
//
//  Created by ws on 16/11/8.
//  Copyright © 2016年 王松. All rights reserved.
//

#import "MVVMViewModel.h"
#import "MVVMModel.h"
#import "MVVMTableViewCell.h"

@interface MVVMViewModel()
@property (nonatomic)NSInteger currentPage;
@end
@implementation MVVMViewModel
-(instancetype)init{
    if ([super init]){
    }
    return self;
}
- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
       
        self.currentPage = 1;
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
          
            RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                NSString *url = nil;
                url = [NSString  stringWithFormat:@"http://mobile.ximalaya.com/m/explore_user_list?category_name=all&condition=hot&device=android&page=%ld&per_page=20", _currentPage];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //发送信号
                    [subscriber sendNext:responseObject];
                    // 发送信号完成 并取消订阅1
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@", error);
                }];
                return nil;
            }];
            //订阅信号
            return  [requestSignal map:^(id x) {
                NSArray *arr = [x objectForKey:@"list"];
                //字典转模型 遍历字典中的所有元素,全部映射成模型,并且生成数组
                NSArray * modelArr = [[arr.rac_sequence map:^id(id value) {
                    MVVMModel *model = [[MVVMModel alloc]init];
                    [model setValuesForKeysWithDictionary:value];
                    return model;
                }] array];
                NSLog(@"个数  ： %ld",modelArr.count);
                return modelArr;
            }];
            
        }];
    }
    return _refreshDataCommand;
}
- (RACCommand *)nextPageCommand {
    if (!_nextPageCommand) {
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                _currentPage ++;
                NSString *url = nil;
                url = [NSString  stringWithFormat:@"http://mobile.ximalaya.com/m/explore_user_list?category_name=all&condition=hot&device=android&page=%ld&per_page=20", _currentPage];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //发送信号
                    [subscriber sendNext:responseObject];
                    // 发送信号完成 并取消订阅1
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@", error);
                }];
                return nil;
            }];
            //订阅信号
            return  [requestSignal map:^(id x) {
                NSArray *arr = [x objectForKey:@"list"];
                //字典转模型 遍历字典中的所有元素,全部映射成模型,并且生成数组
                NSArray * modelArr = [[arr.rac_sequence map:^id(id value) {
                    MVVMModel *model = [[MVVMModel alloc]init];
                    [model setValuesForKeysWithDictionary:value];
                    return model;
                }] array];
                NSLog(@"个数  ： %ld",modelArr.count);
                return modelArr;
            }];
        }];
    }
    return _nextPageCommand;
}
@end
