//
//  DataManager.h
//  YiShi
//
//  Created by  bea on 15/1/4.
//  Copyright (c) 2015年 maochengfang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_NAME [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"book.sqlite"]
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


//[docPath stringByAppendingPathComponent:@"Class.db"];
#define DATE_YEAR_MONTH_DAY_HOUR_MINUTE @"yyyy-MM-dd HH:mm"
#define DATE_YEAR_MONTH_DAY_HOUR_MINUTE_SS @"yyyy-MM-dd HH:mm:ss"
#define DATE_YEAR_MONTH_DAY @"yyyy-MM-dd"
#define DATE_YEAR_MONTH_DAY_CHINA @"yyyy年MM月dd日"
#define DATE_MONTH_DAY @"MM-dd"
#define DATE_DAY @"dd"
#define DATE_MONTH @"MM"
#define DATE_YEAR @"yyyy"
#define DATE_WEEK_INDEX @"e" // 获取当前日期是星期几 星期天是1，然后依次到7

#define DATE_YEAR_MONTH_DAY_HOUR_MINUTE_SS @"yyyy-MM-dd HH:mm:ss"


/** S_开头：NSString B_开头：BOOL I_开头：NSInteger 无开头默认作为NSString处理*/
#define B_CACHE_OPEN_FREE_TO_NIGHT @"b_cache_open_free_to_night" // 是否开启了今晚我有空

@interface DataManager : NSObject<UIAlertViewDelegate>
{
//    MBProgressHUD *progress;
    UIViewController *vc;
    
    /// 自定义加载进度条
//    LoadingView *_customLoadingView;
}

+ (DataManager *)newInstance; // 初始化
#pragma mark ==正则验证
//邮箱格式
- (BOOL)isEmail:(NSString *)email;

//正则匹配手机号
- (BOOL)isPhoneNum1:(NSString*)cellPhone;

//正则匹配手机号
- (BOOL)isPhoneNum2:(NSString*)cellPhone;

//密码格式
- (BOOL)isValidPassword:(NSString *)password;

//正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) idCard;
//身份证验证
- (BOOL)isValidateIdentityCard:(NSString *)identityCard;

//车牌号验证
- (BOOL)validateCarNo:(NSString* )carNo;
//姓名验证
- (BOOL)isChinaName:(NSString *)nameStr;
//银行卡校验
- (BOOL)checkCardNumber:(NSString*)cardNum;



//验证设备摄像头是否可用
- (BOOL)isDeviceCameraAvailable;
- (BOOL)isDeviceFrontCameraAvailable;
// 相册是否可用
- (BOOL)isPhotoLibraryAvailable;
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string;

/** 时间数据管理 **/
-(NSString *)getStringDate:(NSDate *)date dateType:(NSString *)type; // 获得选择时间字符串
-(NSDate *)getCurrentDate; // 获得当前时间
-(NSDate *)stringToDate:(NSString *)dateString; // string转date
-(NSDate *)stringToDate1:(NSString *)dateString;//string转date yyyy-MM-dd HH:mm:ss
-(NSDate *)stringToDate2:(NSString *)dateString;//string转date yyyy-MM-dd HH:mm:ss.SSS
//获取现在日期
-(NSDate*)getNowDate;
//获取当前系统时间戳
-(NSTimeInterval)getCurrentTimeInterval;
// 获取当前时间字符串
- (NSString *)getDateTimeString;
//时间戳-时间字符串
-(NSString *)getTimeStampFromStr:(NSString*)para;
-(NSString *)getTimeStampFromStr2:(NSString*)para;
//时间戳转string
- (NSString *)convertToFormatDate:(double)ldate format:(NSString *)format;
//根据用户输入的时间(dateString)确定当天是星期几,输入的时间格式 yyyy.MM.dd ,如 2015-12-18
-(NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString;
//获取某个日期是星期几
-(NSInteger)getWeek:(NSString*)date;
//计算两个日期之间的天数
- (NSString*) calcDaysFromBegin:(NSString *)beginDate end:(NSString *)endDate;
//获取当前年月日时分秒
- (NSDateComponents*)getDateInfo;
//获取明天日期
- (NSDate *)GetTomorrowDay:(NSDate *)aDate;
/**  时间转换   */
- (NSDate *)changeTime:(NSString *)time;
+ (NSString *)countTime:(NSDate *)createTime;

- (NSDate *)formaterDate:(NSString *)time;
//显示昨天几点  今天几点
- (NSString*)updateTime:(NSString*)paramTime;


/** 缓存数据管理 **/
-(void)saveCache:(NSString *)key value:(NSString *)value; // 缓存数据
-(void)saveBoolCache:(NSString *)key value:(BOOL)value;
-(NSString *)readCache:(NSString *)key; // 读取数据
-(BOOL)readBoolCache:(NSString *)key;
-(void)removeCache:(NSString *)key; // 删除某个缓存
-(void)clearCache; // 清除全部缓存
-(Boolean)checkCache:(NSString *)key; // 判断是否有缓存数据

/** 消息提示框管理 **/
-(void)showAlert:(NSString *) _message;// 弹出框
-(void)timerFireMethod:(NSTimer*)theTimer;// 时间

/** 数据类型转换 */
-(NSString *)intToString:(NSInteger) value; // NSInteger快速转成string
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString; // json转字典
-(NSString*)dictionaryToJson:(NSDictionary *)dic; // 字典转json


/** base64 */
-(NSString *)imageToBase64:(UIImage *)image; // image转base64
-(UIImage *)base64ToImage:(NSString *)base64; // base64转image

/** 其他 */
//-(void)againLogin:(UIViewController *)controller state:(NSString *)stateCode;

/** Color相关 */
//-(UIImage *)urlToUIImage:(NSString *)url; // url转uiimage
-(UIColor *)rgba:(NSInteger)red green:(NSInteger) green blue:(NSInteger)blue; // 获取自定义色值颜色
-(UIColor *)rgba_16:(NSString *)colorString; // 将16进制转成uicolor
-(UIColor *)rgba_16:(NSString *)colorString alpha:(CGFloat)alpha;
//返回16进制数颜色
- (UIColor *)colorWithHexString: (NSString *)color;
-(UIImage*) createImageWithColor:(UIColor*) color; // 颜色转图片


/** image转换成圆形 */
- (UIView *)changeRectImageToCircleImage:(UIImageView *)image;
/** 修改界面圆角 */
- (void)setRadius:(UIView *)view withCornerRadius:(CGFloat)cornerRadius BorderWidth:(CGFloat)BorderWidth andBorderColor:(CGColorRef)BorderColor;
/* 设置行间距 */
-(void)setLineSpacing:(UILabel *)view space:(NSInteger)space text:(NSString *)text;

-(void)rotateAllow:(UIView *)view isShunshizhen:(BOOL)isShunshizhen; // 箭头上下翻转动画



/** 弹出框动画 */
- (void)translationAnimation:(UIView *)view;
- (void)closeAnimation:(UIView *)view delegate:(id)delegate;

/** 添加没有数据Label  */
- (void)addNoneDataLabel:(UIView *)fatherView;


+(NSInteger)judgeFromStringDateToAge:(NSString *)dateStr andFormat:(NSString *)format;
#pragma mark - 动态计算行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)textSize;
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;
#pragma mark - 计算控件宽度
+ (CGFloat)textWidthWithTextString:(NSString *)text withHight:(CGFloat)textHight fontSize:(CGFloat)textSize;


#pragma mark - 把NSNULL 以及其余的不是NSString的类转化为NSString 类型，如果值为NULL和nil 则返回@""
+ (NSString*)ridObject:(id)object;

+ (NSString *)filterNullString:(NSString *)str;

//判断空白字符
- (BOOL)isNullString:(NSString *)str;
#pragma mark - 正常号转银行卡号 － 增加4位间的空格
-(NSString *)normalNumToBankNum:(NSString *)bankNumberStr;

#pragma mark - 银行卡号转正常号 － 去除4位间的空格
-(NSString *)bankNumToNormalNum:(NSString *)bankNumberStr;


#pragma mark - 添加千分位符号标识
- (NSString *)countNumAndChangeformat:(NSString *)num;
#pragma mark - 添加千分位符号标识, 并指定保留几位小数
- (NSString *)countNumAndChangeformat:(NSString *)num withDecimal:(int)decimalNumber;

#pragma mark - MD5加密
- (NSString *)md5StringForString:(NSString *)string;

/**图片处理*/
//按比例缩放,size 是你要把图显示到 多大区域
-(UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;

//指定最大宽度或高度按比例缩放
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//获取图片类型
- (NSString *)typeForImageData:(NSData *)data;
//获取手机uuid
- (NSString*)rand_uuid;
//获取系统版本号
- (float)getIOSVersion;
//获取应用版本
- (NSString *)getAppInfoVersion;

//获取应用Build版本
- (NSString *)getAppInfoBuild;
/*
 *  获得系统信息
 */
- (NSMutableDictionary *)getdeviceInfo;



/*
 *  方法：jionTogetherWithString: 将字符串转化为url
 *  输入参数：urlString字符串
 *  输出参数：N/A
 *  返回值：  （NSURL *）图片地址
 */
- (NSURL *)jionTogetherWithString:(NSString *)urlString;

/*
 *  除去系统通讯号码的特殊字符
 */
-(NSString *)getPhoneStringFromSystem:(NSString*)phoneStr;
/*
 *  方法：CallPhoneWithNum:
 bgView: 拨打电话
 
 *  输入参数：   phoneNum：  电话号码
 bgView： 背景视图
 *  输出参数：N/A
 *  返回值：  N/A
 */
//-(void)CallPhoneWithNum:(NSString *)phoneNum bgView:(UIView *)bgView;
//当前网络
-(BOOL)currentNetwork;
//图片居中截取
-(void)imgCenterSub:(UIImageView *)imgView;
//排序
-(NSComparisonResult)compare:(NSDictionary *)otherDictionary;
/*
 *  方法：stringToSpaceInPhoneNum: 给手机号添加空格处理
 *  输入参数：phone手机号字符串
 *  输出参数：N/A
 *  返回值： 加上空格之后的字符串
 */
- (NSString *)stringToSpaceInPhoneNum:(NSString *)phone;

/*
 *  方法：stringToSpaceInCardNum: 给卡号添加空格处理
 *  输入参数：card卡号字符串
 *  输出参数：N/A
 *  返回值： 加上空格之后的字符串
 */
- (NSString *)stringToSpaceInCardNum:(NSString *)card;

/*
 *  方法：stringToEmptySpaceInPhoneNum: 给手机号中的空格处理
 *  输入参数：phone手机号字符串
 *  输出参数：N/A
 *  返回值： 去掉空格之后的字符串
 */
- (NSString *)stringToEmptySpaceInPhoneNum:(NSString *)phone;
//隐藏键盘
+(void)hideKeyboard;

//限制小数点后2位
- (NSString *)limitDot:(NSString*)content;
//获取地址文件
- (NSMutableArray *)getAddressJsonData;
//计算富文本(NSMutableAttributedString)高度
- (NSInteger)hideLabelLayoutHeight:(NSMutableAttributedString *)attributes width:(NSInteger)width;
//行间距
- (NSMutableAttributedString*)lineParagraph:(int)distance content:(NSString*)content;
//延迟调用
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

//获取父viewcontroller
- (UIViewController *)topVC:(UIViewController *)rootViewController;

//空数据视图
- (UIView *)creatNullViewByImageName:(NSString *)imageName frame:(CGRect)frame titleStr:(NSString *)titleStr;
- (NSString *)getPinyinFirst:(NSString *)pinyin; // 获取拼音首字母

#pragma mark =====数值计算

//两个字符串用Decimal类型相乘
- (NSDecimalNumber*)Multiplying:(NSString*)parm1 parm2:(NSString*)parm2;
//保留小数 并四舍五入
- (float)decimalNumberByRoundingAccordingToBehavior:(NSString*)parm withPrecision:(NSInteger)precision;
//先乘在想减 然后在保留小数并且四舍五入
- (float)decimalNumberBySubtracting:(NSString*) param1 WithParam2:(NSString*)param2 withParam3:(NSString*)param3  withPrecision:(NSInteger)precision;
//先减在乘 保留小数 四舍五入
- (float)decimalNumberSubtractAndMultiplaying:(NSString*) param1 WithParam2:(NSString*)param2 withParam3:(NSString*)param3  withPrecision:(NSInteger)precision;
//乘在保留两位小数
- (float)multiplyingTowFloat:(NSString*)parm1 param2:(NSString*)parm2 withPrecision:(NSInteger)precision;
//除在保留小数
- (float)decimalNumberByDividingBy:(NSString*)param1 WithParam2:(NSString*)param2 WithPrecision:(NSInteger)precision;
//减然后在保留两位小数
- (float)decimalSubtracting:(NSString*)param withParam:(NSString*)param1 WithPrecison:(NSInteger)precision;
//加然后保留小数
- (float)decimalNumberByAdding:(NSString*)param1 withPram:(NSString*)param2 withPrecison:(NSInteger)precision;
//先减在加
- (float)decimalNumberSubtractAndAdd:(NSString*)param1 withPram1:(NSString*)param2 withParam2:(NSString*)param3 withPrecison:(NSInteger)precision;

//读取json
- (NSDictionary *)readLocalFileWithName:(NSString *)name;

//日期比较 如果没达到指定日期，返回-1，刚好是这一时间，返回0，否则返回1
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
@end
