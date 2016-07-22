//
//  NumberViewCell.h
//  ConditionalProbability
//
//  Created by Lc on 16/7/20.
//  Copyright © 2016年 Lc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBWin.h"

@protocol TextInputFinistDelegate <NSObject>

- (void)currentTextInputFinishWithTextFiled:(UITextField *)textField;

@end

typedef NS_ENUM(NSInteger,CellType)
{
    NUMBER_TODAY    = 1,
    NUMBER_INPUT    = 2,
    NUMBER_BEFORE   = 3,
};

@interface NumberViewCell : UITableViewCell

@property (assign,nonatomic) CellType currentCellType;
@property (weak, nonatomic) id<TextInputFinistDelegate>delegate;
@property (strong,nonatomic) NSDictionary *dic;

@end
