//
//  LGHSqliteManager.m
//  Litter_item
//
//  Created by 刘观华 on 2021/3/25.
//

#import "LGHSqliteManager.h"

@interface LGHSqliteManager ()

@property(nonatomic,strong) FMDatabaseQueue *queue;

@end


static FMDatabase *db;

@implementation LGHSqliteManager
static LGHSqliteManager * sharedInstance = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareManager {
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

// 懒加载数据库队列
- (FMDatabaseQueue *)queue {
    if (_queue == nil) {
        
        // document path
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
           //表的文件路劲
           NSString *filePath = [path stringByAppendingString:@"/student.sqlite"];
           NSLog(@"student.sqlite filePath is %@",filePath);
        _queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    }
    return _queue;
}

// 创建表
- (void)createTableWithSQL:(NSString *)sql {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sql withArgumentsInArray:nil];
        if (result) {
            NSLog(@"创建表格成功");
        } else {
            NSLog(@"创建表格失败");
        }
    }];
}

// 查询所有数据
- (void)queryAll {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from T_human";
        
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
        
        while (resultSet.next) {
            NSString *name = [resultSet stringForColumn:@"name"];
            int age = [resultSet intForColumn:@"age"];
            double height = [resultSet doubleForColumn:@"height"];
            
            NSLog(@"%@, %i, %lf", name, age, height);
        }
    }];
}

// 删除表格
- (void)dropTableWithSQL:(NSString *)sql {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sql withArgumentsInArray:nil];
        if (result) {
            NSLog(@"删除表格成功");
        } else {
            NSLog(@"删除表格失败");
        }
    }];
}

// 插入数据 / 删除数据 / 更新数据
 - (void)updateDataWithSQL:(NSString *)sql {
     
     [self.queue inDatabase:^(FMDatabase *db) {
         BOOL result = [db executeUpdate:sql withArgumentsInArray:nil];
         if (result) {
             NSLog(@"插入数据成功");
         } else {
             NSLog(@"插入数据失败");
         }
     }];
 }
 
-(void)excuteStamentsWithSql1:(NSString *)sql01 Sql2:(NSString *)sql02{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
             
        BOOL result1 = [db executeUpdate:sql01 withArgumentsInArray:nil];
        BOOL result2 = [db executeUpdate:sql02 withArgumentsInArray:nil];
             
        if (result1 && result2) {
            NSLog(@"执行成功");
        } else {
            [db rollback];
        }
    }];
}




@end
