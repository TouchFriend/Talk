//
//  NJBirthdayVC.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/5.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJBirthdayVC.h"
#import <Foundation/Foundation.h>
#import "NJBirthdayVCDelegate.h"
@interface NJBirthdayVC ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
- (IBAction)backBtnItemClick:(id)sender;
/********* 日期 *********/
@property(nonatomic,strong)NSString * dateStr;
/********* 年龄 *********/
@property(nonatomic,strong)NSString * ageStr;
/********* 格式化日期 *********/
@property(nonatomic,strong)NSDateFormatter * formatter;



@end

@implementation NJBirthdayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置选择器的模式
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    //设置中文
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //监听选择器值得变化
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    //设置日期选择器的默认值
    if(!self.birthdayDate)
    {
        NSDate * defaultDate = [self.formatter dateFromString:@"1994-06-15"];
        self.datePicker.date = defaultDate;
    }
    else
    {
        self.datePicker.date = [self.formatter dateFromString:self.birthdayDate];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //显示导航栏
    self.navigationController.navigationBar.hidden = YES;
    //初始化
    [self dateChange:self.datePicker];
}
//懒加载
- (NSDateFormatter *)formatter
{
    if(_formatter == nil)
    {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        _formatter = formatter;
    }
    return _formatter;

}
- (void)dateChange:(UIDatePicker *)pickerView
{
    //格式化日期
    NSInteger age = [[NSDate date] timeIntervalSinceDate:self.datePicker.date] / (365 * 24 * 60 * 60);
    self.ageLabel.text = [NSString stringWithFormat:@"%li岁",age];
    self.dateStr = [self.formatter stringFromDate:self.datePicker.date];
    self.ageStr = self.ageLabel.text;
}
- (IBAction)backBtnItemClick:(id)sender
{
    //通知代理
    if([self.delegate respondsToSelector:@selector(birthdayVC:dateStr:age:)])
    {
        [self.delegate birthdayVC:self dateStr:self.dateStr age:self.ageStr];
    }
    //控制器跳转
    [self.navigationController popViewControllerAnimated:YES];
}
@end
