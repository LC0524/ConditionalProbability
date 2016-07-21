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
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width/7;
    for (int i = 0; i < 7; i ++)
    {
        if (type == NUMBER_INPUT)
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(i * labelWidth+5, 5, labelWidth - 5*2, labelWidth - 5*2)];
            textField.clipsToBounds = YES;
            textField.tag = i;
            textField.layer.cornerRadius = (labelWidth - 5*2)/2;
            if (i == 6)
                textField.backgroundColor = [UIColor blueColor];
            else
                textField.backgroundColor = [UIColor redColor];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.delegate = self;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.contentView addSubview:textField];
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth+5, 5, labelWidth - 5*2, labelWidth - 5*2)];
            label.clipsToBounds = YES;
            label.layer.cornerRadius = (labelWidth - 5*2)/2;
            label.textAlignment = NSTextAlignmentCenter;
            
            if (i == 6)
            {
                label.backgroundColor = [UIColor blueColor];
                label.text = self.currentWin.blueNumber;
            }
            else
            {
                switch (i)
                {
                    case 0:
                    label.text = self.currentWin.redNumber1;
                        break;
                    case 1:
                    label.text = self.currentWin.redNumber2;
                        break;
                    case 2:
                    label.text = self.currentWin.redNumber3;
                        break;
                    case 3:
                    label.text = self.currentWin.redNumber4;
                        break;
                    case 4:
                    label.text = self.currentWin.redNumber5;
                        break;
                    case 5:
                    label.text = self.currentWin.redNumber6;
                        break;
                    default:
                        break;
                }
                label.backgroundColor = [UIColor redColor];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:18];
            }
        
            [self.contentView addSubview:label];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length == 2)
    {
        [textField resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(currentTextInputFinishWithTextFiled:)])
        {
            [self.delegate currentTextInputFinishWithTextFiled:textField];
        }
        
        UITextField *currentTextField = [self.contentView viewWithTag:textField.tag+1];
        if (currentTextField.text != nil || ![currentTextField.text isEqualToString:@""])
            currentTextField.text = @"";
        [currentTextField becomeFirstResponder];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
