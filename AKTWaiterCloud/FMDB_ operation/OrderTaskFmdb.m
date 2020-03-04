//
//  OrderTaskFmdb.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/30.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "OrderTaskFmdb.h"
#import <FMDB.h>

@implementation OrderTaskFmdb

-(instancetype)init
{
    [self CreatTable];
    return  self;
}
- (void)CreatTable
{
    FMDatabase *db = [self Fmdbdatabase];
    NSString *FmdbCreatFirstTable=@"CREATE TABLE IF NOT EXISTS ORDERTASK(tid TEXT PRIMARY KEY,total TEXT,istrue TEXT,createDate TEXT,begin TEXT,updateDate TEXT,delFlag TEXT,affixFlag TEXT,serviceAreaName TEXT,serviceAreaFullPath TEXT,workNo TEXT,workStatus TEXT,workStatusName TEXT,customerId TEXT,customerNo TEXT,machineNo TEXT,customerName TEXT,customerPhone TEXT,serviceAddress TEXT,serviceLocationX TEXT,serviceLocationY TEXT,serviceAreaId TEXT,serviceContent TEXT,serviceMoney TEXT,serviceDate TEXT,serviceBegin TEXT,serviceEnd TEXT,serviceLength TEXT,serviceItemId TEXT,serviceItemName TEXT,stationId TEXT,stationName TEXT,stationPhone TEXT,stationAddress TEXT,waiterId TEXT,waiterName TEXT,waiterPhone TEXT,waiterLocation TEXT,processInstanceId TEXT,processKey TEXT,processKeyName TEXT,orderUserId TEXT,orderUserName TEXT,orderDate TEXT,sendUserId TEXT,sendUserName TEXT,sendDate TEXT,stationUserId TEXT,stationUserName TEXT,stationDate TEXT,serviceTimeLength INTEGER,unitType TEXT,unitTypeName TEXT,abnormalFlag TEXT,abnormalFlagName TEXT,lessFlagName TEXT,lessFlag TEXT,businessType TEXT,field11 TEXT,field12 TEXT,field13 TEXT,createBy TEXT,updateBy TEXT,serviceFullPath TEXT,signInLocation TEXT,signInStatus TEXT,signOutLocation TEXT,signOutStatus TEXT,visitUserName TEXT,signInDistance TEXT,serviceResult TEXT,serviceVisit TEXT,customerSatisfactionName TEXT,visitDate TEXT,actualCharge TEXT,actrueBegin TEXT,isLate TEXT,isAbnormal TEXT,actrueEnd TEXT,isEarly TEXT)";

    BOOL res= [db executeStatements:FmdbCreatFirstTable];
    if (!res) {
        NSLog(@"error when creating db ordretask_table");
    }
    else
    {
        //NSLog(@"success to creating db ordretask_table");
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

-(void)saveOrderTask:(OrderInfo *)orderinfo
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *savedata=[NSString stringWithFormat:@"insert into ORDERTASK(tid,total,istrue,createDate,begin,updateDate,delFlag,affixFlag,serviceAreaName,serviceAreaFullPath,workNo,workStatus,workStatusName,customerId,customerNo,machineNo,customerName,customerPhone,serviceAddress,serviceLocationX,serviceLocationY,serviceAreaId,serviceContent,serviceMoney,serviceDate,serviceBegin,serviceEnd,serviceLength,serviceItemId,serviceItemName,stationId,stationName,stationPhone,stationAddress,waiterId,waiterName,waiterPhone,waiterLocation,processInstanceId,processKey,processKeyName,orderUserId,orderUserName,orderDate,sendUserId,sendUserName,sendDate,stationUserId,stationUserName,stationDate,serviceTimeLength,unitType,unitTypeName,abnormalFlag,abnormalFlagName,lessFlagName,lessFlag,businessType,field11,field12,field13,createBy,updateBy,serviceFullPath,signInLocation,signInStatus,signOutLocation,signOutStatus,visitUserName,signInDistance,serviceResult,serviceVisit,customerSatisfactionName,visitDate,actualCharge,actrueBegin,isLate,isAbnormal,actrueEnd,isEarly)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
//    NSString * sql = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",orderinfo.tid,orderinfo.total,orderinfo.isTrue,orderinfo.createDate,orderinfo.begin,orderinfo.updateDate,orderinfo.delFlag,orderinfo.affixFlag,orderinfo.serviceAreaName,orderinfo.serviceAreaFullPath,orderinfo.workNo,orderinfo.workStatus,orderinfo.workStatusName,orderinfo.customerId,orderinfo.customerNo,orderinfo.machineNo,orderinfo.customerName,orderinfo.customerPhone,orderinfo.serviceAddress,orderinfo.serviceLocationX,orderinfo.serviceLocationY,orderinfo.serviceAreaId,orderinfo.serviceContent,orderinfo.serviceMoney,orderinfo.serviceDate,orderinfo.serviceBegin,orderinfo.serviceEnd,orderinfo.serviceLength,orderinfo.serviceItemId,orderinfo.serviceItemName,orderinfo.stationId,orderinfo.stationName,orderinfo.stationPhone,orderinfo.stationAddress,orderinfo.waiterId,orderinfo.waiterName,orderinfo.waiterPhone,orderinfo.waiterLocation,orderinfo.processInstanceId,orderinfo.processKey,orderinfo.processKeyName,orderinfo.orderUserId,orderinfo.orderUserName,orderinfo.orderDate,orderinfo.sendUserId,orderinfo.sendUserName,orderinfo.sendDate,orderinfo.stationUserId,orderinfo.stationUserName,orderinfo.stationDate,orderinfo.serviceTimeLength,orderinfo.unitType,orderinfo.unitTypeName,orderinfo.abnormalFlag,orderinfo.abnormalFlagName,orderinfo.lessFlagName,orderinfo.lessFlag,orderinfo.businessType,orderinfo.field11,orderinfo.field12,orderinfo.field13,orderinfo.createBy,orderinfo.updateBy];
    BOOL res=[db executeUpdate:savedata,orderinfo.tid,orderinfo.total,orderinfo.isTrue,orderinfo.createDate,orderinfo.begin,orderinfo.updateDate,orderinfo.delFlag,orderinfo.affixFlag,orderinfo.serviceAreaName,orderinfo.serviceAreaFullPath,orderinfo.workNo,orderinfo.workStatus,orderinfo.workStatusName,orderinfo.customerId,orderinfo.customerNo,orderinfo.machineNo,orderinfo.customerName,orderinfo.customerPhone,orderinfo.serviceAddress,orderinfo.serviceLocationX,orderinfo.serviceLocationY,orderinfo.serviceAreaId,orderinfo.serviceContent,orderinfo.serviceMoney,orderinfo.serviceDate,orderinfo.serviceBegin,orderinfo.serviceEnd,orderinfo.serviceLength,orderinfo.serviceItemId,orderinfo.serviceItemName,orderinfo.stationId,orderinfo.stationName,orderinfo.stationPhone,orderinfo.stationAddress,orderinfo.waiterId,orderinfo.waiterName,orderinfo.waiterPhone,orderinfo.waiterLocation,orderinfo.processInstanceId,orderinfo.processKey,orderinfo.processKeyName,orderinfo.orderUserId,orderinfo.orderUserName,orderinfo.orderDate,orderinfo.sendUserId,orderinfo.sendUserName,orderinfo.sendDate,orderinfo.stationUserId,orderinfo.stationUserName,orderinfo.stationDate,orderinfo.serviceTimeLength,orderinfo.unitType,orderinfo.unitTypeName,orderinfo.abnormalFlag,orderinfo.abnormalFlagName,orderinfo.lessFlagName,orderinfo.lessFlag,orderinfo.businessType,orderinfo.field11,orderinfo.field12,orderinfo.field13,orderinfo.createBy,orderinfo.updateBy,orderinfo.serviceFullPath,orderinfo.signInLocation,orderinfo.signInStatus,orderinfo.signOutLocation,orderinfo.signOutStatus,orderinfo.visitUserName,orderinfo.signInDistance,orderinfo.serviceResult,orderinfo.serviceVisit,orderinfo.customerSatisfactionName,orderinfo.visitDate,orderinfo.actualCharge,orderinfo.actrueBegin,orderinfo.isLate,orderinfo.isAbnormal,orderinfo.actrueEnd,orderinfo.isEarly];
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

-(void)deleteAllOrderTask{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql=[NSString stringWithFormat:@"delete  from ORDERTASK"];
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

-(void)deleteOrderTaskByWorkNo:(NSString *)WorkNo
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql=[NSString stringWithFormat:@"delete  from ORDERTASK where workNo =%@",WorkNo];
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

-(NSMutableArray *)findAllOrderInfo{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql = [NSString stringWithFormat:@"select *from ORDERTASK"];
    OrderInfo *object;
    FMResultSet *rs=[db executeQuery:sql,nil];
    NSMutableArray * orderArray = [NSMutableArray array];
    while ([rs next]) {
        object = [[OrderInfo alloc]init];
        [object getOrderTaskByWorkNo:[rs stringForColumn:@"workNo"]  tid:[rs stringForColumn:@"tid"] total:[rs stringForColumn:@"total"] isTrue:[rs stringForColumn:@"isTrue"] createDate:[rs stringForColumn:@"createDate"] begin:[rs stringForColumn:@"begin"] updateDate:[rs stringForColumn:@"updateDate"] delFlag:[rs stringForColumn:@"delFlag"] affixFlag:[rs stringForColumn:@"affixFlag"] serviceAreaName:[rs stringForColumn:@"serviceAreaName"] serviceAreaFullPath:[rs stringForColumn:@"serviceAreaFullPath"] workStatus:[rs stringForColumn:@"workStatus"] workStatusName:[rs stringForColumn:@"workStatusName"] customerId:[rs stringForColumn:@"customerId"] customerNo:[rs stringForColumn:@"customerNo"] machineNo:[rs stringForColumn:@"machineNo"] customerName:[rs stringForColumn:@"customerName"] customerPhone:[rs stringForColumn:@"customerPhone"] serviceAddress:[rs stringForColumn:@"serviceAddress"] serviceLocationX:[rs stringForColumn:@"serviceLocationX"] serviceLocationY:[rs stringForColumn:@"serviceLocationY"] serviceAreaId:[rs stringForColumn:@"serviceAreaId"] serviceContent:[rs stringForColumn:@"serviceContent"] serviceMoney:[rs stringForColumn:@"serviceMoney"] serviceDate:[rs stringForColumn:@"serviceDate"] serviceBegin:[rs stringForColumn:@"serviceBegin"] serviceEnd:[rs stringForColumn:@"serviceEnd"] serviceLength:[rs stringForColumn:@"serviceLength"] serviceItemId:[rs stringForColumn:@"serviceItemId"] serviceItemName:[rs stringForColumn:@"serviceItemName"] stationId:[rs stringForColumn:@"stationId"] stationName:[rs stringForColumn:@"stationName"] stationPhone:[rs stringForColumn:@"stationPhone"] stationAddress:[rs stringForColumn:@"stationAddress"] waiterId:[rs stringForColumn:@"waiterId"] waiterName:[rs stringForColumn:@"waiterName"] waiterPhone:[rs stringForColumn:@"waiterPhone"] waiterLocation:[rs stringForColumn:@"waiterLocation"] processInstanceId:[rs stringForColumn:@"processInstanceId"] processKey:[rs stringForColumn:@"processKey"] processKeyName:[rs stringForColumn:@"processKeyName"] orderUserId:[rs stringForColumn:@"orderUserId"] orderUserName:[rs stringForColumn:@"orderUserName"] orderDate:[rs stringForColumn:@"orderDate"] sendUserId:[rs stringForColumn:@"sendUserId"] sendUserName:[rs stringForColumn:@"sendUserName"] sendDate:[rs stringForColumn:@"sendDate"] stationUserId:[rs stringForColumn:@"stationUserId"] stationUserName:[rs stringForColumn:@"stationUserName"] stationDate:[rs stringForColumn:@"stationDate"] serviceTimeLength:[rs stringForColumn:@"serviceTimeLength"] unitType:[rs stringForColumn:@"unitType"] unitTypeName:[rs stringForColumn:@"unitTypeName"] abnormalFlag:[rs stringForColumn:@"abnormalFlag"] abnormalFlagName:[rs stringForColumn:@"abnormalFlagName"] lessFlagName:[rs stringForColumn:@"lessFlagName"] lessFlag:[rs stringForColumn:@"lessFlag"] businessType:[rs stringForColumn:@"businessType"] field11:[rs stringForColumn:@"field11"] field12:[rs stringForColumn:@"field12"] field13:[rs stringForColumn:@"field13"] createBy:[rs stringForColumn:@"createBy"] updateBy:[rs stringForColumn:@"updateBy"]serviceFullPath:[rs stringForColumn:@"serviceFullPath"] signInLocation:[rs stringForColumn:@"signInLocation"] signInStatus:[rs stringForColumn:@"signInStatus"] signOutLocation:[rs stringForColumn:@"signOutLocation"]  signOutStatus:[rs stringForColumn:@"signOutStatus"] visitUserName:[rs stringForColumn:@"visitUserName"] signInDistance:[rs stringForColumn:@"signInDistance"] serviceResult:[rs stringForColumn:@"serviceResult"]  serviceVisit:[rs stringForColumn:@"serviceVisit"] CustomerSatisfactionName:[rs stringForColumn:@"CustomerSatisfactionName"] VisitDate:[rs stringForColumn:@"VisitDate"] actualCharge:[rs stringForColumn:@"actualCharge"] actrueBegin:[rs stringForColumn:@"actrueBegin"] isLate:[rs stringForColumn:@"isLate"] isAbnormal:[rs stringForColumn:@"isAbnormal"] actrueEnd:[rs stringForColumn:@"actrueEnd"] isEarly:[rs stringForColumn:@"isEarly"]];
        [orderArray addObject:object];
    }
    [rs close];
    [db close];
    return  orderArray;
}

-(OrderInfo *)findByrow:(NSInteger)row
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql = [NSString stringWithFormat:@"select *from ORDERTASK  limit %ld,1",row];
    OrderInfo *object;
    FMResultSet *rs=[db executeQuery:sql,row,nil];
    while ([rs next]) {
        object = [[OrderInfo alloc]init];
        [object getOrderTaskByWorkNo:[rs stringForColumn:@"workNo"]  tid:[rs stringForColumn:@"tid"] total:[rs stringForColumn:@"total"] isTrue:[rs stringForColumn:@"isTrue"] createDate:[rs stringForColumn:@"createDate"] begin:[rs stringForColumn:@"begin"] updateDate:[rs stringForColumn:@"updateDate"] delFlag:[rs stringForColumn:@"delFlag"] affixFlag:[rs stringForColumn:@"affixFlag"] serviceAreaName:[rs stringForColumn:@"serviceAreaName"] serviceAreaFullPath:[rs stringForColumn:@"serviceAreaFullPath"] workStatus:[rs stringForColumn:@"workStatus"] workStatusName:[rs stringForColumn:@"workStatusName"] customerId:[rs stringForColumn:@"customerId"] customerNo:[rs stringForColumn:@"customerNo"] machineNo:[rs stringForColumn:@"machineNo"] customerName:[rs stringForColumn:@"customerName"] customerPhone:[rs stringForColumn:@"customerPhone"] serviceAddress:[rs stringForColumn:@"serviceAddress"] serviceLocationX:[rs stringForColumn:@"serviceLocationX"] serviceLocationY:[rs stringForColumn:@"serviceLocationY"] serviceAreaId:[rs stringForColumn:@"serviceAreaId"] serviceContent:[rs stringForColumn:@"serviceContent"] serviceMoney:[rs stringForColumn:@"serviceMoney"] serviceDate:[rs stringForColumn:@"serviceDate"] serviceBegin:[rs stringForColumn:@"serviceBegin"] serviceEnd:[rs stringForColumn:@"serviceEnd"] serviceLength:[rs stringForColumn:@"serviceLength"] serviceItemId:[rs stringForColumn:@"serviceItemId"] serviceItemName:[rs stringForColumn:@"serviceItemName"] stationId:[rs stringForColumn:@"stationId"] stationName:[rs stringForColumn:@"stationName"] stationPhone:[rs stringForColumn:@"stationPhone"] stationAddress:[rs stringForColumn:@"stationAddress"] waiterId:[rs stringForColumn:@"waiterId"] waiterName:[rs stringForColumn:@"waiterName"] waiterPhone:[rs stringForColumn:@"waiterPhone"] waiterLocation:[rs stringForColumn:@"waiterLocation"] processInstanceId:[rs stringForColumn:@"processInstanceId"] processKey:[rs stringForColumn:@"processKey"] processKeyName:[rs stringForColumn:@"processKeyName"] orderUserId:[rs stringForColumn:@"orderUserId"] orderUserName:[rs stringForColumn:@"orderUserName"] orderDate:[rs stringForColumn:@"orderDate"] sendUserId:[rs stringForColumn:@"sendUserId"] sendUserName:[rs stringForColumn:@"sendUserName"] sendDate:[rs stringForColumn:@"sendDate"] stationUserId:[rs stringForColumn:@"stationUserId"] stationUserName:[rs stringForColumn:@"stationUserName"] stationDate:[rs stringForColumn:@"stationDate"] serviceTimeLength:[rs stringForColumn:@"serviceTimeLength"] unitType:[rs stringForColumn:@"unitType"] unitTypeName:[rs stringForColumn:@"unitTypeName"] abnormalFlag:[rs stringForColumn:@"abnormalFlag"] abnormalFlagName:[rs stringForColumn:@"abnormalFlagName"] lessFlagName:[rs stringForColumn:@"lessFlagName"] lessFlag:[rs stringForColumn:@"lessFlag"] businessType:[rs stringForColumn:@"businessType"] field11:[rs stringForColumn:@"field11"] field12:[rs stringForColumn:@"field12"] field13:[rs stringForColumn:@"field13"] createBy:[rs stringForColumn:@"createBy"] updateBy:[rs stringForColumn:@"updateBy"]serviceFullPath:[rs stringForColumn:@"serviceFullPath"] signInLocation:[rs stringForColumn:@"signInLocation"] signInStatus:[rs stringForColumn:@"signInStatus"] signOutLocation:[rs stringForColumn:@"signOutLocation"]  signOutStatus:[rs stringForColumn:@"signOutStatus"] visitUserName:[rs stringForColumn:@"visitUserName"] signInDistance:[rs stringForColumn:@"signInDistance"] serviceResult:[rs stringForColumn:@"serviceResult"]  serviceVisit:[rs stringForColumn:@"serviceVisit"] CustomerSatisfactionName:[rs stringForColumn:@"CustomerSatisfactionName"] VisitDate:[rs stringForColumn:@"VisitDate"] actualCharge:[rs stringForColumn:@"actualCharge"] actrueBegin:[rs stringForColumn:@"actrueBegin"] isLate:[rs stringForColumn:@"isLate"] isAbnormal:[rs stringForColumn:@"isAbnormal"] actrueEnd:[rs stringForColumn:@"actrueEnd"] isEarly:[rs stringForColumn:@"isEarly"]];
    }
    [rs close];
    [db close];
    return  object;
}



-(void)updateObject:(OrderInfo *)orderinfo
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString * sql =[NSString stringWithFormat:@"update ORDERTASK set tid=?,total=?,istrue=?,createDate=?,begin=?,updateDate=?,delFlag=?,affixFlag=?,serviceAreaName=?,serviceAreaFullPath=?,workNo=?,workStatus=?,workStatusName=?,customerId=?,customerNo=?,machineNo=?,customerName=?,customerPhone=?,serviceAddress=?,serviceLocationX=?,serviceLocationY=?,serviceAreaId=?,serviceContent=?,serviceMoney=?,serviceDate=?,serviceBegin=?,serviceEnd=?,serviceLength=?,serviceItemId=?,serviceItemName=?,stationId=?,stationName=?,stationPhone=?,stationAddress=?,waiterId=?,waiterName=?,waiterPhone=?,waiterLocation=?,processInstanceId=?,processKey=?,processKeyName=?,orderUserId=?,orderUserName=?,orderDate=?,sendUserId=?,sendUserName=?,sendDate=?,stationUserId=?,stationUserName=?,stationDate=?,serviceTimeLength=?,unitType=?,unitTypeName=?,abnormalFlag=?,abnormalFlagName=?,lessFlagName=?,lessFlag=?,businessType=?,field11=?,field12=?,field13=?,createBy=?,updateBy=?,serviceFullPath=?,signInLocation=?,signInStatus=?,signOutLocation=?,signOutStatus=?,signInDistance=?,serviceResult=?,visitUserName=?,serviceVisit=?,customerSatisfactionName=?,visitDate=?,actualCharge=?,actrueBegin=?,isLate=?,isAbnormal=?,actrueEnd=?,isEarly=? where tid = '%@'",orderinfo.tid];
    BOOL res=[db executeUpdate:sql,orderinfo.tid,orderinfo.total,orderinfo.isTrue,orderinfo.createDate,orderinfo.begin,orderinfo.updateDate,orderinfo.delFlag,orderinfo.affixFlag,orderinfo.serviceAreaName,orderinfo.serviceAreaFullPath,orderinfo.workNo,orderinfo.workStatus,orderinfo.workStatusName,orderinfo.customerId,orderinfo.customerNo,orderinfo.machineNo,orderinfo.customerName,orderinfo.customerPhone,orderinfo.serviceAddress,orderinfo.serviceLocationX,orderinfo.serviceLocationY,orderinfo.serviceAreaId,orderinfo.serviceContent,orderinfo.serviceMoney,orderinfo.serviceDate,orderinfo.serviceBegin,orderinfo.serviceEnd,orderinfo.serviceLength,orderinfo.serviceItemId,orderinfo.serviceItemName,orderinfo.stationId,orderinfo.stationName,orderinfo.stationPhone,orderinfo.stationAddress,orderinfo.waiterId,orderinfo.waiterName,orderinfo.waiterPhone,orderinfo.waiterLocation,orderinfo.processInstanceId,orderinfo.processKey,orderinfo.processKeyName,orderinfo.orderUserId,orderinfo.orderUserName,orderinfo.orderDate,orderinfo.sendUserId,orderinfo.sendUserName,orderinfo.sendDate,orderinfo.stationUserId,orderinfo.stationUserName,orderinfo.stationDate,orderinfo.serviceTimeLength,orderinfo.unitType,orderinfo.unitTypeName,orderinfo.abnormalFlag,orderinfo.abnormalFlagName,orderinfo.lessFlagName,orderinfo.lessFlag,orderinfo.businessType,orderinfo.field11,orderinfo.field12,orderinfo.field13,orderinfo.createBy,orderinfo.updateBy,orderinfo.serviceFullPath,orderinfo.signInLocation,orderinfo.signInStatus,orderinfo.signOutLocation,orderinfo.signOutStatus,orderinfo.visitUserName,orderinfo.signInDistance,orderinfo.serviceResult,orderinfo.serviceVisit,orderinfo.customerSatisfactionName,orderinfo.visitDate,orderinfo.actualCharge,orderinfo.actrueBegin,orderinfo.isLate,orderinfo.isAbnormal,orderinfo.actrueEnd,orderinfo.isEarly];
    if(!res)
    {
        NSLog(@"%@",orderinfo.tid);
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
    NSString *sql = [NSString stringWithFormat:@"select count(*) from ORDERTASK"];
    FMResultSet *rs = [db executeQuery:sql,nil];
    int count =0;
    while ([rs next])
    {
        count = [rs intForColumnIndex:0];
    }
    return count;
}


-(OrderInfo *)findByWorkNo:(NSString *)WorkNo
{
    FMDatabase *db=[self Fmdbdatabase];
    NSString *sql = [NSString stringWithFormat:@"select *from ORDERTASK  where workNo = '%@'" ,WorkNo];
    OrderInfo *object;
    FMResultSet *rs=[db executeQuery:sql,nil];
    while ([rs next]) {
        object = [[OrderInfo alloc]init];
        [object getOrderTaskByWorkNo:[rs stringForColumn:@"workNo"]  tid:[rs stringForColumn:@"tid"] total:[rs stringForColumn:@"total"] isTrue:[rs stringForColumn:@"isTrue"] createDate:[rs stringForColumn:@"createDate"] begin:[rs stringForColumn:@"begin"] updateDate:[rs stringForColumn:@"updateDate"] delFlag:[rs stringForColumn:@"delFlag"] affixFlag:[rs stringForColumn:@"affixFlag"] serviceAreaName:[rs stringForColumn:@"serviceAreaName"] serviceAreaFullPath:[rs stringForColumn:@"serviceAreaFullPath"] workStatus:[rs stringForColumn:@"workStatus"] workStatusName:[rs stringForColumn:@"workStatusName"] customerId:[rs stringForColumn:@"customerId"] customerNo:[rs stringForColumn:@"customerNo"] machineNo:[rs stringForColumn:@"machineNo"] customerName:[rs stringForColumn:@"customerName"] customerPhone:[rs stringForColumn:@"customerPhone"] serviceAddress:[rs stringForColumn:@"serviceAddress"] serviceLocationX:[rs stringForColumn:@"serviceLocationX"] serviceLocationY:[rs stringForColumn:@"serviceLocationY"] serviceAreaId:[rs stringForColumn:@"serviceAreaId"] serviceContent:[rs stringForColumn:@"serviceContent"] serviceMoney:[rs stringForColumn:@"serviceMoney"] serviceDate:[rs stringForColumn:@"serviceDate"] serviceBegin:[rs stringForColumn:@"serviceBegin"] serviceEnd:[rs stringForColumn:@"serviceEnd"] serviceLength:[rs stringForColumn:@"serviceLength"] serviceItemId:[rs stringForColumn:@"serviceItemId"] serviceItemName:[rs stringForColumn:@"serviceItemName"] stationId:[rs stringForColumn:@"stationId"] stationName:[rs stringForColumn:@"stationName"] stationPhone:[rs stringForColumn:@"stationPhone"] stationAddress:[rs stringForColumn:@"stationAddress"] waiterId:[rs stringForColumn:@"waiterId"] waiterName:[rs stringForColumn:@"waiterName"] waiterPhone:[rs stringForColumn:@"waiterPhone"] waiterLocation:[rs stringForColumn:@"waiterLocation"] processInstanceId:[rs stringForColumn:@"processInstanceId"] processKey:[rs stringForColumn:@"processKey"] processKeyName:[rs stringForColumn:@"processKeyName"] orderUserId:[rs stringForColumn:@"orderUserId"] orderUserName:[rs stringForColumn:@"orderUserName"] orderDate:[rs stringForColumn:@"orderDate"] sendUserId:[rs stringForColumn:@"sendUserId"] sendUserName:[rs stringForColumn:@"sendUserName"] sendDate:[rs stringForColumn:@"sendDate"] stationUserId:[rs stringForColumn:@"stationUserId"] stationUserName:[rs stringForColumn:@"stationUserName"] stationDate:[rs stringForColumn:@"stationDate"] serviceTimeLength:[rs stringForColumn:@"serviceTimeLength"] unitType:[rs stringForColumn:@"unitType"] unitTypeName:[rs stringForColumn:@"unitTypeName"] abnormalFlag:[rs stringForColumn:@"abnormalFlag"] abnormalFlagName:[rs stringForColumn:@"abnormalFlagName"] lessFlagName:[rs stringForColumn:@"lessFlagName"] lessFlag:[rs stringForColumn:@"lessFlag"] businessType:[rs stringForColumn:@"businessType"] field11:[rs stringForColumn:@"field11"] field12:[rs stringForColumn:@"field12"] field13:[rs stringForColumn:@"field13"] createBy:[rs stringForColumn:@"createBy"] updateBy:[rs stringForColumn:@"updateBy"] serviceFullPath:[rs stringForColumn:@"serviceFullPath"] signInLocation:[rs stringForColumn:@"signInLocation"] signInStatus:[rs stringForColumn:@"signInStatus"] signOutLocation:[rs stringForColumn:@"signOutLocation"]  signOutStatus:[rs stringForColumn:@"signOutStatus"] visitUserName:[rs stringForColumn:@"visitUserName"] signInDistance:[rs stringForColumn:@"signInDistance"] serviceResult:[rs stringForColumn:@"serviceResult"]  serviceVisit:[rs stringForColumn:@"serviceVisit"] CustomerSatisfactionName:[rs stringForColumn:@"CustomerSatisfactionName"] VisitDate:[rs stringForColumn:@"VisitDate"] actualCharge:[rs stringForColumn:@"actualCharge"] actrueBegin:[rs stringForColumn:@"actrueBegin"] isLate:[rs stringForColumn:@"isLate"] isAbnormal:[rs stringForColumn:@"isAbnormal"] actrueEnd:[rs stringForColumn:@"actrueEnd"] isEarly:[rs stringForColumn:@"isEarly"]];
    }
    [rs close];
    [db close];
    return  object;
}

@end
