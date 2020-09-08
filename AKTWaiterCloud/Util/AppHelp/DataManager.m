//
//  DataManager.m
//  YiShi
//
//  Created by  bea on 15/1/4.
//  Copyright (c) 2015年 maochengfang. All rights reserved.
//

#import "DataManager.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/utsname.h>
#import "Reachability.h"
@implementation DataManager

static DataManager *instance = nil;

+ (DataManager *)newInstance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            instance = [DataManager new];
        }
    }
    return instance;
}
#pragma mark - 邮箱格式
- (BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 正则匹配手机号
- (BOOL)isPhoneNum1:(NSString*)cellPhone {
    NSString *telphone = @"^(1(([357][0-9])|(47)|[8][012356789]))\\d{8}$";
    NSPredicate *telphoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telphone];
    
    return [telphoneTest evaluateWithObject:telNumber];
}

#pragma mark - 正则匹配手机号
- (BOOL)isPhoneNum2:(NSString *)cellPhone {
    NSString *telphone = @"^1+[3578]+\\d{9}";
    NSPredicate *telphoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telphone];
    return [telphoneTest evaluateWithObject:telNumber];
}
/* ^ 匹配一行的开头位置
 (?![0-9]+$) 预测该位置后面不全是数字
 (?![a-zA-Z]+$) 预测该位置后面不全是字母
 [0-9A-Za-z] {6,16} 由6-16位数字或这字母组成
 $ 匹配行结尾位置
 */
- (BOOL)isValidPassword:(NSString *)password {
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

#pragma mark - 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) idCard {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
/*身份证验证 */

- (BOOL)isValidateIdentityCard:(NSString *)identityCard
{
    NSString *card = @"^[1-9]\\d{5}[1-9]\\d{3}(((0[13578]|1[02])(0[1-9]|[12]\\d|3[0-1]))|((0[469]|11)(0[1-9]|[12]\\d|30))|(02(0[1-9]|[12]\\d)))(\\d{4}|\\d{3}[xX])$";
    NSPredicate *identityCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", card];
    return [identityCardTest evaluateWithObject:identityCard];
}
/*车牌号验证 MODIFIED BY HELENSONG*/

- (BOOL)validateCarNo:(NSString* )carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}
//姓名验证
- (BOOL)isChinaName:(NSString *)nameStr
{
    NSString *chinaName = @"^[\u4e00-\u9fa5]{2,4}$";
    NSPredicate *identityCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinaName];
    return [identityCardTest evaluateWithObject:nameStr];
}
//银行卡校验
- (BOOL)checkCardNumber:(NSString *)cardNo
{
    if ((int)cardNo.length < 13 || (int)cardNo.length > 19) return NO;
    NSString *str = [cardNo substringWithRange:NSMakeRange(0, cardNo.length - 1)];
    int luhmSum = 0;
    for(int i = (int)str.length - 1, j = 0; i >= 0; i--, j++) {
        int k = [str characterAtIndex:i] - '0';
        if(j % 2 == 0) {
            k *= 2;
            k = k / 10 + k % 10;
        }
        luhmSum += k;
    }
    char bit = (luhmSum % 10 == 0) ? '0' : (char)((10 - luhmSum % 10) + '0');
    if(bit == 'N'){
        return false;
    }
    return [cardNo characterAtIndex:cardNo.length - 1] == bit;
}

#pragma mark - 验证设备摄像头是否可用
- (BOOL)isDeviceCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];;
}

- (BOOL)isDeviceFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];;
}

#pragma mark - 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 修改界面圆角及灰边
- (void)setRadius:(UIView *)view withCornerRadius:(CGFloat)cornerRadius BorderWidth:(CGFloat)BorderWidth andBorderColor:(CGColorRef)BorderColor
{
    CALayer *layer = [view layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:cornerRadius];
    [layer setBorderWidth:BorderWidth];
    [layer setBorderColor:BorderColor];
}


-(void)setLineSpacing:(UILabel *)view space:(NSInteger)space text:(NSString *)text{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:space];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [view setAttributedText:attributedString1];
}

-(void)rotateAllow:(UIView *)view isShunshizhen:(BOOL)isShunshizhen{
    // 旋转180度
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2]; //动画时长
    
    if (isShunshizhen) {
        view.transform = CGAffineTransformMakeRotation(0*M_PI/180);
    }else{
        // 逆时针
        view.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
    }
    CGAffineTransform transform = view.transform;
    //第二个值表示横向放大的倍数，第三个值表示纵向缩小的程度
    transform = CGAffineTransformScale(transform, 1,1);
    view.transform = transform;
    [UIView commitAnimations];
    
}

-(NSString *)getStringDate:(NSDate *)date dateType:(NSString *)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];      //设置你需要的时间格式
    return [dateFormatter stringFromDate:date];  //格式化date为字符串
}

-(NSDate *)getCurrentDate
{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
}

-(void)saveCache:(NSString *)key value:(NSString *)value
{
    NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:value forKey:key];
    [cache synchronize];
}

-(void)saveBoolCache:(NSString *)key value:(BOOL)value
{
    NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
    [cache setBool:value forKey:key];
    [cache synchronize];
}

-(BOOL)readBoolCache:(NSString *)key
{
    NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
    return [cache boolForKey:key];
}

-(NSString *)readCache:(NSString *)key
{
    NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
    return [cache objectForKey:key];
}

-(void)removeCache:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

-(void)clearCache
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

-(Boolean)checkCache:(NSString *)key
{
    NSString *value = [self readCache:key];
    if (value)
    {
        return true;
    }
    return false;
}

-(void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

-(void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

-(NSString *)imageToBase64:(UIImage *)image
{
    NSData *_data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *_encodedImageStr = [_data base64Encoding];
    return _encodedImageStr;
}

-(UIImage *)base64ToImage:(NSString *)base64
{
    NSData *_decodedImageData = [[NSData alloc] initWithBase64Encoding:base64];
    UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}

//按比例缩放,size 是你要把图显示到 多大区域
-(UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

//指定最大宽度或高度按比例缩放
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width<defineWidth && height<= defineWidth){
        return sourceImage;
    }
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    if(targetHeight > defineWidth){
        targetHeight = defineWidth;
        targetWidth  =  width / (height / targetHeight);
    }
    
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) ==NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)typeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
            
        case 0x89:
            return @"png";
            
        case 0x47:
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            return @"tiff";
    }
    return nil;
}
-(NSString *)intToString:(NSInteger) value
{
    return [NSString stringWithFormat:@"%ld",(long)value];
}


-(UIColor *)rgba:(NSInteger)red green:(NSInteger) green blue:(NSInteger)blue{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

-(UIColor *)rgba_16:(NSString *)colorString{
    NSInteger red = strtoul([[colorString substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    NSInteger green = strtoul([[colorString substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
    NSInteger blue = strtoul([[colorString substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

-(UIColor *)rgba_16:(NSString *)colorString alpha:(CGFloat)alpha{
    NSInteger red = strtoul([[colorString substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    NSInteger green = strtoul([[colorString substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
    NSInteger blue = strtoul([[colorString substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}
#pragma mark - 返回16进制数颜色
- (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

-(NSDate *)stringToDate:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}

-(NSDate *)stringToDate1:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

-(NSDate *)stringToDate2:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [dateFormatter dateFromString:dateString];
}
//获取现在日期
-(NSDate*)getNowDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *datestr= [dateFormatter stringFromDate:[NSDate date]];
    NSDate * date = [dateFormatter dateFromString:datestr];
    return date;
}
// 获取当前时间字符串
- (NSString *)getDateTimeString{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateString);
    return dateString;
}
-(NSString *)getTimeStampFromStr:(NSString*)para{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp;
    if (para.length>=10) {
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:(int)[[para substringToIndex:10] doubleValue]];
    }else{
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:(int)[para doubleValue]];
    }
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
-(NSString *)getTimeStampFromStr2:(NSString*)para{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日-HH:mm"];
    NSDate *confromTimesp;
    if (para.length>=10) {
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:(int)[[para substringToIndex:10] doubleValue]];
    }else{
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:(int)[para doubleValue]];
    }
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
//时间戳转string
- (NSString *)convertToFormatDate:(double)ldate format:(NSString *)format{
    NSString *formatDate = @"";
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:(ldate/1000)];
    //日期格式化
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:format];
    formatDate=[formater stringFromDate:date];
    
    return formatDate;
}
///根据用户输入的时间(dateString)确定当天是星期几,输入的时间格式 yyyy.MM.dd ,如 2015-12-18
- (NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString{
    
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy.M.d"];
    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    return [weekArray objectAtIndex:0];
}
//获取某个日期是星期几
- (NSInteger)getWeek:(NSString*)date {
    NSDate *date11;
    if (!date) {
        date11 = [NSDate date];
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-M-d"];
        date11=[dateFormatter dateFromString:date];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear |
    
    NSCalendarUnitMonth |
    
    NSCalendarUnitDay |
    
    NSCalendarUnitWeekday |
    
    NSCalendarUnitHour |
    
    NSCalendarUnitMinute |
    
    NSCalendarUnitSecond;
    
    
    comps = [calendar components:unitFlags fromDate:date11];
    
    NSInteger week = [comps weekday];
    //    NSString *weekTime=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week-1]];//输出某个时间对应的日期
    return week - 1;
}
//计算两个日期之间的天数
- (NSString*) calcDaysFromBegin:(NSString *)beginDate end:(NSString *)endDate

{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *start = [dateFormatter dateFromString:beginDate];
    NSDate *end =   [dateFormatter dateFromString:endDate];
    
    //取两个日期对象的时间间隔：
    
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    
    NSTimeInterval time=[end timeIntervalSinceDate:start];
    
    
    int days=((int)time)/(3600*24);
    
    //int hours=((int)time)%(3600*24)/3600;
    
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    if (days == 0) {
        return @"0";
    }
    
    return DGIntString(days);
    
}
//获取当前年月日时分秒
- (NSDateComponents*)getDateInfo{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    // 获取各时间字段的数值
    NSLog(@"现在是%ld年" , (long)comp.year);
    NSLog(@"现在是%ld月 " , (long)comp.month);
    NSLog(@"现在是%ld日" , (long)comp.day);
    NSLog(@"现在是%ld时" , (long)comp.hour);
    NSLog(@"现在是%ld分" , (long)comp.minute);
    NSLog(@"现在是%ld秒" , (long)comp.second);
    NSLog(@"现在是星期%ld" , (long)comp.weekday);
    
    return comp;
}
//获取明天日期
- (NSDate *)GetTomorrowDay:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    
    return beginningOfWeek;
}
- (UIView *)changeRectImageToCircleImage:(UIImageView *)image{
    
    CALayer *layer = [image layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:image.frame.size.height/2];
    
    return image;
}

- (NSDate *)changeTime:(NSString *)time
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:time];
    
    return inputDate;
}

//计算距离当前时间
+ (NSString *)countTime:(NSDate *)createTime
{
    //    NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeInterval timeInterval = [createTime timeIntervalSinceNow];
    timeInterval =  -timeInterval;
    
    long temp = 0;
    NSString *result;
    
    if (timeInterval < 60) {
        result = @"刚刚";
    }
    else if ((temp = timeInterval/60)<60)
    {
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if ((temp = temp/60) <24)
    {
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if ((temp = temp/24) <30)
    {
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if  ((temp = temp/30) <12)
    {
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else
    {
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return result;
}

- (NSDate *)formaterDate:(NSString *)time{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:time];
    
    //return [inputFormatter stringFromDate:inputDate];
    return inputDate;
}
- (NSString *)updateTime:(NSString *)paramTime{
    
    if (paramTime.length==0) {
        return @"";
    }
    NSString *dateStr=paramTime;
    NSCalendar *gregorian = [[ NSCalendar alloc ] initWithCalendarIdentifier : NSGregorianCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute ;
    NSDateFormatter *format=[[ NSDateFormatter alloc ] init ];
    [format setDateFormat : @"yyyy/MM/dd HH:mm:ss" ];
    NSDate *fromdate=[format dateFromString :dateStr];
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromdate];
    // DDLog(@"%lu-%lu-%lu-%lu",[components month],[components day],[components hour],[components minute]);
    NSDateComponents *nowComponets = [gregorian components:unitFlags fromDate:[NSDate date]];
    // DDLog(@"%lu-%lu-%lu-%lu",[nowComponets month],[nowComponets day],[nowComponets hour],[nowComponets minute]);
    
    //返回的时间
    NSInteger year = [components year];
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger minute = [components minute];
    NSInteger hour = [components hour];
    
    //今天的时间
    NSInteger nowMonths = [nowComponets month];
    NSInteger nowDays = [nowComponets day];
    //    NSInteger nowMinute = [nowComponets minute];
    //    NSInteger nowHour = [nowComponets hour];
    NSString *strHour = hour < 10?[NSString stringWithFormat:@"0%lu",hour]:[NSString stringWithFormat:@"%lu",hour];
    NSString *strMinute = minute < 10?[NSString stringWithFormat:@"0%lu",minute]:[NSString stringWithFormat:@"%lu",minute];
    NSString *strMonth = months < 10?[NSString stringWithFormat:@"0%lu",months]:[NSString stringWithFormat:@"%lu",months];
    NSString *strDay = days < 10?[NSString stringWithFormat:@"0%lu",days]:[NSString stringWithFormat:@"%lu",days];
    NSString *strYear = year < 10?[NSString stringWithFormat:@"0%lu",year]:[NSString stringWithFormat:@"%lu",year];
    if (months == nowMonths && days == nowDays) {
        dateStr = [NSString stringWithFormat:@"今天 %@:%@",strHour,strMinute];
    }else if (months == nowMonths && (nowDays - days == 1)){
        dateStr = [NSString stringWithFormat:@"昨天 %@:%@",strHour,strMinute];
    }else{
        dateStr = [NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay];
    }
    
    return dateStr;
}
/** 弹出框动画 */
#pragma mark 关键帧动画
-(void)translationAnimation:(UIView *)view{
    
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //2.设置关键帧,这里有四个关键帧
    CATransform3D scale1 = CATransform3DMakeScale(0.0, 0.0, 1);
    //    CATransform3D scale2 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.4, 0.4, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSValue *key1=[NSValue valueWithCATransform3D:scale1];//对于关键帧动画初始值不能省略
    NSValue *key2=[NSValue valueWithCATransform3D:scale2];
    NSValue *key3=[NSValue valueWithCATransform3D:scale3];
    NSValue *key4=[NSValue valueWithCATransform3D:scale4];
    NSArray *values=@[key1,key2,key3,key4];
    
    orbit.duration = 0.5;
    orbit.values = values;
    orbit.keyTimes = @[@0.0f,@0.6f,@0.8f,@1.0f];
    
    orbit.beginTime = CACurrentMediaTime();
    [view.layer addAnimation:orbit forKey:@"orbit"];
    
}

#pragma mark - 取消弹框
-(void)closeAnimation:(UIView *)view delegate:(id)delegate{
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //2.设置关键帧,这里有四个关键帧
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.4, 0.4, 1);
    CATransform3D scale4 = CATransform3DMakeScale(0.0, 0.0, 1);
    
    NSValue *key1=[NSValue valueWithCATransform3D:scale1];//对于关键帧动画初始值不能省略
    NSValue *key2=[NSValue valueWithCATransform3D:scale2];
    NSValue *key3=[NSValue valueWithCATransform3D:scale3];
    NSValue *key4=[NSValue valueWithCATransform3D:scale4];
    NSArray *values=@[key1,key2,key3,key4];
    //    NSArray *values=@[key1,key2,key3];
    
    orbit.duration = 0.4;
    orbit.values = values;
    orbit.delegate = delegate;
    orbit.keyTimes = @[@0.0f,@0.2f,@0.6f,@1.0f];
    orbit.fillMode = kCAFillModeForwards;
    orbit.removedOnCompletion = NO;
    //    orbit.keyTimes = @[@0.0f,@0.2f,@1.0f];
    
    orbit.beginTime = CACurrentMediaTime();
    [view.layer addAnimation:orbit forKey:@"orbit"];
}

- (void)addNoneDataLabel:(UIView *)fatherView{
    UILabel *myLabel = [[UILabel alloc]init];
    myLabel.center = fatherView.center;
    myLabel.text = @"没有数据";
    myLabel.textColor = [self rgba_16:@"494188"];
    [fatherView addSubview:myLabel];
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



//计算出生年月
+(NSInteger)judgeFromStringDateToAge:(NSString *)dateStr andFormat:(NSString *)format{
    NSDate *birthDate = [[DataManager newInstance]stringToDate:dateStr];
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:birthDate];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}
#pragma mark - 动态计算行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)textSize {
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textSize]} context:nil];
//    //返回计算出的行高
//    return ceilf(rect.size.height);
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:textSize]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;

}
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    //返回计算出的行高
    return rect.size.height;

}
#pragma mark - 计算控件宽度
+ (CGFloat)textWidthWithTextString:(NSString *)text withHight:(CGFloat)textHight fontSize:(CGFloat)textSize {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SIZE_MAX, textHight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textSize]} context:nil];
    
    return rect.size.width;
}

//#pragma mark - 字典转Json
//+ (NSString*)dictionaryToJson:(NSDictionary *)dic
//{
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
//    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//}
#pragma mark - 把NSNULL 以及其余的不是NSString的类转化为NSString 类型，如果值为NULL和nil 则返回@""
+(NSString*)ridObject:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    
    if ([object isKindOfClass:[NSNull class]] || object == nil)
    {
        return @"";
    }
    
    return [object description];
}
+ (NSString *)filterNullString:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        if (str==nil) {
            return @"";
        }
        return [NSString stringWithFormat:@"%@",str];
    }
    if (!str) {
        return @"";
    }else if ([str isKindOfClass:[NSNull class]] || [str isEqualToString:@"null"] || [str isEqualToString:@"\"null\""]||[str isEqualToString:@"(null)"]||str==nil) {
        return @"";
    }else {
        return str;
    }
}
//判断空白字符
- (BOOL)isNullString:(NSString *)str
{
    if (str==nil) {
        return YES;
    }else if ([str isKindOfClass:[NSNull class]]){
        return YES;
    }else if ([str isEqual:[NSNull null]]) {
        return YES;
    }else if (str.length==0) {
        return YES;
    }
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [strUrl isEqualToString:@""];
}
#pragma mark - 正常号转银行卡号 － 增加4位间的空格
-(NSString *)normalNumToBankNum:(NSString *)bankNumberStr
{
    NSString *tmpStr = [self bankNumToNormalNum:bankNumberStr];
    
    NSInteger size = (tmpStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}

#pragma mark - 银行卡号转正常号 － 去除4位间的空格
-(NSString *)bankNumToNormalNum:(NSString *)bankNumberStr
{
    return [bankNumberStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}


#pragma mark - 添加千分位符号标识
- (NSString *)countNumAndChangeformat:(NSString *)num {
    //整数
    NSString* str11;
    //小数点之后的数字
    NSString* str22;
    
    if ([num containsString:@"."]) {
        NSArray* array = [num componentsSeparatedByString:@"."];
        str11 = array[0];
        str22 = array[1];
    }else {
        str11 = num;
    }
    
    int count = 0;
    long long int a = str11.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:str11];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    if ([num containsString:@"."]) {
        //包含小数点
        //返回的数字
        NSString* str33;
        if (str22.length > 0) {
            //小数点后面有数字
            str33 = [NSString stringWithFormat:@"%@.%@",newstring,str22];
        }else {
            //没有数字
            str33 = [NSString stringWithFormat:@"%@",newstring];
        }
        return str33;
    }else {
        //不包含小数点
        return newstring;
    }
}
#pragma mark - MD5加密
- (NSString *)md5StringForString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    
    return [ret lowercaseString];
}
- (NSString *)countNumAndChangeformat:(NSString *)num withDecimal:(int)decimalNumber{
    if (num == nil || ![num isKindOfClass:[NSString class]])
        num = @"0";
    //NSString
    NSString *formatStr1 = [NSString stringWithFormat:@"%df", decimalNumber];
    NSString *formatStr2 = [@"%." stringByAppendingString:formatStr1];
    return [self countNumAndChangeformat:[NSString stringWithFormat:formatStr2, [num doubleValue]]];
}
#pragma mark - 获取系统版本号
- (float)getIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
//获取手机uuid，作为rand
+(NSString*)rand_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    
    CFRelease(uuid_string_ref);
    
    return uuid;
    
}
#pragma mark - 获取应用版本
- (NSString *)getAppInfoVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - 获取应用Build版本
- (NSString *)getAppInfoBuild {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
//获得系统信息
- (NSMutableDictionary *)getdeviceInfo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //    NSString * strModel  = [UIDevice currentDevice].model;
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *deviceName = [self changeDeviceList:deviceString];
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    [dic setValue:deviceName forKey:@"model"];
    [dic setValue:iosVersion forKey:@"osversion"];
    [dic setValue:@"Apple" forKey:@"brand"];
//    DLog(@"%@",dic);
    return dic;
}
- (NSString *)changeDeviceList:(NSString *)deviceString{
    NSString *deviceName = nil;
    //iphone设备
    if ([deviceString isEqualToString:@"iPhone1,1"]) {
        deviceName = @"iphone";
    }else if ([deviceString isEqualToString:@"iPhone1,2"]){
        deviceName = @"iPhone 3G";
    }else if ([deviceString isEqualToString:@"iPhone2,1"]){
        deviceName = @"iPhone 3GS";
    }else if ([deviceString isEqualToString:@"iPhone3,1"] ||
              [deviceString isEqualToString:@"iPhone3,2"] ||
              [deviceString isEqualToString:@"iPhone3,3"]){
        deviceName = @"iPhone 4";
    }else if ([deviceString isEqualToString:@"iPhone4,1"]){
        deviceName = @"iPhone 4S";
    }else if ([deviceString isEqualToString:@"iPhone5,1"] ||
              [deviceString isEqualToString:@"iPhone5,2"]){
        deviceName = @"iPhone 5";
    }else if ([deviceString isEqualToString:@"iPhone5,3"] ||
              [deviceString isEqualToString:@"iPhone5,4"]){
        deviceName = @"iPhone 5C";
    }else if ([deviceString isEqualToString:@"iPhone6,1"] ||
              [deviceString isEqualToString:@"iPhone6,2"]){
        deviceName = @"iPhone 5S";
    }else if ([deviceString isEqualToString:@"iPhone7,1"]){
        deviceName = @"iPhone 6Plus";
    }else if ([deviceString isEqualToString:@"iPhone7,2"]){
        deviceName = @"iPhone 6";
    }else if ([deviceString isEqualToString:@"iPhone8,1"]){
        deviceName = @"iPhone 6s";
    }else if ([deviceString isEqualToString:@"iPhone8,2"]){
        deviceName = @"iPhone 6sPlus";
    }else if ([deviceString isEqualToString:@"iPod1,1"]){
        deviceName = @"iPod touch1";
    }else if ([deviceString isEqualToString:@"iPod2,1"]){
        deviceName = @"iPod touch2";
    }else if ([deviceString isEqualToString:@"iPod3,1"]){
        deviceName = @"iPod touch3";
    }else if ([deviceString isEqualToString:@"iPod4,1"]){
        deviceName = @"iPod touch4";
    }else if ([deviceString isEqualToString:@"iPod5,1"]){
        deviceName = @"iPod touch5";
    }else{
        deviceName = @"iPad";
    }
    return deviceName;
}
//获取当前系统时间戳
-(NSTimeInterval)getCurrentTimeInterval{
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
   // NSTimeInterval now=[[NSDate date]timeIntervalSince1970];
//    int timeInt = now - nowTimeinterval; //时间差
//    int hour = timeInt / 3600;
//    if (hour<1) {
//        //y小时以内
//    }
    return nowTimeinterval;
}
- (NSURL *)jionTogetherWithString:(NSString *)urlString{
    if (!urlString) {
        return nil;
    }
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    return url;
}
-(NSString*)getPhoneStringFromSystem:(NSString*)phoneStr{
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return phoneStr;
}

-(BOOL)currentNetwork{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            //  NSLog(@"正在使用wifi网络");
            break;
    }
    return isExistenceNetwork;
}
//图片居中截取
-(void)imgCenterSub:(UIImageView *)imgView{
    [imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    //    imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imgView.clipsToBounds = YES;
}
- (NSComparisonResult)compare: (NSDictionary *)otherDictionary{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
    NSNumber *number2 = [[otherDictionary allKeys] objectAtIndex:0];
    
    NSComparisonResult result = [number1 compare:number2];
    
    return result == NSOrderedDescending; // 升序
    //    return result == NSOrderedAscending;  // 降序
}

- (NSString *)stringToSpaceInPhoneNum:(NSString *)phone{
    if (!phone) {
        return @"";
    }
    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:phone];
    [tmpString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tmpString.length)];
    //    139 1697 0340
    if ([tmpString length] > 3) {
        [tmpString insertString:@" " atIndex:3];
    }
    if ([tmpString length] > 8) {
        [tmpString insertString:@" " atIndex:8];
    }
    return tmpString;
}
- (NSString *)stringToSpaceInCardNum:(NSString *)card{
    if (!card) {
        return @"";
    }
    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:card];
    [tmpString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tmpString.length)];
    //    139 1697 0340
    //    6222 0210 0112 2937 680
    if ([tmpString length] > 4) {
        [tmpString insertString:@" " atIndex:4];
    }
    if ([tmpString length] > 9) {
        [tmpString insertString:@" " atIndex:9];
    }
    if ([tmpString length] > 14) {
        [tmpString insertString:@" " atIndex:14];
    }
    if ([tmpString length] > 19) {
        [tmpString insertString:@" " atIndex:19];
    }
    return tmpString;
}

- (NSString *)stringToEmptySpaceInPhoneNum:(NSString *)phone{
    if (!phone) {
        return @"";
    }
    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:phone];
    [tmpString replaceOccurrencesOfString:@" "
                               withString:@""
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, tmpString.length)];
    return tmpString;
}
+(void)hideKeyboard{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
//限制小数点后2位,限制一位小数点
- (NSString *)limitDot:(NSString*)content{
    if([content rangeOfString:@"."].location != NSNotFound){
        NSArray *list = [content componentsSeparatedByString:@"."];
        if (list.count>2) {
            content = [content substringToIndex:content.length-1];
        }
        else if ([list.lastObject length] > 2) {
            content = [content substringToIndex:content.length-1];
        }
        else if ([list.firstObject isEqual:@""]){
            content = [content substringToIndex:content.length-1];
        }
    }
    return content;
}
//获取地址文件
- (NSMutableArray *)getAddressJsonData{
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    //从plist中获取数组和字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"xml"];
    NSString *str = [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSDictionary *areaDic = [listDic objectForKey:@"list"];
    provinceArray = [areaDic objectForKey:@"province"];
    
    return provinceArray;
}
//计算富文本(NSMutableAttributedString)高度
- (NSInteger)hideLabelLayoutHeight:(NSMutableAttributedString *)attributes width:(NSInteger)width
{
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attSize.height;
}
//行间距
- (NSMutableAttributedString*)lineParagraph:(int)distance content:(NSString*)content{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:distance];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, content.length)];
    //llContent.attributedText = attributedString;
    return attributedString;
}
//延迟调用
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}
//获取父viewcontroller
- (UIViewController *)topVC:(UIViewController *)rootViewController{
    
    if (!rootViewController) {
        rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navc = (UINavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}
//空数据视图
- (UIView *)creatNullViewByImageName:(NSString *)imageName frame:(CGRect)frame titleStr:(NSString *)titleStr
{
    UIView *nullView = [[UIView alloc]initWithFrame:frame];
    [nullView setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *nullIcon = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-81)/2,(frame.size.height-220)/2,81,81)];
    [nullIcon setImage:image];
    [nullView addSubview:nullIcon];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, nullIcon.frame.size.height+nullIcon.frame.origin.y+15, frame.size.width, 20)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = titleStr;
    [nullView addSubview:titleLab];
    
    return nullView;
}
- (NSString *)getPinyinFirst:(NSString *)pinyin{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:pinyin];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    //    if (pinyin.length!=0) {
    //        return [pinYin substringToIndex:1];
    //
    //    }
    
    NSString *firstStr = [pinYin substringToIndex:1]?[pinYin substringToIndex:1]:@"";
    NSString *regex = @"[a-zA-z]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:firstStr] == YES) {
    }else{
        firstStr = @"#";
    }
    
    return firstStr;
}
#pragma mark =====数值计算

- (NSDecimalNumber*)Multiplying:(NSString*)parm1 parm2:(NSString*)parm2
{
    if (parm1 == nil || [parm1 isEqualToString:@""])
    {
        parm1 = @"0";
    }
    if (parm2 == nil || [parm2 isEqualToString:@""])
    {
        parm2 = @"0";
    }
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:parm1];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:parm2];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *resultNumber=[dparm1 decimalNumberByMultiplyingBy:dparm2];
    return [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
}


//保留小数 并四舍五入
- (float)decimalNumberByRoundingAccordingToBehavior:(NSString*)parm withPrecision:(NSInteger)precision{
    if (parm==nil||[parm isEqualToString:@""]||[parm isEqualToString:@"0"]) {
        parm=@"0";
    }
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *roudUpMoney = [[NSDecimalNumber decimalNumberWithString:parm] decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [roudUpMoney floatValue];
}
- (float)decimalNumberBySubtracting:(NSString*) param1 WithParam2:(NSString*)param2 withParam3:(NSString*)param3 withPrecision:(NSInteger)precision{
    if (param1==nil||[param1 isEqualToString:@""]||[param1 isEqualToString:@"0"]) {
        param1=@"0";
    }
    if (param2 == nil || [param2 isEqualToString:@""]||[param2 isEqualToString:@"0"])
    {
        param2 = @"0";
    }
    if (param3 == nil || [param3 isEqualToString:@""]||[param3 isEqualToString:@"0"])
    {
        param3 = @"0";
    }
    
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:param1];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:param2];
    NSDecimalNumber *dparm3=[NSDecimalNumber decimalNumberWithString:param3];
    NSDecimalNumber *resultNumber=[[dparm1 decimalNumberByMultiplyingBy:dparm2] decimalNumberBySubtracting:dparm3];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *roudUpMoney = [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [roudUpMoney floatValue];
    
}
- (float)decimalNumberSubtractAndMultiplaying:(NSString*) param1 WithParam2:(NSString*)param2 withParam3:(NSString*)param3  withPrecision:(NSInteger)precision{
    if (param1==nil||[param1 isEqualToString:@""]||[param1 isEqualToString:@"0"]) {
        param1=@"0";
    }
    if (param2 == nil || [param2 isEqualToString:@""]||[param2 isEqualToString:@"0"])
    {
        param2 = @"0";
    }
    if (param3 == nil || [param3 isEqualToString:@""]||[param3 isEqualToString:@"0"])
    {
        param3 = @"0";
    }
    
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:param1];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:param2];
    NSDecimalNumber *dparm3=[NSDecimalNumber decimalNumberWithString:param3];
    NSDecimalNumber *resultNumber=[[dparm1 decimalNumberBySubtracting:dparm2] decimalNumberByMultiplyingBy:dparm3];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *roudUpMoney = [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [roudUpMoney floatValue];
}
- (float)multiplyingTowFloat:(NSString*)parm1 param2:(NSString*)parm2 withPrecision:(NSInteger)precision{
    if (parm1 == nil || [parm1 isEqualToString:@""]||[parm1 isEqualToString:@"0"])
    {
        parm1 = @"0";
    }
    if (parm2 == nil || [parm2 isEqualToString:@""]||[parm2 isEqualToString:@"0"])
    {
        parm2 = @"0";
    }
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:parm1];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:parm2];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *resultNumber=[dparm1 decimalNumberByMultiplyingBy:dparm2];
    NSDecimalNumber *roudUpMoney = [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    
    return [roudUpMoney floatValue];
}
//先除在保留小数
- (float)decimalNumberByDividingBy:(NSString*)param1 WithParam2:(NSString*)param2 WithPrecision:(NSInteger)precision{
    if (param1 == nil || [param1 isEqualToString:@""]||[param1 isEqualToString:@"0"])
    {
        param1 = @"0";
    }
    if (param2 == nil || [param2 isEqualToString:@""]||[param2 isEqualToString:@"0"])
    {
        param2 = @"0";
    }
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:param1];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:param2];
    NSDecimalNumber *resultNumber=[dparm1 decimalNumberByDividingBy:dparm2];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *roudUpMoney = [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [roudUpMoney floatValue];
}
//减然后在保留两位小数
- (float)decimalSubtracting:(NSString*)param withParam:(NSString*)param1 WithPrecison:(NSInteger)precision{
    if (param == nil || [param isEqualToString:@""]||[param isEqualToString:@"0"])
    {
        param = @"0";
    }
    if (param1 == nil || [param1 isEqualToString:@""]||[param1 isEqualToString:@"0"])
    {
        param1 = @"0";
    }
    
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:param];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:param1];
    NSDecimalNumber *resultNumber=[dparm1 decimalNumberBySubtracting:dparm2];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *roudUpMoney = [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [roudUpMoney floatValue];
    
}
//加然后保留小数
- (float)decimalNumberByAdding:(NSString*)param1 withPram:(NSString*)param2 withPrecison:(NSInteger)precision{
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:param1];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:param2];
    NSDecimalNumber *resultNumber=[dparm1 decimalNumberByAdding:dparm2];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *roudUpMoney = [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [roudUpMoney floatValue];
    
}
//先减在加
- (float)decimalNumberSubtractAndAdd:(NSString*)param1 withPram1:(NSString*)param2 withParam2:(NSString*)param3 withPrecison:(NSInteger)precision{
    NSString *str=[NSString stringWithFormat:@"%@",param3];
    if (param1 == nil || [param1 isEqualToString:@""]||[param1 isEqualToString:@"0"])
    {
        param1 = @"0";
    }
    if (param2 == nil || [param2 isEqualToString:@""]||[param2 isEqualToString:@"0"])
    {
        param2 = @"0";
    }else if (param3 == nil || [param3 isEqualToString:@""]||[param3 isEqualToString:@"0"]||param3.length==0||[str isKindOfClass:[NSNull class]] || [str isEqualToString:@"null"] || [str isEqualToString:@"\"null\""]||[str isEqualToString:@"(null)"]||str==nil){
        param3=@"0";
    }
    NSDecimalNumber *dparm1= [NSDecimalNumber decimalNumberWithString:param1];
    NSDecimalNumber *dparm2=[NSDecimalNumber decimalNumberWithString:param2];
    NSDecimalNumber *dparm3=[NSDecimalNumber decimalNumberWithString:param3];
    NSDecimalNumber *resultNumber=[[dparm1 decimalNumberBySubtracting:dparm2]decimalNumberByAdding:dparm3];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:precision
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *roudUpMoney = [resultNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [roudUpMoney floatValue];
}

//日期比较 如果没达到指定日期，返回-1，刚好是这一时间，返回0，否则返回1
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}
// 读取本地JSON文件
//- (NSArray *)readLocalFileWithName:(NSString *)name {
//    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"json"]];
//    
//    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
//    
//    return dataArray;
//}
@end
