//
//  AktSearchFmdb.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/9/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktSearchFmdb.h"
#import <FMDB.h>

@implementation AktSearchFmdb

-(instancetype)init
{
    [self CreatTable];
    return  self;
}
- (void)CreatTable
{
    FMDatabase *db = [self Fmdbdatabase];
    NSString *FmdbCreatFirstTable=@"CREATE TABLE IF NOT EXISTS SEARCHKEY(key TEXT)";
    BOOL res= [db executeStatements:FmdbCreatFirstTable];
    if (!res) {
        NSLog(@"error when creating db firsttable");
    }
    else
    {
        NSLog(@"success to creating db firsttable");
    }
    [db close];
}

- (FMDatabase *)Fmdbdatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    [db open];
    if (![db open])
    {
        NSLog(@"Could not open db");
        
    }
    return db;
    
}

#pragma mark -
-(void)saveSearchText:(NSString *)searchKey{
    NSMutableArray *arylist = [self findSearchALL];
    for (int i=0;i<arylist.count;i++) {
        if ([searchKey isEqualToString:[NSString stringWithFormat:@"%@",[arylist objectAtIndex:i]]]) {
            [self updateObject:[arylist objectAtIndex:i]];
            return;
        }
    }
    FMDatabase *db=[self Fmdbdatabase];
    NSString *savedata=[NSString stringWithFormat:@"insert into SEARCHKEY(key)VALUES(?)"];

    BOOL res=[db executeUpdate:savedata,searchKey];
    if (!res) {
        NSLog(@"save File");
        NSLog(@"%@",[db lastErrorMessage]);
    }
    else
    {
        //NSLog(@"save success");
    }
    [db close];
}
-(void)deleteSearchKey{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql=[NSString stringWithFormat:@"delete from SEARCHKEY"];
    BOOL res=[db executeUpdate:sql];
    if (!res) {
        NSLog(@"delete Fail");
    }
    else
    {
        //NSLog(@"delete success");
    }
    [db close];
}
-(void)updateObject:(NSString *)searchKey{
    FMDatabase *db=[self Fmdbdatabase];
    NSString * sql =[NSString stringWithFormat:@"update SEARCHKEY set key=? where key = '%@'",searchKey];
    BOOL res=[db executeUpdate:sql,searchKey];
    if(!res)
    {
        NSLog(@"%@",searchKey);
        NSLog(@"update fail");
    }
    else
    {
        //NSLog(@"update success");
    }
    [db close];
}
-(int)size
{
    FMDatabase *db = [self Fmdbdatabase];
    NSString *sql = [NSString stringWithFormat:@"select count(*) from SEARCHKEY"];
    FMResultSet *rs = [db executeQuery:sql,nil];
    int count =0;
    while ([rs next])
    {
        count = [rs intForColumnIndex:0];
    }
    return count;
}
-(NSMutableArray *)findSearchALL{
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql = [NSString stringWithFormat:@"select *from SEARCHKEY"];
    FMResultSet *rs=[db executeQuery:sql,nil];
    while ([rs next]) {
        [searchArray addObject:[rs stringForColumn:@"key"]];
    }
    [rs close];
    [db close];
    
    return  searchArray;
}
@end
