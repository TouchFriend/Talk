//
//  NJSetterTableViewCell.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/18.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJSetterTableViewCell.h"
#import "NJOption.h"
@interface NJSetterTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *optionImageView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@end
@implementation NJSetterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setOption:(NJOption *)option
{
    _option = option;
    self.optionImageView.image = [UIImage imageNamed:option.imageName];
    self.optionLabel.text = option.optionName;
}

@end
