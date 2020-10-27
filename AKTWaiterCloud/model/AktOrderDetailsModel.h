//
//  AktOrderDetailsModel.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/16.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AktOrderDetailsModel : JSONModel

@end

@interface AktFindAdvanceModel : JSONModel

@property(nonatomic,strong) NSString <Optional>* serviceItemId; // 服务项目id
@property(nonatomic,strong) NSString <Optional>* orderGrabbing; // 是否抢单  1是 0否
@property(nonatomic,strong) NSString <Optional>* codeScanSignIn;//是否扫码签入 1是 0否

@property(nonatomic,strong) NSString <Optional>* recordLate; //是否记录迟到 1是 0否
@property(nonatomic,strong) NSString <Optional>* maxLateTime; // 迟到最大时长 分钟    允许操作的最大时长（时长内只记录，时长外根据lateAbnormal判断）
@property(nonatomic,strong) NSString <Optional>* lateAbnormal;// 签入迟到超出最大时操作  1:继续签入/签出  2：弹框提示（非必须输入） 3：暂停（操作取消）  0：直接结单

@property(nonatomic,strong) NSString <Optional>* recordLocationSignIn; // 是否记录签入定位 1是 0 否
@property(nonatomic,strong) NSString <Optional>* recordLocationAbnormalSignIn; // 是否记录签入定位异常 1是 0否
@property(nonatomic,strong) NSString <Optional>* maxLocationDistanceSignIn; // 签入最大定位误差 米  前端对比：误差之内是正常
@property(nonatomic,strong) NSString <Optional>* locationAbnormalSignIn; //签入定位异常时操作    1，2，3，0  同迟到操作类型一致(lateAbnormal)

@property(nonatomic,strong) NSString <Optional>* photographSignIn;//是否签入拍照、是否必须上传图片   1是 0 否 （一下关于是否统一定义：1是 0否,否的话隐藏相关界面）
@property(nonatomic,strong) NSString <Optional>* photosNumberSignIn; // 签入照片数量  最大值是3
@property(nonatomic,strong) NSString <Optional>* photoAlbumSignIn; // 是否允许签入打开相册 1是 0否
@property(nonatomic,strong) NSString <Optional>* soundRecordingSignIn; // 是否签入录音、是否必须上传录音
@property(nonatomic,strong) NSString <Optional>* soundRecordTimeSignIn; // 签入录音时长 秒

@property(nonatomic,strong) NSString <Optional>* codeScanSignOut; // 是否扫码签出
@property(nonatomic,strong) NSString <Optional>* recordEarly;  // 是否记录早退

@property(nonatomic,strong) NSString <Optional>* maxEarlyTime; // 早退最大时长 分
@property(nonatomic,strong) NSString <Optional>* earlyAbnormal; // 签出早退超出最大时操作 1 2 3 0

@property(nonatomic,strong) NSString <Optional>* recordLocationSignOut; // 是否记录签出定位
@property(nonatomic,strong) NSString <Optional>* recordLocationAbnormalSignOut; // 是否记录签出定位异常

@property(nonatomic,strong) NSString <Optional>* maxLocationDistanceSignOut; // 签出最大定位误差
@property(nonatomic,strong) NSString <Optional>* locationAbnormalSignOut; // 签出定位异常时操作 1 2 3  0

@property(nonatomic,strong) NSString <Optional>* photographSignOut; // 是否签出拍照、是否必须上传图片
@property(nonatomic,strong) NSString <Optional>* photosNumberSignOut; // 签出照片数量
@property(nonatomic,strong) NSString <Optional>*photoAlbumSignOut; // 是否允许签出打开相册 1是 0否
@property(nonatomic,strong) NSString <Optional>* soundRecordingSignOut; // 是否签出录音、是否必须上传录音
@property(nonatomic,strong) NSString <Optional>* soundRecordTimeSignOut; // 签出录音时长

@property(nonatomic,strong) NSString <Optional>* recordServiceLength; // 是否记录服务时长
@property(nonatomic,strong) NSString <Optional>* recordMinServiceLength; // 是否记录最低服务时长

@property(nonatomic,strong) NSString <Optional>* minServiceLength; // 最低服务时长  （分）
@property(nonatomic,strong) NSString <Optional>* minServiceLengthLessAbnormal; // 最低服务时长不足时操作 1 2 3 0

@property(nonatomic,strong) NSString <Optional>* recordServiceLengthLess; // 是否记录服务时长不足
@property(nonatomic,strong) NSString <Optional>* serviceLengthLessAbnormal; // 服务时长不足时操作 1 2 3 0

@property(nonatomic,strong) NSString <Optional>* timeConflict; // 等于3或者0 请求新的接口

-(void)saveDetailsModel;
-(AktFindAdvanceModel *)getDetailsModel;

@end


// 服务用户
@interface DownOrderUserInfo : JSONModel
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

NS_ASSUME_NONNULL_END
