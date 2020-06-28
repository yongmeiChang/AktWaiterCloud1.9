//
//  UserFmdb.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/25.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "UserFmdb.h"
#import <FMDB.h>
@implementation UserFmdb

-(instancetype)init
{
    [self CreatTable];
    return  self;
}
- (void)CreatTable
{
    FMDatabase *db = [self Fmdbdatabase];
    NSString *FmdbCreatFirstTable=@"CREATE TABLE IF NOT EXISTS USERINFO(uuid TEXT PRIMARY KEY,icon TEXT, mobile TEXT,password TEXT,tenantsId TEXT,location TEXT,cooperationState TEXT,cooperationStateName TEXT,sex TEXT,sexName TEXT,stationNo TEXT,saleId TEXT,synopsis TEXT,waiterName TEXT,waiterNo TEXT,locationX TEXT,locationY TEXT,missionTrans TEXT,maxOrders TEXT,level TEXT,startPermission TEXT,waiterUkey TEXT,locationFlag TEXT,isPosition TEXT,tenantsName TEXT,isclickOff_line TEXT)";
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
#pragma mark - user info
-(void)saveUserInfo:(UserInfo *)userinfo;
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *savedata=[NSString stringWithFormat:@"insert into USERINFO(uuid,icon, mobile,password,tenantsId,location,cooperationState,cooperationStateName,sex,sexName,stationNo,saleId,synopsis,waiterName,waiterNo,locationX,locationY,missionTrans,maxOrders,level,startPermission,waiterUkey,locationFlag,isPosition,tenantsName)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
    BOOL res=[db executeUpdate:savedata,userinfo.uuid,userinfo.icon,userinfo.mobile,userinfo.password,userinfo.tenantsId,userinfo.location,userinfo.cooperationState,userinfo.cooperationStateName,userinfo.sex,userinfo.sexName,userinfo.stationNo,userinfo.saleId,userinfo.synopsis,userinfo.waiterName,userinfo.waiterNo,userinfo.locationX,userinfo.locationY,userinfo.missionTrans,userinfo.maxOrders,userinfo.level,userinfo.startPermission,userinfo.waiterUkey,userinfo.locationFlag,userinfo.isPosition,userinfo.tenantsName];
    if (!res) {
        NSLog(@"save File");
        NSLog(@"%@",[db lastErrorMessage]);
    }
    else
    {
        NSLog(@"save success");
    }
    [db close];
}

-(void)deleteAllUserInfo{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql=[NSString stringWithFormat:@"delete  from USERINFO"];
    BOOL res=[db executeUpdate:sql];
    if (!res) {
        NSLog(@"delete Fail");
    }
    else
    {
        NSLog(@"delete success");
    }
    [db close];
}

-(void)deleteUserInfoById:(NSString *)userid;
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql=[NSString stringWithFormat:@"delete  from USERINFO where id =%@",userid];
    BOOL res=[db executeUpdate:sql];
    if (!res) {
        NSLog(@"delete Fail");
    }
    else
    {
        NSLog(@"delete success");
    }
    [db close];
}
/*
-(UserInfo *)findByrow:(NSInteger)row
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql = [NSString stringWithFormat:@"select *from USERINFO  limit %ld,1",row];
    UserInfo *object;
    FMResultSet *rs=[db executeQuery:sql,row,nil];
    while ([rs next]) {
        object = [[UserInfo alloc]init];
        [object getUserInfoById:[rs stringForColumn:@"uuid"] Byicon:[rs stringForColumn:@"icon"] Bymobile:[rs stringForColumn:@"mobile"] Bypassword:[rs stringForColumn:@"password"] BytenantsId:[rs stringForColumn:@"tenantsId"] Bylocation:[rs stringForColumn:@"location"] BycooperationState:[rs stringForColumn:@"cooperationState"] BycooperationStateName:[rs stringForColumn:@"cooperationStateName"] Bysex:[rs stringForColumn:@"sex"] BysexName:[rs stringForColumn:@"sexName"] BystationNo:[rs stringForColumn:@"stationNo"] BysaleId:[rs stringForColumn:@"saleId"] Bysynopsis:[rs stringForColumn:@"synopsis"] BywaiterName:[rs stringForColumn:@"waiterName"] BywaiterNo:[rs stringForColumn:@"waiterNo"] BylocationX:[rs stringForColumn:@"locationX"] BylocationY:[rs stringForColumn:@"locationY"] BymissionTrans:[rs stringForColumn:@"missionTrans"] BymaxOrders:[rs stringForColumn:@"maxOrders"] Bylevel:[rs stringForColumn:@"level"] BystartPermission:[rs stringForColumn:@"startPermission"] BywaiterUkey:[rs stringForColumn:@"waiterUkey"] BylocationFlag:[rs stringForColumn:@"locationFlag"] ByisPosition:[rs stringForColumn:@"isPosition"] BytenantsName:@"tenantsName" ];
    }
    [rs close];
    [db close];
    return  object;
}*/
-(void)updateObject:(UserInfo *)userinfo
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString * sql =@"update USERINFO set uuid=?,icon=?, mobile=?,password=? ,tenantsId=? ,location=? ,cooperationState=?,cooperationStateName=?,sex=?,sexName=?,stationNo=?,saleId=?,synopsis=?,waiterName=?,waiterNo=?,locationX=?,locationY=?,missionTrans=?,maxOrders=?,level=?,startPermission=?,waiterUkey=?,locationFlag=?,isPosition=?,tenantsName=?";
    BOOL res=[db executeUpdate:sql,userinfo.uuid,userinfo.icon,userinfo.mobile,userinfo.password,userinfo.tenantsId,userinfo.location,userinfo.cooperationState,userinfo.cooperationStateName,userinfo.sex,userinfo.sexName,userinfo.stationNo,userinfo.saleId,userinfo.synopsis,userinfo.waiterName,userinfo.waiterNo,userinfo.locationX,userinfo.locationY,userinfo.missionTrans,userinfo.maxOrders,userinfo.level,userinfo.startPermission,userinfo.waiterUkey,userinfo.locationFlag,userinfo.isPosition,userinfo.tenantsName];
    if(!res)
    {
        NSLog(@"update fail");
    }
    else
    {
        NSLog(@"update success");
    }
    [db close];
    
}

-(int)size
{
    FMDatabase *db = [self Fmdbdatabase];
    NSString *sql = [NSString stringWithFormat:@"select count(*) from USERINFO"];
    FMResultSet *rs = [db executeQuery:sql,nil];
    int count =0;
    while ([rs next])
    {
        count = [rs intForColumnIndex:0];
    }
    return count;
}
@end
