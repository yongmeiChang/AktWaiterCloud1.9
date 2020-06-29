//
//  SigninController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/2.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "SignoutController.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "PhotoCell.h"
#import "FileManagerUtil.h"
#import <LxGridView.h>
#import <LxGridViewCell.h>
#import "SaveDocumentArray.h"
#import <math.h>
//#import "CheckInJudge.h"
#import "AppInfoDefult.h"
#import "SinoutReasonView.h" // 提交失败的原因
#import "AktWCMp3.h" // 录音
#import "AddWaterMark.h" // 水印

#define PI 3.1415926
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface SignoutController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,SinoutreasonDelegate,AMapLocationManagerDelegate,AMapSearchDelegate> {
    
    long unservicetime;//记录服务时长不足的时间 秒
    
    long SSunservicetime;//记录服务时长不足毫秒gr
    long leaveIntime;//迟到时间毫秒
    long leaveOuttime;//早退时间毫秒
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    BOOL isclick;
    NSTimer *timer;
    int longtime;

    NSString * isLess; // 时长是否正常 0正常  1不正常
    SinoutReasonView *reasonView; // 提交失败的原因 弹框
    
    LoginModel *model;
    BOOL isPostLocation; // yes刷新定位完成； No刷新定位失败
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) LxGridView *collectionView;//选取图片按钮界面
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *nowdate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollviewBg;
@property (weak, nonatomic) IBOutlet UIView *postPictrueView;  // 上传图片背景图
@property (weak,nonatomic) IBOutlet UIView * lcView;//流程视图
@property (weak, nonatomic) IBOutlet UIView *serviceInfoView;//服务内容视图
@property (weak, nonatomic) IBOutlet UIView *locationInfoView; // 签入 签出情况视图
@property (weak, nonatomic) IBOutlet UIView *addressInfoView;// 地址 视图


@property (weak, nonatomic) IBOutlet UILabel *serviceTimeTitleLab; // 服务时长标题
@property (weak, nonatomic) IBOutlet UIButton *btnServiceLength; //服务时长icon
@property (weak,nonatomic) IBOutlet UILabel * ShowSingOutServiceTimelabel;//服务时长
@property (weak,nonatomic) IBOutlet UILabel * checklabel;
@property (weak,nonatomic) IBOutlet UILabel * latelabel;  // 出勤状态
@property (weak,nonatomic) IBOutlet UILabel * distanceLabel;// 距离
@property (weak,nonatomic) IBOutlet UILabel * timerLabel;//显示读秒
@property (weak,nonatomic) IBOutlet UILabel * addressLabel;//显示地址
@property (weak,nonatomic) IBOutlet UIButton * trapBtn;//录音按钮
@property (weak,nonatomic) IBOutlet UIButton * submitBtn;//提交按钮
@property (weak,nonatomic) IBOutlet UITextView * textview;//备注
@property (weak,nonatomic) IBOutlet UITextField * lctitleTextField;//流程视图
@property (weak,nonatomic) IBOutlet UITextView * lccontentTextView;//流程视图
@property (weak,nonatomic) IBOutlet UIButton * lcBtn;//流程视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictrueTop; // 去除导航栏高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewAddressHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnPostHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnPostWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollH;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic,strong) AMapLocationManager * unfinishManager; // 地址管理
@property (nonatomic,strong) AMapSearchAPI * searchAPI;  // 逆地理编码
@property (nonatomic,strong) NSString * locaitonLatitude;//定位的当前坐标
@property (nonatomic,strong) NSString * locaitonLongitude;//定位的当前坐标
@property (nonatomic,strong) NSString * statusPost;   // 状态  2020、2、27 更改提交数据
@property (nonatomic,strong) NSString * distancePost; // 距离 单位米


@end

@implementation SignoutController

-(id)initSignoutControllerWithOrderInfo:(OrderInfo *)orderinfo{
    if(self = [super init]){
        self.orderinfo = orderinfo;
        return self;
    }else{
        return nil;
    }
}

//相册
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}
#pragma mark - init
-(void)refurbishBtnClick{
    //1.将两个经纬度点转成投影点
    MAMapPoint pointStart = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.orderinfo.serviceLocationY doubleValue],[self.orderinfo.serviceLocationX doubleValue])); // 地址位置
    MAMapPoint pointEnd = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.locaitonLatitude doubleValue],[self.locaitonLongitude doubleValue])); //用户当前位置
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(pointStart,pointEnd);
    [self distanceBetween:distance];
}

- (void)configLocationManager
{
    self.unfinishManager = [[AMapLocationManager alloc] init];
    
    [self.unfinishManager setDelegate:self];
    
    //设置期望定位精度
    [self.unfinishManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.unfinishManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.unfinishManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.unfinishManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.unfinishManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}
- (void)initCompleteBlock
{
    __weak SignoutController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            weakSelf.orderinfo.isAbnormal = @"1";
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%ld-%@",(long)error.code,error.localizedDescription]];
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            weakSelf.orderinfo.isAbnormal = @"1";
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%ld-%@",(long)error.code,error.localizedDescription]];
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            weakSelf.orderinfo.isAbnormal = @"1";
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%ld-%@",(long)error.code,error.localizedDescription]];
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
            weakSelf.locaitonLatitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude]; // 当前位置 经度
            weakSelf.locaitonLongitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude]; // 当前位置 纬度
        }
        //修改label显示内容
        if (regeocode)
        {
            weakSelf.orderinfo.isAbnormal = @"0";
            [weakSelf.addressLabel setText:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            //返回用户经纬度，计算两点间的距离
            [weakSelf refurbishBtnClick];
        }

    };
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.netWorkErrorView.hidden = YES;
    self.lctitleTextField.delegate = self;
    self.lccontentTextView.delegate = self;
    self.lccontentTextView.layer.borderWidth=1.0f;
    self.lccontentTextView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.textview.delegate = self;

    model = [LoginModel gets];
    
    if(self.type==0){
        [self setTitle:@"任务签入"];
        self.trapBtn.hidden = YES;
        self.btnPostWidth.constant = SCREEN_WIDTH;
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        self.scrollH.constant = 50;
    }else{
        [self setTitle:@"任务签出"];
        self.checklabel.text = @"签出情况";
        self.trapBtn.hidden = NO;
        self.btnServiceLength.hidden = NO;
        self.serviceTimeTitleLab.hidden = NO;
        self.ShowSingOutServiceTimelabel.hidden = NO;
        self.viewAddressHeightConstraint.constant = 137;
        self.btnPostWidth.constant = SCREEN_WIDTH/2;
         [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"singOut"] forState:UIControlStateNormal];
        self.scrollH.constant = 100;

        //计算服务时间
        [self ComputeServiceTime];
    }
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""]; // 导航栏
    self.timerLabel.hidden = YES;
    longtime = -1;
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _isSelectOriginalPhoto = NO;

    [self configCollectionView]; // 选择图片
    [self initOtherView]; // UI视图编辑
    [self isLate];
    /*定位 正地理编码*/
    isPostLocation = NO;
    [self initCompleteBlock]; //地理回调
    [self configLocationManager]; // 位置管理
    if(!self.orderinfo.serviceLocationX||!self.orderinfo.serviceLocationY){// 无返回经纬度
        self.searchAPI = [[AMapSearchAPI alloc] init];
        self.searchAPI.delegate = self;
        //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
        AMapGeocodeSearchRequest *searchRequest = [[AMapGeocodeSearchRequest alloc] init];
        searchRequest.address = self.orderinfo.serviceAddress;
        //发起正向地理编码
        [self.searchAPI AMapGeocodeSearch: searchRequest];
    }else{
        //进行单次带逆地理定位请求
        [self.unfinishManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    }
    
    // 填写失败的原因
    reasonView = [[SinoutReasonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    reasonView.delegate = self;
    reasonView.hidden = YES;
    [self.view addSubview:reasonView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
    [timer setFireDate:[NSDate distantFuture]];
    [[AppDelegate sharedDelegate] hidHUD];
}
#pragma mark - service time
-(void)ComputeServiceTime{
    //截止时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDate = [AktUtil getNowDateAndTime];
    long strActrueSt = [AktUtil getSecondFrom:[formatter dateFromString:self.orderinfo.actrueBegin] To:[formatter dateFromString:nowDate]];
    long strServiceSt = [AktUtil getSecondFrom:[formatter dateFromString:self.orderinfo.serviceBegin] To:[formatter dateFromString:self.orderinfo.serviceEnd]];
    
    if(strServiceSt>strActrueSt){ //servicetime>=ordertime
      SSunservicetime = (strServiceSt - strActrueSt)*1000;
      self.ShowSingOutServiceTimelabel.text = @"服务时长不足";
      isLess = @"1";
      self.ShowSingOutServiceTimelabel.textColor = [UIColor redColor];
      self.ShowSingOutServiceTimelabel.hidden = NO;
      unservicetime = strServiceSt - strActrueSt; // 单位 秒
      leaveOuttime = unservicetime * 1000; // 单位 毫秒
      NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(showInOutTimer) userInfo:nil repeats:YES];
      [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
      [timer invalidate];
    }else{
        self.ShowSingOutServiceTimelabel.text = @"服务时长正常";
        isLess = @"0";
    }
}

//是否迟到 早退
-(void)isLate{
    NSDate * date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDate = [AktUtil getNowDateAndTime];
    long strActrueSt = [AktUtil getSecondFrom:[formatter dateFromString:self.orderinfo.actrueBegin] To:[formatter dateFromString:nowDate]];
    long strServiceSt = [AktUtil getSecondFrom:[formatter dateFromString:self.orderinfo.serviceBegin] To:[formatter dateFromString:self.orderinfo.serviceEnd]];
    
    if(self.type==0){
        if ([AktUtil isstatus:self.orderinfo.serviceBegin] == 0) {
            self.orderinfo.isLate = @"0";
            self.latelabel.text = @"正常";
        }else{
            self.orderinfo.isLate = @"1";
            self.latelabel.textColor = [UIColor redColor];
            self.latelabel.text = [NSString stringWithFormat:@"迟到%@",[AktUtil NowDate:date ServiceEndTime:self.orderinfo.serviceBegin]];
            
            NSDate *expireDate = [formatter dateFromString:self.orderinfo.serviceBegin];
            NSLog(@"秒数：%ld",(long)[AktUtil getSecondFrom:date To:expireDate]*1000);
            leaveIntime = [AktUtil getSecondFrom:date To:expireDate]*1000;
        }
        
    }else{
            if(strServiceSt>strActrueSt){// 判断早退的逻辑是：设定服务时长差 与 实际服务时长差相对比
                self.orderinfo.isEarly = @"1";
                self.latelabel.textColor = [UIColor redColor];
                self.latelabel.text = [NSString stringWithFormat:@"早退%@",[AktUtil NowDate:date ServiceEndTime:self.orderinfo.serviceEnd]];
                leaveOuttime = (strServiceSt-strActrueSt)*1000;
            }else{
                self.orderinfo.isEarly = @"0";
                self.latelabel.text = @"正常";
            }
    }
}

-(void)showInOutTimer{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",unservicetime/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(unservicetime%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",unservicetime%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    self.ShowSingOutServiceTimelabel.textColor = [UIColor redColor];
    self.ShowSingOutServiceTimelabel.text = format_time;
}

#pragma mark - init ui
-(void)initOtherView{
    self.pictrueTop.constant = 0;
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH-60)/4, (SCREEN_WIDTH-60)/4);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 10;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if([self.orderinfo.workStatus isEqualToString:@"4"]){
        if([self.orderinfo.serviceItemName rangeOfString:@"体检"].location != NSNotFound ||[self.orderinfo.serviceItemName rangeOfString:@"陪诊"].location != NSNotFound){
            self.lcView.hidden = NO;
        }
    }
    
    // 上传图片
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.postPictrueView.mas_top).offset(50);
        make.left.mas_equalTo(17);
        make.height.mas_equalTo((SCREEN_WIDTH-60)/4);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

#pragma mark - nav click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];

    _collectionView = [[LxGridView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
    //CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    //_collectionView.contentInset = UIEdgeInsetsMake(10, 10, 20, 10);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_postPictrueView addSubview:_collectionView];
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView setCollectionViewLayout:_layout];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 100){
        if(textView.text.length < 1){
            textView.text = @"请输入任务内容及完成情况";
            textView.textColor = [UIColor grayColor];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 100){
        if([textView.text isEqualToString:@"请输入任务内容及完成情况"]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
    }
    
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"------——count：%lu",(unsigned long)_selectedPhotos.count);
    return _selectedPhotos.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }

    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        if (_selectedPhotos.count <2) {
            if (_type ==0) {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", nil];
                [sheet showInView:self.view];
            }else{
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
                [sheet showInView:self.view];
            }
        }else{
            [self showMessageAlertWithController:self title:@"温馨提示" Message:@"图片最多可以上传两张哦~" canelBlock:^{}];
        }
        
    } else {
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = 2;

        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];

        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    // 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.isStatusBarDefault = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


 // 设置了navLeftBarButtonSettingBlock后，需打开这个方法，让系统的侧滑返回生效
 - (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
     navigationController.interactivePopGestureRecognizer.enabled = YES;
     if (viewController != navigationController.viewControllers[0]) {
     navigationController.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
     }
}
 

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机（可以去除）
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        _imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage * rimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage * image = [[UIImage alloc] init];
        if(rimage){
            CGSize sizes;
            float x = 0.f;
            if(rimage.size.height>rimage.size.width){
                if(rimage.size.height>=1080){
                    x = 1080/rimage.size.height;
                    float h = x*rimage.size.height;
                    float y = rimage.size.width*x;
                    sizes = CGSizeMake(y, h);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }else{
                    sizes = CGSizeMake(image.size.width, image.size.height);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }
            }else{
                if(rimage.size.width>=1080){
                    x = 1080/rimage.size.width;
                    float w = x*rimage.size.width;
                    float y = rimage.size.height*x;
                    sizes = CGSizeMake(w, y);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }else{
                    sizes = CGSizeMake(image.size.width, image.size.height);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }
            }
        }
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        if (_type == 1) {
            [self pushTZImagePickerController];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];

    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [_collectionView reloadData];

}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    return YES;
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private
// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
    }
}

#pragma mark - 录音方法
//录音按钮
-(IBAction)trapBtnClick:(id)sender{
    if(!isclick){
        [[[AktWCMp3 alloc] init] startRecordMp3FilePathName];
        isclick = YES;
        [self.trapBtn setImage:[UIImage imageNamed:@"luyinzhong"] forState:UIControlStateNormal];
        self.trapBtn.imageView.image = [UIImage imageNamed:@"luyingzhong"];
        [self.trapBtn setTitle:@"录音中" forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        self.timerLabel.hidden = NO;
    }else{
        [[[AktWCMp3 alloc] init] stopRecordMp3FilePathName];
          isclick = NO;
          [timer invalidate];
          _timerLabel.hidden = YES;
          [self showMessageAlertWithController:self title:@"" Message:@"保存完毕" canelBlock:^{
              [self.trapBtn setTitle:@"重新录音" forState:UIControlStateNormal];
          }];
          self.trapBtn.imageView.image = [UIImage imageNamed:@"luyin"];
    }
}

//计时器
-(void)handleTimer{
    longtime++;
    NSString * timeStr;
    if(longtime<10){
        timeStr = [NSString stringWithFormat:@"00:00:0%d",longtime];
    }else{
        timeStr = [NSString stringWithFormat:@"00:00:%d",longtime];
    }
    if(longtime==60){
        timeStr = [NSString stringWithFormat:@"00:01:00"];
        [self showMessageAlertWithController:self Message:@"录音时长不能超过60秒"];
        self.timerLabel.text = timeStr;
        [timer invalidate];

        // 停止录音
        [[[AktWCMp3 alloc] init] stopRecordMp3FilePathName];
        [self.trapBtn setImage:[UIImage imageNamed:@"luyin"] forState:UIControlStateNormal];
        isclick = NO;
        _timerLabel.hidden = YES;
        [self showMessageAlertWithController:self title:@"" Message:@"保存完毕" canelBlock:^{
        [self.trapBtn setTitle:@"重新录音" forState:UIControlStateNormal];
        }];
        
    }else{
        NSString * str = [NSString stringWithFormat:timeStr,longtime];
        self.timerLabel.text = str;
    }
}
#pragma mark - 距离
-(void)distanceBetween:(CLLocationDistance)distance{

        if (distance>400){
            if (self.type ==0) {
                self.statusPost = @"签入定位异常";
            }else{
                self.statusPost = @"签出定位异常";
            }
        self.distanceLabel.textColor = [UIColor redColor];
        self.distanceLabel.text = [NSString stringWithFormat:@"超出%0.1f米",distance];
    }else{
            if (self.type ==0) {
                self.statusPost = @"签入定位正常";
            }else{
                self.statusPost = @"签出定位正常";
            }
         self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f米",distance];
    }
    self.distancePost = [NSString stringWithFormat:@"%0.1f",distance]; // 距离
    if (isPostLocation) {
        NSLog(@"---可以提交");
        // 判断是否可以提交工单
              [[AFNetWorkingRequest sharedTool] requesttimeAndLocationStatement:@{@"workId":self.orderinfo.id,@"tenantsId":model.tenantsId} type:HttpRequestTypePost success:^(id responseObject) {

                  NSDictionary *dicObje = [responseObject objectForKey:@"object"];
                  NSString *strlocation = [dicObje objectForKey:@"isLocationStatement"];// 1或null 可以提交  0不可以提交
                  NSString *strtime = [dicObje objectForKey:@"isTimeStatement"];// 1或null 可以提交  0不可以提交
                  BOOL bolLocation = ([strlocation isKindOfClass:[NSNull class]] || [strlocation isEqualToString:@"1"] || ([strlocation integerValue] ==1));
                  BOOL bolTime = ([strtime isKindOfClass:[NSNull class]] || [strtime isEqualToString:@"1"] || ([strtime integerValue] == 1));

                  if (bolLocation || bolTime) {
                      NSLog(@"=====可以提交=");
                      [self postDataAllInfo:@""];
                  }else{
                      NSLog(@"=====不可以提交==");
                      if ([isLess isEqualToString:@"1"] || [self.distanceLabel.text containsString:@"超出"]) {
                          reasonView.hidden = NO;
                      }else{
                           [self postDataAllInfo:@""];
                      }
                  }

              } failure:^(NSError *error) {
                  [[AppDelegate sharedDelegate] hidHUD];
                  [self showMessageAlertWithController:self title:@"签出失败" Message:@"请稍后再试！" canelBlock:^{
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  }];
              }];
    }
}
#pragma mark - AMapSearchAPI delegate
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{ // 逆地理编码
    if (response.geocodes.count == 0)
    {
        return;
    }
    //解析response获取地理信息
    self.orderinfo.serviceLocationX = [NSString stringWithFormat:@"%f",response.geocodes.lastObject.location.longitude];
    self.orderinfo.serviceLocationY = [NSString stringWithFormat:@"%f",response.geocodes.lastObject.location.latitude];
    //进行单次带逆地理定位请求
    [self.unfinishManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];;
}
#pragma mark -  刷新重新定位
- (IBAction)btnReloadAddressClick:(UIButton *)sender {
    isPostLocation = NO;
    [self.unfinishManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}
#pragma mark - 服务流程
-(IBAction)submitWorkNode:(id)sender{
    
    if([self.lctitleTextField.text isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"服务流程不能为空"];
        return;
    }
    NSString * contentStr = self.lccontentTextView.text;
    if([contentStr isEqualToString:@""]){
        contentStr = @"暂无备注";
    }
    NSDictionary * dic = @{@"workId":self.orderinfo.id,@"title":self.lctitleTextField.text,@"content":contentStr,@"tenantsId":model.tenantsId};
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
    [[AFNetWorkingRequest sharedTool]uploadWorkNode:dic type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        if([dic[@"code"] intValue]==1){
            [self showMessageAlertWithController:self Message:@"提交成功"];
            self.lctitleTextField.text = @"";
            self.lccontentTextView.text = @"";
        }
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
        [self showMessageAlertWithController:self Message:@"提交失败，请重新提交"];

    }];
}
#pragma mark - 提交信息
-(IBAction)submitClick:(id)sender{
     isPostLocation = YES;
    [self.unfinishManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}
-(void)postDataAllInfo:(NSString *)reason{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
    if(self.type==1){
        [[AppDelegate sharedDelegate] showTextOnly:@"任务签出提交中"];
    }else{
        [[AppDelegate sharedDelegate] showTextOnly:@"任务签入提交中"];
    }
    NSMutableArray * basearr = [NSMutableArray array];
    NSString * baseStr = @"";
    NSString * wavStr = @"";
    if(_selectedPhotos.count>=1){
        for(int i = 0; i < _selectedPhotos.count;i++){
            UIImage * image = _selectedPhotos[i];
            NSString * baseCode = [self imageToBaseString:image];
            [basearr addObject:baseCode];
        }
    }
    
    baseStr = [basearr componentsJoinedByString:@","];
    if(self.type==1){
        wavStr = [[[AktWCMp3 alloc] init] mp3ToBASE64];
    }
    NSDate * date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.nowdate = [formatter stringFromDate:date];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param addUnEmptyString:self.orderinfo.id forKey:@"id"];
    [param addUnEmptyString:self.orderinfo.workNo forKey:@"workNo"];
    [param addUnEmptyString:baseStr forKey:@"imageData"];
    if([self.textview.text isEqualToString:@"请输入任务内容及完成情况"]){
        [param addUnEmptyString:@"" forKey:@"serviceResult"];
    }else{
        [param addUnEmptyString:self.textview.text forKey:@"serviceResult"];
    }
    [param addUnEmptyString:self.orderinfo.processInstanceId forKey:@"processInstanceId"];
    [param addUnEmptyString:model.tenantsId forKey:@"tenantsId"];
    [param addUnEmptyString:self.addressLabel.text forKey:@"waiterLocation"];
    [param addUnEmptyString:@"test" forKey:@"test"];
    [param addUnEmptyString:reason forKey:@"timeStatementMsg"]; // 签入or签出 失败的理由
    [param addUnEmptyString:self.orderinfo.isAbnormal forKey:@"isAbnormal"]; // 定位异常
    //签出
    if(self.type==1){
        
        [param addUnEmptyString:self.locaitonLongitude forKey:@"signOutLocationX"];
        [param addUnEmptyString:self.locaitonLatitude forKey:@"signOutLocationY"];
        [param addUnEmptyString:self.distancePost forKey:@"signOutDistance"];// 签出距离
        [param addUnEmptyString:self.statusPost forKey:@"signOutStatus"]; // 签出状态
        [param addUnEmptyString:self.addressLabel.text forKey:@"signOutLocation"]; // 签出 当前地址
        [param addUnEmptyString:self.nowdate forKey:@"actrueEnd"];
        [param addUnEmptyString:self.orderinfo.isEarly forKey:@"isEarly"];//是否早退
        [param addUnEmptyString:wavStr forKey:@"tapeName"];
        [param addUnEmptyString:isLess forKey:@"isLess"];
        [param addUnEmptyString:[NSString stringWithFormat:@"%ld",SSunservicetime] forKey:@"lessTimeLength"];
        [param addUnEmptyString:[NSString stringWithFormat:@"%ld",leaveOuttime] forKey:@"earlyTimeLength"];
        
        [[AFNetWorkingRequest sharedTool] requestsignOut:param type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary * dic = responseObject;
            [[AppDelegate sharedDelegate] hidHUD];
            [self showMessageAlertWithController:self title:@"" Message:dic[@"message"] canelBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
        } failure:^(NSError *error) {
            [[AppDelegate sharedDelegate] hidHUD];
            [self showMessageAlertWithController:self title:@"签出失败" Message:@"请稍后再试！" canelBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }];
        
    }else{
        [param addUnEmptyString:model.uuid forKey:@"waiterId"];
        [param addUnEmptyString:self.locaitonLongitude forKey:@"signInLocationX"];
        [param addUnEmptyString:self.locaitonLatitude forKey:@"signInLocationY"];
        [param addUnEmptyString:self.distancePost forKey:@"signInDistance"]; // 距离
        [param addUnEmptyString:self.statusPost forKey:@"signInStatus"]; // 状态
        [param addUnEmptyString:self.addressLabel.text forKey:@"signInLocation"];
        [param addUnEmptyString:self.nowdate forKey:@"actrueBegin"];
        [param addUnEmptyString:self.orderinfo.isLate forKey:@"isLate"];
        [param addUnEmptyString:[NSString stringWithFormat:@"%ld",leaveIntime] forKey:@"lateTimeLength"];//0正常 1迟到
        
        [[AFNetWorkingRequest sharedTool] requestsignIn:param type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary * dic = responseObject;
            NSNumber * code = dic[@"code"];
            [[AppDelegate sharedDelegate] hidHUD];
            if([code longValue]==1){
                [self.unfinishManager stopUpdatingLocation];
                [AppInfoDefult sharedClict].orderinfoId = @"";
                [AppInfoDefult sharedClict].islongLocation=0;
            }
            [self showMessageAlertWithController:self title:@"" Message:dic[@"message"] canelBlock:^{
               [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } failure:^(NSError *error) {
            [self showMessageAlertWithController:self title:@"" Message:@"签入失败" canelBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
             }];
            [[AppDelegate sharedDelegate] hidHUD];
        }];
    }
}
#pragma mark - reason delegate
-(void)didselectAction:(UIButton *)sender textviewInfo:(NSString *)info{
    switch (sender.tag) {
        case 1:
            {
                [self postDataAllInfo:info];
            }
            break;
        case 2:
            reasonView.hidden = YES;
            break;
        default:
            break;
    }
}
#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
    // 水印内容
    NSString *strMark = [NSString stringWithFormat:@"安康通\n%@\n%@",[AktUtil getNowDateAndTime],self.addressLabel.text];
    // 水印
    AddWaterMark *mark = [[AddWaterMark alloc] init];
    mark.textFont = [UIFont fontWithName:@"PingFang SC" size:14];
    mark.textFontSubtitle = [UIFont fontWithName:@"PingFang SC" size:10];
    mark.textColor = [UIColor grayColor];
    image = [mark addWaterMark:image watemarkText:strMark];

    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

#pragma mark - textview代理方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if (textView.tag==100){
            //在这里做你响应return键的代码
            [self.textview resignFirstResponder];
        }else{
            [self.lccontentTextView resignFirstResponder];
        }
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    if ([self.lctitleTextField isFirstResponder]) {
        // 隐藏键盘.
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}

-(void)dealloc{
    // 移除当前所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
