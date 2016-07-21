//
//  MainViewController.m
//  ConditionalProbability
//
//  Created by Lc on 16/7/20.
//  Copyright © 2016年 Lc. All rights reserved.
//

#import "MainViewController.h"
#import "NumberViewCell.h"
#import "DataManager.h"
#import "DBWin.h"

@interface MainViewController ()<TextInputFinistDelegate>

@property (strong, nonatomic) NSMutableDictionary *numberDic;
@property (strong, nonatomic) NSMutableArray *beforeArray;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.hidesBarsOnSwipe = YES;
    [self recommendedNumberToday];
}

- (NSMutableDictionary *)numberDic
{
    if (_numberDic == nil)
    {
        _numberDic = [NSMutableDictionary dictionaryWithDictionary:@{@"redNumber1":@"",
                                                                     @"redNumber2":@"",
                                                                     @"redNumber3":@"",
                                                                     @"redNumber4":@"",
                                                                     @"redNumber5":@"",
                                                                     @"redNumber6":@"",
                                                                     @"blueNumber":@""}];
    }
    
    return _numberDic;
}

- (NSMutableArray *)beforeArray
{
    _beforeArray = [NSMutableArray arrayWithArray:[[DataManager defaultInstance] arrayFromCoreData:@"DBWin" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil]];
    return _beforeArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
        return 1;
    return self.beforeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NumberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"numberCell"];
    cell.delegate = self;
    // Configure the cell...
    if (indexPath.section == 0 && indexPath.row == 0)
        cell.currentCellType = NUMBER_TODAY;
    else if (indexPath.section == 1 && indexPath.row == 0)
        cell.currentCellType = NUMBER_INPUT;
    else
    {
        cell.currentWin = self.beforeArray[indexPath.row];
        cell.currentCellType = NUMBER_BEFORE;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width/7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
        return 44;
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell"];
        return cell.contentView;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == 0)
        title = @"今日推荐";
    else if (section == 1)
        title = @"输入号码";
    else
        title = @"往期号码";
    return title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
    
        DBWin *deleteWin = self.beforeArray[indexPath.row];
        [[DataManager defaultInstance] deleteFromCoreData:deleteWin];
        [[DataManager defaultInstance] saveContext];
        [_beforeArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)currentTextInputFinishWithTextFiled:(UITextField *)textField
{
    NSString *dicKey = textField.tag == 6 ? @"blueNumber":[NSString stringWithFormat:@"redNumber%ld",textField.tag +1];
    self.numberDic[dicKey] = textField.text;
}

- (IBAction)submitButtonAction:(id)sender
{
    NSArray *valueArray = [self.numberDic allValues];
    if ([self currentFreeInArray:valueArray] == NO)
    {
        DBWin *newWin = (DBWin *)[[DataManager defaultInstance] insertIntoCoreData:@"DBWin"];
        newWin.redNumber1 = self.numberDic[@"redNumber1"];
        newWin.redNumber2 = self.numberDic[@"redNumber2"];
        newWin.redNumber3 = self.numberDic[@"redNumber3"];
        newWin.redNumber4 = self.numberDic[@"redNumber4"];
        newWin.redNumber5 = self.numberDic[@"redNumber5"];
        newWin.redNumber6 = self.numberDic[@"redNumber6"];
        newWin.blueNumber = self.numberDic[@"blueNumber"];
        [[DataManager defaultInstance] saveContext];
        [self.tableView reloadData];
        [self.numberDic removeAllObjects];
    }
    
}

- (BOOL)currentFreeInArray:(NSArray *)currentArray
{
    BOOL haveFree = YES;
    for (NSString *value in currentArray)
    {
        if (value != nil && ![value isEqualToString:@""])
            haveFree = NO;
    }

    return haveFree;
}

- (NSMutableDictionary *)recommendedNumberToday
{
    NSArray *allNumberArray = [[DataManager defaultInstance] arrayFromCoreData:@"DBWin" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil];
    NSMutableArray *redarray = [NSMutableArray array];
    NSMutableArray *bluearray = [NSMutableArray array];
    
    for (DBWin *wins in allNumberArray)
    {
        [redarray addObject:wins.redNumber1];
        [redarray addObject:wins.redNumber2];
        [redarray addObject:wins.redNumber3];
        [redarray addObject:wins.redNumber4];
        [redarray addObject:wins.redNumber5];
        [redarray addObject:wins.redNumber6];
        [bluearray addObject:wins.blueNumber];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSLog(@"___________%@",redarray);
    for (int i = 0; i < redarray.count; i ++)
    {
        NSString *string1 = redarray[i];
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:string1];
        for (int j = i + 1; j < redarray.count; j++)
        {
            NSString *string2 = redarray[j];
            
            if ([string1 isEqualToString:string2])
            {
                [tempArray addObject:string2];
                [redarray removeObject:string2];
                j = j -1;
                i = i -1;
            }
        }
        if (tempArray.count == 1)
        {
            [redarray removeObject:string1];
            i = i -1;
        }
        [dic setValue:tempArray forKey:tempArray[0]];
    }
    
    NSArray *allKey = [dic allValues];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
//    NSArray *tempArray = [allKey sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
//    win.redNumber1 = tempArray[0];
//    win.redNumber2 = tempArray[1];
//    win.redNumber3 = tempArray[2];
//    win.redNumber4 = tempArray[3];
//    win.redNumber5 = tempArray[4];
//    win.redNumber6 = tempArray[5];

    
    return nil;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
