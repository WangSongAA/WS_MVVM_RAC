//
//  MVVMTableViewCell.m
//  WS_MVVM_RAC
//
//  Created by ws on 16/11/8.
//  Copyright © 2016年 王松. All rights reserved.
//

#import "MVVMTableViewCell.h"

#define LogoHeight 50
@interface MVVMTableViewCell()
@end
@implementation MVVMTableViewCell

-(UIImageView *)logo{
    if (!_logo) {
        self.logo = [[UIImageView alloc]initWithFrame:CGRectMake(LeftSpce, LeftSpce, LogoHeight, LogoHeight)];
        [_logo setBackgroundColor:[UIColor whiteColor]];
    }
    return _logo;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftSpce + LeftSpce + LogoHeight, LeftSpce, Swidth - 3 *LeftSpce - LogoHeight, LogoHeight )];
        [_nameLabel setBackgroundColor:[UIColor whiteColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize: 14]];
    }
    return _nameLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.logo];
        [self.contentView addSubview:self.nameLabel];
        @weakify(self)
        [RACObserve(self, model) subscribeNext:^(id x) {
            @strongify(self)
            self.nameLabel.text = self.model.nickname;
            [_logo sd_setImageWithURL:[NSURL URLWithString:self.model.smallLogo]];
        } completed:^{
            
        }];
    }
    return self;
}
@end
