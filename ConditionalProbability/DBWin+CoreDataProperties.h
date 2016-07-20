//
//  DBWin+CoreDataProperties.h
//  ConditionalProbability
//
//  Created by Lc on 16/7/20.
//  Copyright © 2016年 Lc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBWin.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBWin (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *winData;
@property (nullable, nonatomic, retain) NSString *redNumber1;
@property (nullable, nonatomic, retain) NSString *redNumber2;
@property (nullable, nonatomic, retain) NSString *redNumber3;
@property (nullable, nonatomic, retain) NSString *redNumber4;
@property (nullable, nonatomic, retain) NSString *redNumber5;
@property (nullable, nonatomic, retain) NSString *blueNumber;

@end

NS_ASSUME_NONNULL_END
