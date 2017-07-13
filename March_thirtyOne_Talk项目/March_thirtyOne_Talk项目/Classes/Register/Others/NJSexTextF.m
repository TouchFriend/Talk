//
//  NJSexTextF.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJSexTextF.h"
@interface NJSexTextF () <UIPickerViewDataSource,UIPickerViewDelegate>
/********* 性别选择器 *********/
@property(nonatomic,strong)UIPickerView * pickerView;
/********* 数据 *********/
@property(nonatomic,strong)NSArray * sexArr;

@end
@implementation NJSexTextF

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}
#pragma mark - 懒加载
- (NSArray *)sexArr
{
    if(!_sexArr)
    {
        NSString * pathStr = [[NSBundle mainBundle] pathForResource:@"sex.plist" ofType:nil];
        _sexArr = [NSArray arrayWithContentsOfFile:pathStr];
    }
    return _sexArr;
}
- (void)setUp
{
    UIPickerView * pickerView = [[UIPickerView alloc]init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    //修改textField的输入源
    self.inputView = pickerView;
    self.pickerView = pickerView;
}
#pragma  mark - UIPickerViewDataSource方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.sexArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.sexArr[row];
}
#pragma  mark - UIPickerViewDelegate方法
//哪一行被选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.text = self.sexArr[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
#pragma mark -
//开始编辑是初始化
- (void)initWithBeginEdit
{
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
}
@end
