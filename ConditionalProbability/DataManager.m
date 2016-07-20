//
//  DataManager.m
//  ConditionalProbability
//
//  Created by Lc on 16/7/20.
//  Copyright © 2016年 Lc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

static NSString *const CoreDataModelFileName = @"database";

@implementation DataManager

// 单例模式下的默认实例的创建
+ (instancetype)defaultInstance
{
    static DataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDatabaseDirectory
{
    // 应用用于存储Core Data数据文件的目录。这段代码使用一个名为“com.bcu.mgmanager”的目录，它位于该应用沙盒的Library目录中。
    // 注意，由于该数据文件要保持和服务器一致，故属于缓存性质，缓存的数据放进library；如果是用户个人数据，则应放在Document目录中。
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // 该应用的受管理的数据模型。当应用加载该模型失败时，会生成一个致命错误。
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"database" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // 该应用的持久化存储实现的处理单元。该方法将创建并返回该处理单元，此刻该应用就具备存储能力了。
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    // 创建存储和处理单元
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDatabaseDirectory] URLByAppendingPathComponent:@"database.sqlite"];
    NSError *error = nil;
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error])
    {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // 如果有特殊的错误处理机制，请重写下面的代码.
#warning abort() 会导致软件崩溃退出的同时生成错误日志. 如果你要发布该应用，应当避免使用该方法，它只是在开发阶段会很有用.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    // 返回应用的受管理数据模型的context，即一个已经绑定并存储到应用中的持久化存储数据组）
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
    {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // 如果有特殊的错误处理机制，请重写下面的代码.
#warning abort() 会导致软件崩溃退出的同时生成错误日志. 如果你要发布该应用，应当避免使用该方法，它只是在开发阶段会很有用.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        else
        {
            NSLog(@"数据存储成功");
        }
        
    }
}

#pragma mark - Core Data using implementation

/**
 *  @abstract 从数据库中取得数据
 *
 */
- (NSArray *)arrayFromCoreData:(NSString *)entityName
                     predicate:(NSPredicate *)predicate
                         limit:(NSUInteger)limit
                        offset:(NSUInteger)offset
                       orderBy:(NSArray *)sortDescriptors
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    if (sortDescriptors != nil && sortDescriptors.count > 0)
        [request setSortDescriptors:sortDescriptors];
    if (predicate)
        [request setPredicate:predicate];
    
    [request setFetchLimit:limit];
    [request setFetchOffset:offset];
    
    NSError *error = nil;
    NSArray *fetchObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"fetch request error=%@", error);
        return nil;
    }
    
    return fetchObjects;
}

/**
 *  @abstract 向数据库中插入一条新建数据
 *
 */
- (NSManagedObject *)insertIntoCoreData:(NSString *)entityName
{
    NSManagedObject *obj  = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                          inManagedObjectContext:self.managedObjectContext];
    return obj;
}

/**
 *  @abstract 从数据库中删除一条数据
 */
- (void) deleteFromCoreData:(NSManagedObject *) obj
{
    [self.managedObjectContext deleteObject:obj];
}

- (void) cleanCoreDatabyEntityName:(NSString*)entityName
{
    NSArray *DBarray = [self arrayFromCoreData:entityName predicate:nil limit:NSIntegerMax offset:0 orderBy:nil];
    if (DBarray.count >0)
    {
        for (NSManagedObject *obj in DBarray)
        {
            [self deleteFromCoreData:obj];
        }
    }
}
@end
