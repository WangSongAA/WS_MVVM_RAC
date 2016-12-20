//
//  MVVMTableViewCell.h
//  WS_MVVM_RAC
//
//  Created by ws on 16/11/8.
//  Copyright © 2016年 王松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVVMModel.h"
@interface MVVMTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *logo;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)MVVMModel *model;
@end
