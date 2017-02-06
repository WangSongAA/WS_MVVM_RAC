//
//  MVVMViewModel.h
//  WS_MVVM_RAC
//
//  Created by ws on 16/11/8.
//  Copyright © 2016年 王松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVVMViewModel : NSObject
@property (nonatomic, strong) RACCommand *refreshDataCommand;//刷新
@property (nonatomic, strong) RACCommand *nextPageCommand;//加载
@end
