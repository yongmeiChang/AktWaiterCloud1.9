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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:Token]){
        NSString *path = [AktUtil getCachePath:@"loginNewModel"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
            return [[LoginModel alloc] initWithDictionary:dict error:nil];
        }
    }
    return nil;
}

- (void)save{
    NSDictionary *local;
    NSString *path = [AktUtil getCachePath:@"loginNewModel"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
         local= [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self toDictionary]];
    [dict writeToFile:path atomically:YES];
}

@end

#pragma mark --- 用户信息
@implementation UserInfo
+ (UserInfo *)getsUser{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:Token]){
           NSString *path = [AktUtil getCachePath:@"userNewModel"];
           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
               NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
               return [[UserInfo alloc] initWithDictionary:dict error:nil];
           }
       }
       return nil;
}
- (void)saveUser{
    NSDictionary *local;
    NSString *path = [AktUtil getCachePath:@"userNewModel"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
         local= [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self toDictionary]];
    [dict writeToFile:path atomically:YES];
}

@end

#pragma mark --- 我的工单
@implementation AktOrderModel

@end

@implementation OrderListModel
@end


#pragma mark - 下单
@implementation DowOrderData
@end
@implementation ServicePojInfo
@end
@implementation ServiceStationInfo
@end

#pragma mark - 注册列表租户信息
@implementation SigninListInfo
@end
@implementation SigninDetailsInfo
@end
