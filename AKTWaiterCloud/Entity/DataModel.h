//
//  UserInfo.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
@interface DataModel : NSObject
//输出对象属性
+(void)printObjectInfoWithOb:(id)classObject;
//数据映射
-(void)objectFromDictWith:(NSMutableDictionary *)dictData;
//数据逆映射
-(NSMutableDictionary *)dictFromObject;
@end

#pragma mark --- 用户信息
@interface UserInfo : JSONModel
@property(nonatomic,strong) NSString <Optional>*  id;
@property(nonatomic,strong) NSString <Optional>*  uuid;
@property(nonatomic,strong) NSString <Optional>*  icon;
@property(nonatomic,strong) NSString <Optional>*  mobile;
@property(nonatomic,strong) NSString <Optional>*  password;  // 密码
@property(nonatomic,strong) NSString <Optional>*  tenantsId;
@property(nonatomic,strong) NSString <Optional>*  location;
@property(nonatomic,strong) NSString <Optional>*  cooperationState;
@property(nonatomic,strong) NSString <Optional>*  cooperationStateName;
@property(nonatomic,strong) NSString <Optional>*  sex;
@property(nonatomic,strong) NSString <Optional>*  sexName;
@property(nonatomic,strong) NSString <Optional>*  stationNo;
@property(nonatomic,strong) NSString <Optional>*  saleId;
@property(nonatomic,strong) NSString <Optional>*  synopsis;
@property(nonatomic,strong) NSString <Optional>*  waiterName;
@property(nonatomic,strong) NSString <Optional>*  waiterNo;
@property(nonatomic,strong) NSString <Optional>*  locationX;
@property(nonatomic,strong) NSString <Optional>*  locationY;
@property(nonatomic,strong) NSString <Optional>*  missionTrans;//1需要扫码
@property(nonatomic,strong) NSString <Optional>*  maxOrders;//是总金额
@property(nonatomic,strong) NSString <Optional>*  level;//是等级
@property(nonatomic,strong) NSString <Optional>*  startPermission;//主动发起工单权限 0表示否，1表示是
@property(nonatomic,strong) NSString <Optional>*  waiterUkey;//唯一码
@property(nonatomic,strong) NSString <Optional>*  locationFlag;//来判断是否有更新用户地址的权限
@property(nonatomic,strong) NSString <Optional>*  isPosition;//0:不需要判断 1:需要判断
@property(nonatomic,strong) NSString * isclickOff_line;  //0开启离线模式   1禁用启用模式
-(void)getUserInfoById:(NSString *)userid Byicon:(NSString *)icon Bymobile:(NSString *)mobile Bypassword:(NSString *)password  BytenantsId:(NSString *)tenantsId  Bylocation:(NSString *)location  BycooperationState:(NSString *)cooperationState  BycooperationStateName:(NSString *)cooperationStateName  Bysex:(NSString *)sex  BysexName:(NSString *)sexName  BystationNo:(NSString *)stationNo  BysaleId:(NSString *)saleId  Bysynopsis:(NSString *)synopsis  BywaiterName:(NSString *)waiterName  BywaiterNo:(NSString *)waiterNo  BylocationX:(NSString *)locationX  BylocationY:(NSString *)locationY  BymissionTrans:(NSString *)missionTrans  BymaxOrders:(NSString *)maxOrders  Bylevel:(NSString *)level  BystartPermission:(NSString *)startPermission  BywaiterUkey:(NSString *)waiterUkey  BylocationFlag:(NSString *)locationFlag  ByisPosition:(NSString *)isPosition ByisclickOff_line:(NSString*)isclickOff_line;
@end


#pragma mark --- 我的钱包
@interface WorkMoneyInfo : JSONModel
@property(nonatomic,strong) NSString  <Optional>* workNo;
@property(nonatomic,strong) NSString  <Optional>* delFlag;
@property(nonatomic,strong) NSString  <Optional>* serviceBegin;
@property(nonatomic,strong) NSString  <Optional>* affixFlag;
@property(nonatomic,strong) NSString  <Optional>* begin;
@property(nonatomic,strong) NSString  <Optional>* serviceMoney;
@property(nonatomic,strong) NSString  <Optional>* total;
@end


#pragma mark --- 我的工单
@interface OrderInfo : JSONModel
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
@property(nonatomic,strong) NSString  <Optional>* workStatus;//工单状态  3、7  未开始   4 进行中  6、8、10 已结束
@property(nonatomic,strong) NSString  <Optional>* workStatusName;//
@property(nonatomic,strong) NSString  <Optional>* customerId;//服务用户ID
@property(nonatomic,strong) NSString  <Optional>* customerNo;//档案号
@property(nonatomic,strong) NSString  <Optional>* machineNo;//机器编号
@property(nonatomic,strong) NSString  <Optional>* customerName;//用户姓名
@property(nonatomic,strong) NSString  <Optional>* customerPhone;//用户电话
@property(nonatomic,strong) NSString  <Optional>* serviceAddress;//服务地址
@property(nonatomic,strong) NSString  <Optional>* serviceLocationX;//20170915添加
@property(nonatomic,strong) NSString  <Optional>* serviceLocationY;//20170915添加
@property(nonatomic,strong) NSString  <Optional>* serviceAreaId;//
@property(nonatomic,strong) NSString  <Optional>* serviceResult;//完成情况
@property(nonatomic,strong) NSString  <Optional>* serviceContent;//服务内容
@property(nonatomic,strong) NSString  <Optional>* serviceMoney;//服务金额
@property(nonatomic,strong) NSString  <Optional>* serviceDate;//服务日期
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
@property(nonatomic,strong) NSString <Optional>* createBy;
@property(nonatomic,strong) NSString <Optional>* updateBy;
@property(nonatomic,strong) NSString <Optional>* serviceFullPath;
//update 2016-12-26 15:59:06
@property(nonatomic,strong) NSString  <Optional>* signInLocation;//签入地点
@property(nonatomic,strong) NSString  <Optional>* signInStatus;//签入状态
@property(nonatomic,strong) NSString  <Optional>* signOutLocation;//签出地点
@property(nonatomic,strong) NSString  <Optional>* signOutStatus;//签出状态
@property(nonatomic,strong) NSString  <Optional>* visitUserName;//回访人
@property(nonatomic,strong) NSString  <Optional>* serviceVisit;//回访情况
@property(nonatomic,strong) NSString  <Optional>* CustomerSatisfactionName;//回访满意度
@property(nonatomic,strong) NSString  <Optional>* VisitDate;//回访时间
@property(nonatomic,strong) NSString  <Optional>* signInDistance;//签入距离
@property(nonatomic,strong) NSString  <Optional>* signOutDistance;//签出距离
@property(nonatomic,strong) NSString  <Optional>* actualCharge;//
@property(nonatomic,strong) NSString  <Optional>* actrueBegin;//签入时间
@property(nonatomic,strong) NSString  <Optional>* isLate;//是否迟到((0:正常1:迟到);)
@property(nonatomic,strong) NSString  <Optional>* isAbnormal;//是否定位异常
@property(nonatomic,strong) NSString  <Optional>* actrueEnd;//签出时间
@property(nonatomic,strong) NSString  <Optional>* isEarly;//是否早退

-(void)getOrderTaskByWorkNo:(NSString *)workNo tid:(NSString *)tid total:(NSString *)total isTrue:(NSString *)isTrue  createDate:(NSString *)createDate  begin:(NSString *)begin  updateDate:(NSString *)updateDate  delFlag:(NSString *)delFlag  affixFlag:(NSString *)affixFlag  serviceAreaName:(NSString *)serviceAreaName  serviceAreaFullPath:(NSString *)serviceAreaFullPath  workStatus:(NSString *)workStatus  workStatusName:(NSString *)workStatusName  customerId:(NSString *)customerId  customerNo:(NSString *)customerNo  machineNo:(NSString *)machineNo  customerName:(NSString *)customerName  customerPhone:(NSString *)customerPhone  serviceAddress:(NSString *)serviceAddress  serviceLocationX:(NSString *)serviceLocationX  serviceLocationY:(NSString *)serviceLocationY  serviceAreaId:(NSString *)serviceAreaId  serviceContent:(NSString *)serviceContent  serviceMoney:(NSString *)serviceMoney  serviceDate:(NSString *)serviceDate  serviceBegin:(NSString *)serviceBegin  serviceEnd:(NSString *)serviceEnd  serviceLength:(NSString *)serviceLength  serviceItemId:(NSString *)serviceItemId  serviceItemName:(NSString *)serviceItemName  stationId:(NSString *)stationId  stationName:(NSString *)stationName  stationPhone:(NSString *)stationPhone  stationAddress:(NSString *)stationAddress  waiterId:(NSString *)waiterId  waiterName:(NSString *)waiterName  waiterPhone:(NSString *)waiterPhone  waiterLocation:(NSString *)waiterLocation  processInstanceId:(NSString *)processInstanceId  processKey:(NSString *)processKey  processKeyName:(NSString *)processKeyName  orderUserId:(NSString *)orderUserId  orderUserName:(NSString *)orderUserName  orderDate:(NSString *)orderDate  sendUserId:(NSString *)sendUserId  sendUserName:(NSString *)sendUserName  sendDate:(NSString *)sendDate  stationUserId:(NSString *)stationUserId  stationUserName:(NSString *)stationUserName  stationDate:(NSString *)stationDate serviceTimeLength:(NSString *)serviceTimeLength unitType:(NSString *)unitType  unitTypeName:(NSString *)unitTypeName  abnormalFlag:(NSString *)abnormalFlag  abnormalFlagName:(NSString *)abnormalFlagName  lessFlagName:(NSString *)lessFlagName  lessFlag:(NSString *)lessFlag  businessType:(NSString *)businessType    field11:(NSString *)field11  field12:(NSString *)field12  field13:(NSString *)field13  createBy:(NSString *)createBy  updateBy:(NSString *)updateBy  serviceFullPath:(NSString *)serviceFullPath  signInLocation:(NSString *)signInLocation  signInStatus:(NSString *)signInStatus  signOutLocation:(NSString *)signOutLocation  signOutStatus:(NSString *)signOutStatus visitUserName:(NSString *)visitUserName signInDistance:(NSString *)signInDistance serviceResult:(NSString *)serviceResult  serviceVisit:(NSString *)serviceVisit CustomerSatisfactionName:(NSString *)CustomerSatisfactionName VisitDate:(NSString *)VisitDate actualCharge:(NSString *)actualCharge actrueBegin:(NSString *)actrueBegin isLate:(NSString *)isLate isAbnormal:(NSString *)isAbnormal actrueEnd:(NSString *)actrueEnd isEarly:(NSString *)isEarly;
@end

#pragma mark --- 服务用户
@interface DownOrderFirstInfo : JSONModel
@property (strong, nonatomic) NSString<Optional>* delFlag;
@property (strong, nonatomic) NSString<Optional>* affixFlag;
@property (strong, nonatomic) NSString<Optional>* serviceAreaId;
@property (strong, nonatomic) NSString<Optional>* serviceAreaName;
@property (strong, nonatomic) NSString<Optional>* serviceAreaFullPath;
@property (strong, nonatomic) NSString<Optional>* customerId;
@property (strong, nonatomic) NSString<Optional>* customerName;
@property (strong, nonatomic) NSString<Optional>* customerPhone;
@property (strong, nonatomic) NSString<Optional>* serviceAddress;
@property (strong, nonatomic) NSString<Optional>* serviceDate;
@property (strong, nonatomic) NSString<Optional>* serviceBegin;
@property (strong, nonatomic) NSString<Optional>* serviceEnd;
@property (strong, nonatomic) NSString<Optional>* begin;
@property (strong, nonatomic) NSString<Optional>* total;
@end

#pragma mark --- 服务项目
@interface ServicePojInfo : JSONModel
@property (strong, nonatomic) NSString<Optional>* abnormalFlag;
@property (strong, nonatomic) NSString<Optional>* affixFlag;
@property (strong, nonatomic) NSString<Optional>* aktType;
@property (strong, nonatomic) NSString<Optional>* businessType;
@property (strong, nonatomic) NSString<Optional>* careType;
@property (strong, nonatomic) NSString<Optional>* createBy;
@property (strong, nonatomic) NSString<Optional>* createDate;
@property (strong, nonatomic) NSString<Optional>* delFlag;
@property (strong, nonatomic) NSString<Optional>* govType;
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* isShow;
@property (strong, nonatomic) NSString<Optional>* lessFlag;
@property (strong, nonatomic) NSString<Optional>* messageType;
@property (strong, nonatomic) NSString<Optional>* messageTypeName;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSString<Optional>* parentId;
@property (strong, nonatomic) NSString<Optional>* parentIds;
@property (strong, nonatomic) NSString<Optional>* parentName;
@property (strong, nonatomic) NSString<Optional>* processKey;
@property (strong, nonatomic) NSString<Optional>* processKeyName;
@property (strong, nonatomic) NSString<Optional>* remarks;
@property (strong, nonatomic) NSString<Optional>* roleKey;
@property (strong, nonatomic) NSString<Optional>* serviceMoney;
@property (strong, nonatomic) NSString<Optional>* sort;
@property (strong, nonatomic) NSString<Optional>* spread;
@property (strong, nonatomic) NSString<Optional>* startPermission;
@property (strong, nonatomic) NSString<Optional>* startPermissionName;
@property (strong, nonatomic) NSString<Optional>* state;
@property (strong, nonatomic) NSString<Optional>* typeKey;
@property (strong, nonatomic) NSString<Optional>* unitQuantity;
@property (strong, nonatomic) NSString<Optional>* unitType;//1是按时收费 2是按次收费
@property (strong, nonatomic) NSString<Optional>* serviceBegin; // 服务开始时间
@property (strong, nonatomic) NSString<Optional>* serviceEnd; // 服务结束时间

@end


#pragma mark - 注册租户列表
@protocol SigninDetailsInfo
@end

@interface SigninListInfo : JSONModel
@property (strong, nonatomic) NSString<Optional>* pid;
@property (strong, nonatomic) NSString<Optional>* pname;
@property (strong, nonatomic) NSArray <SigninDetailsInfo> *tenantsList;
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
@end
