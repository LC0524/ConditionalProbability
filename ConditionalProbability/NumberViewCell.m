//
//  NumberViewCell.m
//  ConditionalProbability
//
//  Created by Lc on 16/7/20.
//  Copyright © 2016年 Lc. All rights reserved.
//

#import "NumberViewCell.h"

@interface NumberViewCell()<UITextFieldDelegate>

@end

@implementation NumberViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCurrentCellType:(CellType)currentCellType
{
    if (_currentCellType != currentCellType)
    {
        _currentCellType = currentCellType;
        
        [self creatCurrentCellByCurrentCellType:_currentCellType];
    }
}

- (void)creatCurrentCellByCurrentCellType:(CellType)type
{
    switch (type)
    {
        case NUMBER_TODAY:
            [self creatNumberLabelWithType:NUMBER_TODAY];
            break;
        case NUMBER_INPUT:
            [self creatNumberLabelWithType:NUMBER_INPUT];
            break;
        case NUMBER_BEFORE:
            [self creatNumberLabelWithType:NUMBER_BEFORE];
            break;
        default:
            break;
    }
}
- (void)creatNumberLabelWithType:(CellType)type
{
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width/6;
    for (int i = 0; i < 6; i ++)
    {
        if (type == NUMBER_INPUT)
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(i * labelWidth+5, 5, labelWidth - 5*2, labelWidth - 5*2)];
            textField.clipsToBounds = YES;
            textField.layer.cornerRadius = (labelWidth - 5*2)/2;
            if (i == 5)
                textField.backgroundColor = [UIColor blueColor];
            else
                textField.backgroundColor = [UIColor redColor];
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.delegate = self;
            [self.contentView addSubview:textField];
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth+5, 5, labelWidth - 5*2, labelWidth - 5*2)];
            label.clipsToBounds = YES;
            label.layer.cornerRadius = (labelWidth - 5*2)/2;
            if (i == 5)
                label.backgroundColor = [UIColor blueColor];
            else
                label.backgroundColor = [UIColor redColor];
        
            [self.contentView addSubview:label];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
