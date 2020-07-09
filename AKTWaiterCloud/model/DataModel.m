//
//  UserInfo.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "DataModel.h"
#import <objc/runtime.h>

@implementation DataModel

//输出对象属性
+(void)printObjectInfoWithOb:(id)classObject {
    //获取参数
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([classObject class], &varCount);
    
    //为对象赋值
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([[propertyName substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        //输出数据
        DDLogInfo(@"%@ %@",propertyName, object_getIvar(classObject, var));
    }
    DDLogInfo(@"\n\n");
    free(vars);
}

//数据映射－支持单层映射
-(void)objectFromDictWith:(NSMutableDictionary *)dictData {
    //获取参数
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    //为对象赋值
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([[propertyName substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        //字段解析 字段不是nsnull而且拥有数值才去映射
        if ((![[dictData objectForKey:propertyName] isEqual:[NSNull class]]) && [dictData objectForKey:propertyName]) {
            //复合对象不解析
            if ([[dictData objectForKey:propertyName] isKindOfClass:[NSMutableArray class]] || [[dictData objectForKey:propertyName] isKindOfClass:[NSMutableDictionary class]]) {
                DDLogInfo(@"复合对象 %@",propertyName);
                continue;
            }
            NSString *propertyType = [NSString stringWithFormat:@"%s",ivar_getTypeEncoding(var)];
            if ([propertyType isEqualToString:@"@\"NSString\""]) {
                object_setIvar(self, var, [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",[dictData objectForKey:propertyName]]]);
            }
        }
    }
    free(vars);
}

//数据逆映射
-(NSMutableDictionary *)dictFromObject {
    //创建字典
    NSMutableDictionary *dictReturn = [[NSMutableDictionary alloc] init];
    //获取参数
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    //为对象赋值
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([[propertyName substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        //转换成字典
        [dictReturn setValue:object_getIvar(self, var) forKey:propertyName];
    }
    free(vars);
    return dictReturn;
}
@end

@implementation LoginModel

+ (LoginModel *)gets{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"AKTserviceToken"]){
        NSString *path = [AktUtil getCachePath:@"loginModel"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
            return [[LoginModel alloc] initWithDictionary:dict error:nil];
        }
    }
    return nil;
}

- (void)save{
    NSDictionary *local;
    NSString *path = [AktUtil getCachePath:@"loginModel"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
         local= [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self toDictionary]];
    [dict writeToFile:path atomically:YES];
}

@end

#pragma mark --- 用户信息
@implementation UserInfo
+ (UserInfo *)getsUser{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"AKTserviceToken"]){
           NSString *path = [AktUtil getCachePath:@"userModel"];
           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
               NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
               return [[UserInfo alloc] initWithDictionary:dict error:nil];
           }
       }
       return nil;
}
- (void)saveUser{
    NSDictionary *local;
    NSString *path = [AktUtil getCachePath:@"userModel"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
         local= [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self toDictionary]];
    [dict writeToFile:path atomically:YES];
}

@end

#pragma mark --- 我的工单
@implementation OrderInfo

-(void)getOrderTaskByWorkNo:(NSString *)workNo tid:(NSString *)tid total:(NSString *)total isTrue:(NSString *)isTrue  createDate:(NSString *)createDate  begin:(NSString *)begin  updateDate:(NSString *)updateDate  delFlag:(NSString *)delFlag  affixFlag:(NSString *)affixFlag  serviceAreaName:(NSString *)serviceAreaName  serviceAreaFullPath:(NSString *)serviceAreaFullPath  workStatus:(NSString *)workStatus  workStatusName:(NSString *)workStatusName  customerId:(NSString *)customerId  customerNo:(NSString *)customerNo  machineNo:(NSString *)machineNo  customerName:(NSString *)customerName  customerPhone:(NSString *)customerPhone  serviceAddress:(NSString *)serviceAddress  serviceLocationX:(NSString *)serviceLocationX  serviceLocationY:(NSString *)serviceLocationY  serviceAreaId:(NSString *)serviceAreaId  serviceContent:(NSString *)serviceContent  serviceMoney:(NSString *)serviceMoney  serviceDate:(NSString *)serviceDate  serviceBegin:(NSString *)serviceBegin  serviceEnd:(NSString *)serviceEnd  serviceLength:(NSString *)serviceLength  serviceItemId:(NSString *)serviceItemId  serviceItemName:(NSString *)serviceItemName  stationId:(NSString *)stationId  stationName:(NSString *)stationName  stationPhone:(NSString *)stationPhone  stationAddress:(NSString *)stationAddress  waiterId:(NSString *)waiterId  waiterName:(NSString *)waiterName  waiterPhone:(NSString *)waiterPhone  waiterLocation:(NSString *)waiterLocation  processInstanceId:(NSString *)processInstanceId  processKey:(NSString *)processKey  processKeyName:(NSString *)processKeyName  orderUserId:(NSString *)orderUserId  orderUserName:(NSString *)orderUserName  orderDate:(NSString *)orderDate  sendUserId:(NSString *)sendUserId  sendUserName:(NSString *)sendUserName  sendDate:(NSString *)sendDate  stationUserId:(NSString *)stationUserId  stationUserName:(NSString *)stationUserName  stationDate:(NSString *)stationDate serviceTimeLength:(NSString *)serviceTimeLength unitType:(NSString *)unitType  unitTypeName:(NSString *)unitTypeName  abnormalFlag:(NSString *)abnormalFlag  abnormalFlagName:(NSString *)abnormalFlagName  lessFlagName:(NSString *)lessFlagName  lessFlag:(NSString *)lessFlag  businessType:(NSString *)businessType    field11:(NSString *)field11  field12:(NSString *)field12  field13:(NSString *)field13  createBy:(NSString *)createBy  updateBy:(NSString *)updateBy serviceFullPath:(NSString *)serviceFullPath  signInLocation:(NSString *)signInLocation  signInStatus:(NSString *)signInStatus  signOutLocation:(NSString *)signOutLocation  signOutStatus:(NSString *)signOutStatus visitUserName:(NSString *)visitUserName signInDistance:(NSString *)signInDistance serviceResult:(NSString *)serviceResult  serviceVisit:(NSString *)serviceVisit CustomerSatisfactionName:(NSString *)customerSatisfactionName VisitDate:(NSString *)visitDate actualCharge:(NSString *)actualCharge actrueBegin:(NSString *)actrueBegin isLate:(NSString *)isLate isAbnormal:(NSString *)isAbnormal actrueEnd:(NSString *)actrueEnd isEarly:(NSString *)isEarly{
    self.workNo = workNo;
    self.tid = tid;
    self.total = total;
    self.isTrue = isTrue;
    self.createDate = createDate;
    self.begin = begin;
    self.updateDate = updateDate;
    self.delFlag = delFlag;
    self.affixFlag = affixFlag;
    self.serviceAreaName = serviceAreaName;
    self.serviceAreaFullPath = serviceAreaFullPath;
    self.nodeName = workStatus;
    self.workStatusName = workStatusName;
    self.customerId = customerId;
    self.customerNo = customerNo;
    self.machineNo = machineNo;
    self.customerName = customerName;
    self.customerPhone = customerPhone;
    self.serviceAddress = serviceAddress;
    self.serviceLocationX = serviceLocationX;
    self.serviceLocationY = serviceLocationY;
    self.serviceAreaId = serviceAreaId;
    self.serviceContent = serviceContent;
    self.serviceMoney = serviceMoney;
    self.serviceDate = serviceDate;
    self.serviceBegin = serviceBegin;
    self.serviceEnd = serviceEnd;
    self.serviceLength = serviceLength;
    self.serviceItemId = serviceItemId;
    self.serviceItemName = serviceItemName;
    self.stationId = stationId;
    self.stationName = stationName;
    self.stationPhone = stationPhone;
    self.stationAddress = stationAddress;
    self.waiterId = waiterId;
    self.waiterName = waiterName;
    self.waiterPhone = waiterPhone;
    self.waiterLocation = waiterLocation;
    self.processInstanceId = processInstanceId;
    self.processKey = processKey;
    self.processKeyName = processKeyName;
    self.orderUserId = orderUserId;
    self.orderUserName = orderUserName;
    self.orderDate = orderDate;
    self.sendUserId = sendUserId;
    self.sendUserName = sendUserName;
    self.sendDate = sendDate;
    self.stationUserId = stationUserId;
    self.stationUserName = stationUserName;
    self.stationDate = stationDate;
    self.serviceTimeLength = serviceTimeLength;
    self.unitType = unitType;
    self.unitTypeName = unitTypeName;
    self.abnormalFlag = abnormalFlag;
    self.abnormalFlagName = abnormalFlagName;
    self.lessFlagName = lessFlagName;
    self.lessFlag = lessFlag;
    self.businessType = businessType;
    self.field11 = field11;
    self.field12 = field12;
    self.field13 = field13;
    self.createBy = createBy;
    self.updateBy = updateBy;
    self.serviceFullPath = serviceFullPath;
    self.signInLocation = signInLocation;
    self.signInStatus = signInStatus;
    self.signOutLocation = signOutLocation;
    self.signOutStatus = signOutStatus;
    self.visitUserName = visitUserName;
    self.signInDistance = signInDistance;
    self.serviceResult = serviceResult;
    self.serviceVisit = serviceVisit;
    self.customerSatisfactionName = customerSatisfactionName;
    self.visitDate = visitDate;
    self.actualCharge = actualCharge;
    self.actrueBegin = actrueBegin;
    self.isLate = isLate;
    self.isAbnormal = isAbnormal;
    self.actrueEnd = actrueEnd;
    self.isEarly = isEarly;
}

@end


#pragma mark --- 服务用户
@implementation DownOrderFirstInfo
@end


#pragma mark --- 服务项目
@implementation ServicePojInfo
@end

#pragma mark - 注册列表租户信息
@implementation SigninListInfo
@end
@implementation SigninDetailsInfo
@end
