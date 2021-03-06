//
//  UserInfo.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "AktOrderDetailsModel.h"

@interface DataModel : NSObject
//输出对象属性
+(void)printObjectInfoWithOb:(id)classObject;
//数据映射
-(void)objectFromDictWith:(NSMutableDictionary *)dictData;
//数据逆映射
-(NSMutableDictionary *)dictFromObject;
@end
@interface LoginModel : JSONModel
@property(nonatomic,strong) NSString <Optional>*  id;
@property(nonatomic,strong) NSString <Optional>*  uuid; // 与用户id一样，是将id的值赋予uuid
@property(nonatomic,strong) NSString <Optional>*  tenantId; // 租户ID
@property(nonatomic,strong) NSString <Optional>*  tenantName; // 租户站名称
@property(nonatomic,strong) NSString <Optional>*  name; // 用户名
@property(nonatomic,strong) NSString <Optional>*  sex; // 性别
@property(nonatomic,strong) NSString <Optional>*  identifyNo; // 身份证
@property(nonatomic,strong) NSString <Optional>*  mobile; // 手机号
@property(nonatomic,strong) NSString <Optional>*  address; // 助老员地址
@property(nonatomic,strong) NSString <Optional>*  password;  // 密码
@property(nonatomic,strong) NSString <Optional>*  uniqueKey;  // 唯一码
@property(nonatomic,strong) NSString <Optional>*  token;  // 唯一码

+ (LoginModel *)gets; // 获取
- (void)save; // 保存

@end
#pragma mark --- 用户信息


@interface UserInfo : JSONModel

@property(nonatomic,strong) NSString <Optional>*  uuid; // 与用户id一样
//@property(nonatomic,strong) NSString <Optional>*  missionTrans;//1需要扫码
//@property(nonatomic,strong) NSString <Optional>*  level;//是等级
@property(nonatomic,strong) NSString <Optional>*  id;
@property(nonatomic,strong) NSString <Optional>*  password;  // 密码
@property(nonatomic,strong) NSString <Optional>*  uniqueKey;//唯一码
@property(nonatomic,strong) NSString <Optional>*  name;  // 用户名
@property(nonatomic,strong) NSString <Optional>*  sex; // 性别类型 0男 1女
@property(nonatomic,strong) NSString <Optional>*  identifyNo;// 身份证号
@property(nonatomic,strong) NSString <Optional>*  mobile; // 手机号
@property(nonatomic,strong) NSString <Optional>*  address;  // 地址
@property(nonatomic,strong) NSString <Optional>*  icon; // 头像
@property(nonatomic,strong) NSString <Optional>* registrationId; //
@property(nonatomic,strong) NSString <Optional>* tenantName; // 租户站名称
@property(nonatomic,strong) NSString <Optional>* tenantId; // 租户ID
@property(nonatomic,strong) NSString <Optional>* tenantCode; //
@property(nonatomic,strong) NSString <Optional>* organizationId; // 组织ID
+ (UserInfo *)getsUser; // 获取
- (void)saveUser; // 保存

@end


#pragma mark --- 我的工单
@protocol OrderListModel
@end

@interface AktOrderModel : JSONModel
@property(nonatomic,strong) NSString  <Optional>*total; // 工单总数量
@property(nonatomic,strong) NSArray <OrderListModel>* list; // 工单列表
@end

@interface OrderListModel : JSONModel
@property(nonatomic,strong) NSString  <Optional>* tid;//
@property(nonatomic,strong) NSString  <Optional>* id;//
@property(nonatomic,strong) NSString  <Optional>* total;
@property(nonatomic,strong) NSString  <Optional>* isTrue;//
@property(nonatomic,strong) NSString  <Optional>* createDate;//
@property(nonatomic,strong) NSString  <Optional>* begin;//
@property(nonatomic,strong) NSString  <Optional>* updateDate;//
@property(nonatomic,strong) NSString  <Optional>* delFlag;//
@property(nonatomic,strong) NSString  <Optional>* affixFlag;//
@property(nonatomic,strong) NSString  <Optional>* serviceAreaName;//服务区域
@property(nonatomic,strong) NSString  <Optional>* serviceAreaFullPath;//区域全路径
@property(nonatomic,strong) NSString  <Optional>* workNo;//工单号
@property(nonatomic,strong) NSString  <Optional>* workStatus;//工单状态  1  未开始   2 进行中  3 已结束
//@property(nonatomic,strong) NSString  <Optional>* nodeName; // 工单状态 待签入=未开始   待签出=进行中，其他都是已完成
@property(nonatomic,strong) NSString  <Optional>* workStatusName;//
@property(nonatomic,strong) NSString  <Optional>* customerId;//服务用户ID
@property(nonatomic,strong) NSString  <Optional>* customerNo;//档案号
@property(nonatomic,strong) NSString  <Optional>* machineNo;//机器编号
@property(nonatomic,strong) NSString  <Optional>* customerName;//用户姓名
@property(nonatomic,strong) NSString  <Optional>* customerPhone;//用户电话
@property(nonatomic,strong) NSString  <Optional>* customerUkey;// 扫码对比
@property(nonatomic,strong) NSString  <Optional>* serviceAddress;//服务地址
@property(nonatomic,strong) NSString  <Optional>* serviceLocationX;//20170915添加  经线 longitude
@property(nonatomic,strong) NSString  <Optional>* serviceLocationY;//20170915添加  纬线 latitude
@property(nonatomic,strong) NSString  <Optional>* serviceAreaId;//
@property(nonatomic,strong) NSString  <Optional>* serviceResult;//完成情况
@property(nonatomic,strong) NSString  <Optional>* serviceContent;//服务内容
@property(nonatomic,strong) NSString  <Optional>* serviceMoney;//服务金额
@property(nonatomic,strong) NSString  <Optional>* serviceDate;//服务开始日期
@property(nonatomic,strong) NSString  <Optional>* serviceDateEnd; // 服务结束日期
@property(nonatomic,strong) NSString  <Optional>* serviceBegin;//服务开始时间
@property(nonatomic,strong) NSString  <Optional>* serviceEnd;//服务结束时间
@property(nonatomic,strong) NSString  <Optional>* serviceLength; // 服务总时间
@property(nonatomic,strong) NSString  <Optional>* serviceItemId;//
@property(nonatomic,strong) NSString  <Optional>* serviceItemName;//服务项目
@property(nonatomic,strong) NSString  <Optional>* stationId;//
@property(nonatomic,strong) NSString  <Optional>* stationName;//服务站
@property(nonatomic,strong) NSString  <Optional>* stationPhone;//服务站电话
@property(nonatomic,strong) NSString  <Optional>* stationAddress;//服务站地址
@property(nonatomic,strong) NSString  <Optional>* waiterId;//服务人员/商编号
@property(nonatomic,strong) NSString  <Optional>* waiterName;//服务人员/商姓名
@property(nonatomic,strong) NSString  <Optional>* waiterPhone;//服务人员/商电话
@property(nonatomic,strong) NSString  <Optional>* waiterLocation;//
@property(nonatomic,strong) NSString  <Optional>* processInstanceId;//
@property(nonatomic,strong) NSString  <Optional>* processKey;//
@property(nonatomic,strong) NSString  <Optional>* processKeyName;//
@property(nonatomic,strong) NSString  <Optional>* orderUserId;//
@property(nonatomic,strong) NSString  <Optional>* orderUserName;//
@property(nonatomic,strong) NSString  <Optional>* orderDate;//
@property(nonatomic,strong) NSString  <Optional>* sendUserId;//
@property(nonatomic,strong) NSString  <Optional>* sendUserName;//
@property(nonatomic,strong) NSString  <Optional>* sendDate;//
@property(nonatomic,strong) NSString  <Optional>* stationUserId;//
@property(nonatomic,strong) NSString  <Optional>* stationUserName;//
@property(nonatomic,strong) NSString  <Optional>* stationDate;//
//update 2017-8-8
@property(nonatomic,assign) NSString <Optional>* serviceTimeLength;
//update 2017-9-6
@property(nonatomic,strong) NSString <Optional>* unitType;//1按时显示，其他按次不显示
@property(nonatomic,strong) NSString <Optional>* unitTypeName;//按次，按时
@property(nonatomic,strong) NSString <Optional>* abnormalFlag;//
@property(nonatomic,strong) NSString <Optional>* abnormalFlagName;//
@property(nonatomic,strong) NSString <Optional>* lessFlagName;//
@property(nonatomic,strong) NSString <Optional>* lessFlag;//
@property(nonatomic,strong) NSString <Optional>* businessType;//
@property(nonatomic,strong) NSString <Optional>* field11;//
@property(nonatomic,strong) NSString <Optional>* field12;//
@property(nonatomic,strong) NSString <Optional>* field13;//
@property(nonatomic,strong) NSString <Optional>* serviceFullPath;
//update 2016-12-26 15:59:06
@property(nonatomic,strong) NSString  <Optional>* signInLocation;//签入地点
@property(nonatomic,strong) NSString  <Optional>* signInStatus;//签入状态
@property(nonatomic,strong) NSString  <Optional>* signOutLocation;//签出地点
@property(nonatomic,strong) NSString  <Optional>* signOutStatus;//签出状态
@property(nonatomic,strong) NSString  <Optional>* visitUserName;//回访人
@property(nonatomic,strong) NSString  <Optional>* serviceVisit;//回访情况
@property(nonatomic,strong) NSString  <Optional>* customerSatisfactionName;//回访满意度 1非常满意、2满意、3一般、4不满意
@property(nonatomic,strong) NSString  <Optional>* visitDate;//回访时间
@property(nonatomic,strong) NSString  <Optional>* signInDistance;//签入距离
@property(nonatomic,strong) NSString  <Optional>* signOutDistance;//签出距离
@property(nonatomic,strong) NSString  <Optional>* actualCharge;//
@property(nonatomic,strong) NSString  <Optional>* actualBegin;//签入时间
@property(nonatomic,strong) NSString  <Optional>* isLate;//是否迟到((0:正常1:迟到);)
@property(nonatomic,strong) NSString  <Optional>* isAbnormal;//是否定位异常(0:正常1:异常)
@property(nonatomic,strong) NSString  <Optional>* actualEnd;//签出时间
@property(nonatomic,strong) NSString  <Optional>* isEarly;//是否早退(0:正常1:早退)

@end

#pragma mark - 下单
@protocol ServicePojInfo
@end
@protocol ServiceStationInfo
@end

@interface DowOrderData : JSONModel
@property (strong, nonatomic) NSArray<ServiceStationInfo>*station;   //:{“principalPhone”:”服务站电话”}          (服务站点列表)
@property (strong, nonatomic) NSArray<ServicePojInfo>*serviceItem;   //（服务项目列表，之前的工单项目列表不再使用了）
@property (strong, nonatomic) DownOrderUserInfo<Optional> *customer; //      (服务用户)
@end

//服务项目
@interface ServicePojInfo : JSONModel
/**4.0 新增接口**/
@property (strong, nonatomic) NSString<Optional>* processId;
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSString<Optional>* showName;
@property (strong, nonatomic) NSString<Optional>* fullName; // 服务名称
@property (strong, nonatomic) NSString<Optional>* serviceValidity; // = -2;// 根据开始日期计算结束日期  0：开始日期所在周   -1：开始日期所在月  其他正数表示往后推迟的天数
@property (strong, nonatomic) NSString<Optional>* serviceTime;//根据开始时间往后推迟的时间
@property (strong, nonatomic) NSString<Optional>* timeUnit;//根据开始时间往后推迟的时间的单位  1：小时  2:分钟

@end

//服务站点
@interface ServiceStationInfo : JSONModel
@property (strong, nonatomic) NSString<Optional>* id; // 服务站ID
@property (strong, nonatomic) NSString<Optional>* organizationId;
@property (strong, nonatomic) NSString<Optional>* name; // 服务站名称
@property (strong, nonatomic) NSString<Optional>* uniqueKey;
@property (strong, nonatomic) NSString<Optional>* areaId; //
@property (strong, nonatomic) NSString<Optional>* address; //
@property (strong, nonatomic) NSString<Optional>* principalName;//
@property (strong, nonatomic) NSString<Optional>* principalPhone; //服务站电话

@end


#pragma mark - 注册租户列表
@protocol SigninDetailsInfo
@end

@interface SigninListInfo : JSONModel
@property (strong, nonatomic) NSString<Optional>* pid;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSArray <SigninDetailsInfo> *children;
@end

@interface SigninDetailsInfo : JSONModel
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* affixFlag;
@property (strong, nonatomic) NSString<Optional>* areaCode;
@property (strong, nonatomic) NSString<Optional>* areaId;
@property (strong, nonatomic) NSString<Optional>* classId;
@property (strong, nonatomic) NSString<Optional>* ctiPlatformId;
@property (strong, nonatomic) NSString<Optional>* dataSourceId;
@property (strong, nonatomic) NSString<Optional>* delFlag;
@property (strong, nonatomic) NSString<Optional>* isAdmin;
@property (strong, nonatomic) NSString<Optional>* jspPath;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSString<Optional>* prefix;
@property (strong, nonatomic) NSString<Optional>* sort;
@property (strong, nonatomic) NSString<Optional>* spread;
@property (strong, nonatomic) NSString<Optional>* state;
@property (strong, nonatomic) NSString<Optional>* tenantsCode;
@property (strong, nonatomic) NSString<Optional>* orgId; // 组织ID
@property (strong, nonatomic) NSString<Optional>* tenantId;

@end
