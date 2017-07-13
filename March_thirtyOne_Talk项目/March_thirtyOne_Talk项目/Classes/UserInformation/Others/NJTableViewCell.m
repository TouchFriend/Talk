//
//  NJTableViewCell.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/6.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTableViewCell.h"
#import "NJInfo.h"
@interface NJTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation NJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setInfo:(NJInfo *)info
{
    self.nameLabel.text = info.name;
    self.contentLabel.text = info.content;
}
@end
