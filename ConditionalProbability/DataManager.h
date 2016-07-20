//
//  DataManager.h
//  ConditionalProbability
//
//  Created by Lc on 16/7/20.
//  Copyright © 2016年 Lc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject
/**
 * @abstract 单例模式
 */
+ (instancetype)defaultInstance;

#pragma mark -  NSManagedObjectContext Methods

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  @abstract 存储数据库文件的目录路径
 *      在iOS沙盒环境中，用户文档需要通过iCloud同步的放在Document目录下，而此类文件主要是缓存目的，应当放在Cache目录下
 */
- (NSURL *)applicationDatabaseDirectory;

/**
 *  @abstract 明显调用数据存储到数据库文件中
 *      该操作一般会自动进行，当你发现自动存储有可能存在延迟的不及时状况时，请显式调用此方法
 */
- (void)saveContext;

/**
 *  @abstract 从数据库中取得数据
 *  @param  将要访问的实体名称，对应数据库的表格名称
 *  @param  查询条件，用于过滤数据
 *  @param  限定返回结果的数量（基于查询条件，以及起始偏移量和排序方法）
 *  @param  排序状况下返回结果的起始点
 *  @param  排序方法
 */
- (NSArray *)arrayFromCoreData:(NSString *)entityName
                     predicate:(NSPredicate *)predicate
                         limit:(NSUInteger)limit
                        offset:(NSUInteger)offset
                       orderBy:(NSArray *)sortDescriptors;

/**
 *  @abstract 向数据库中插入一行数据
 *  @param  将要访问的实体名称，对应数据库的表格名称
 *  @return 返回的实体对象引用，更新该对象内容即可
 */
- (NSManagedObject *)insertIntoCoreData:(NSString *)entityName;

/**
 *  @abstract 删除指定的记录
 *  @param obj 要删除的对象
 */
- (void)deleteFromCoreData:(NSManagedObject *) obj;

/**
 *  @abstract 将指定的数据表格清空
 *  @param entityName 要删除的数据表格名
 */
- (void)cleanCoreDatabyEntityName:(NSString*)entityName;


@end
