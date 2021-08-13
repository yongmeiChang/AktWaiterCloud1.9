//
//  AktOrderScanVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/17.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import "AktOrderScanVC.h"
#import "SignoutController.h"
#import "AktOldPersonDetailsVC.h"

#import "GLKitView.h"
#import "Utility.h"
#import "ASFVideoProcessor.h"
#import <ArcSoftFaceEngine/ArcSoftFaceEngine.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

#define imgeWidth 720
#define imgeHight 1280

#define AKT_FaceCircleW (SCREEN_WIDTH-150) // 设置人脸识别 圆框的直径
#define AKT_Face3DAngle 10  // 设置人脸的偏航角度

@interface AktOrderScanVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASFVideoProcessorDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    // 扫码相关视图
    UIView *topView;
    UIView *leftView;
    UIView *rightView;
    UIView *botView;
    UIView *scanWindow;
    UILabel * toplabel;
    AVCaptureDeviceInput * input;
    AVCaptureMetadataOutput * output;
    
    // 人脸相关视图
    BOOL isOpen;// 是否 打开手电筒
    BOOL isFace; // 是否刷脸 1是 0否
    BOOL isback; // 0后摄像头 1前摄像头 默认后摄像头
    NSString *isOldpeopleface; // 是否人脸采集 1是 0否
    
    NSString *strOldpeople;
    // 人脸识别
    ASF_CAMERA_DATA*   _offscreenIn;
    AVCaptureConnection *videoConnection;
    UIView *faceRectView;
    CGFloat angle;
}
@property (weak, nonatomic) IBOutlet UIView *faceBgView; // 人脸识别背景
@property(nonatomic,strong) SignoutController * sgController;

@property (nonatomic) float QRCodeWidth;//正方形边长
@property (nonatomic,strong)NSString * controller_type;
@property (nonatomic,strong) UILabel * lightLabel;
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * captureDevice;
//人脸识别
@property (nonatomic, strong) ASFVideoProcessor* videoProcessor;
@property (nonatomic, strong) NSMutableArray* arrayAllFaceRectView;
@property (weak, nonatomic) IBOutlet GLKitView *glView;
@property (weak, nonatomic) IBOutlet UIButton *btnChangefaceFrond;
@property (weak, nonatomic) IBOutlet UILabel *labFace;
@property (weak, nonatomic) IBOutlet UIImageView *imgFaceC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faceCircleH;

@end

@implementation AktOrderScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     isOpen = false;
     isFace = false;
     isback = false;
    isOldpeopleface = [[NSString alloc] init];
    strOldpeople = [[NSString alloc] init];
    self.faceCircleH.constant = SCREEN_WIDTH-100;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    self.netWorkErrorView.hidden = YES;
    
    _QRCodeWidth = SCREEN_WIDTH*0.7;
    angle = 0; // 旋转角度
    if (([self.detailsModel.codeScanSignIn isEqualToString:@"1"] && [self.detailsModel.faceSwipingSignIn isEqualToString:@"1"]) || ([self.detailsModel.codeScanSignOut isEqualToString:@"1"] && [self.detailsModel.faceSwipingSignOut isEqualToString:@"1"])) {//扫码、 刷脸  权限打开 签入
        [self setupMaskView];//设置扫描区域之外的阴影视图

        [self setupScanWindowView];//设置扫描二维码区域的视图

        [self beginScanning];//开始扫二维码
        
        if ([self.ordertype isEqualToString:@"1"]) {
            [self setNavTitle:@"二维码扫描签入"];
        }else{
            [self setNavTitle:@"二维码扫描签出"];
        }
        [self setNomalRightNavTilte:@"" RightTitleTwo:@"人脸识别"];
    }else if (([self.detailsModel.codeScanSignIn isEqualToString:@"1"] && [self.detailsModel.faceSwipingSignIn isEqualToString:@"0"]) || ([self.detailsModel.codeScanSignOut isEqualToString:@"1"] && [self.detailsModel.faceSwipingSignOut isEqualToString:@"0"])){//扫码 权限打开 签入
        [self setupMaskView];//设置扫描区域之外的阴影视图

        [self setupScanWindowView];//设置扫描二维码区域的视图

        [self beginScanning];//开始扫二维码
        if ([self.ordertype isEqualToString:@"1"]) {
            [self setNavTitle:@"二维码扫描签入"];
        }else{
            [self setNavTitle:@"二维码扫描签出"];
        }
        [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    }else{
        
        self.glView.hidden = NO;
        self.btnChangefaceFrond.hidden = NO;
        self.labFace.hidden = NO;
        self.imgFaceC.hidden = NO;
        
        // 人脸
        self.faceBgView.hidden = NO;
        [self setFaceCamera];
        [self startCaptureSession];
        [self startAnimation]; // 开始动画旋转
        [self setNavTitle:@"人脸识别"];
        [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
        isFace =true;
        
    }
        

    /*签入 签出页面*/
    _sgController = [[SignoutController alloc] init];
       if([self.orderinfo.workStatus isEqualToString:@"2"]){
           _sgController.type = 1;
       }else if([self.orderinfo.workStatus isEqualToString:@"1"]){
           _sgController.type = 0;
       }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取老人采集信息
    [self requestOldPeopleinfo];
    
    if (isFace) { // 开启刷脸操作
        [self startCaptureSession];
    }else{
        [_session startRunning];
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_session stopRunning];
    [self stopCaptureSession];
}
#pragma mark - 获取老人是否进行了人脸采集
-(void)requestOldPeopleinfo{
    [[AFNetWorkingRequest sharedTool] requestOldPeoPleAtTheFaceInfo:@{@"customerUkey":kString(self.orderinfo.customerUkey)} type:HttpRequestTypePost success:^(id responseObject) {
        isOldpeopleface = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"existFlag"]]; // existFlag 0未采集 1已采集
        strOldpeople = [responseObject objectForKey:@"message"];
    } failure:nil];
}

#pragma mark - click back

-(void)LeftBarClick{
    if([self.controller_type isEqualToString:@"logincontoller"]){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)SearchBarClick{
    // 切换识别方式 移除人脸对焦
    [faceRectView removeFromSuperview];
    
    if (isFace) { // 开启扫码操作
        self.glView.hidden = YES;
        self.btnChangefaceFrond.hidden = YES;
        self.labFace.hidden = YES;
        self.imgFaceC.hidden = YES;
        [self stopCaptureSession];
        // 扫码
        topView.hidden = NO;
        leftView.hidden = NO;
        rightView.hidden = NO;
        botView.hidden = NO;
        scanWindow.hidden = NO;
        toplabel.hidden = NO;
        [_session startRunning];//开始扫二维码
        // 人脸
        self.faceBgView.hidden = YES;
        if ([self.ordertype isEqualToString:@"1"]) {
            [self setNavTitle:@"扫码签入"];
        }else{
            [self setNavTitle:@"扫码签出"];
        }
        [self setNomalRightNavTilte:@"" RightTitleTwo:@"人脸识别"];
        isFace = false;
       
        
    }else{// 开启刷脸操作
        self.glView.hidden = NO;
        self.btnChangefaceFrond.hidden = NO;
        self.labFace.hidden = NO;
        self.imgFaceC.hidden = NO;
        // 扫码
        topView.hidden = YES;
        leftView.hidden = YES;
        rightView.hidden = YES;
        botView.hidden = YES;
        scanWindow.hidden = YES;
        toplabel.hidden = YES;
        [_session stopRunning];// 停止扫描
        // 人脸
        self.faceBgView.hidden = NO;
        [self setFaceCamera];
        [self startCaptureSession];
        [self startAnimation]; // 开始动画旋转
        if ([self.ordertype isEqualToString:@"1"]) {
            [self setNomalRightNavTilte:@"" RightTitleTwo:@"扫码签入"];
        }else{
            [self setNomalRightNavTilte:@"" RightTitleTwo:@"扫码签出"];
        }
        [self setNavTitle:@"人脸识别"];
        isFace =true;
        
    }
}

- (IBAction)btnChangeCamera:(UIButton *)sender {
    isback =! isback;
    [self stopCaptureSession];
    
    [self setupCaptureSession:(AVCaptureVideoOrientation)[[UIApplication sharedApplication] statusBarOrientation] isFront:isback];
    [self startCaptureSession];
}

#pragma mark - AVCaptureSession
-(AVCaptureSession *)captureSesion
{
    if(_captureSession == nil)
    {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

-(AVCaptureDevice *)captureDevice
{
    if(_captureDevice == nil)
    {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}
- (void)setupMaskView
{
    //设置统一的视图颜色和视图的透明度
    UIColor *color = [UIColor blackColor];
    float alpha = 0.7;
    
    //设置扫描区域外部上部的视图
    topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-_QRCodeWidth)/2.0-64+50);
    topView.backgroundColor = color;
    topView.alpha = alpha;
    
    //设置扫描区域外部左边的视图
    leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, topView.frame.size.height, (SCREEN_WIDTH-_QRCodeWidth)/2.0,_QRCodeWidth);
    leftView.backgroundColor = color;
    leftView.alpha = alpha;
    
    //设置扫描区域外部右边的视图
    rightView = [[UIView alloc]init];
    rightView.frame = CGRectMake((SCREEN_WIDTH-_QRCodeWidth)/2.0+_QRCodeWidth,topView.frame.size.height, (SCREEN_WIDTH-_QRCodeWidth)/2.0,_QRCodeWidth);
    rightView.backgroundColor = color;
    rightView.alpha = alpha;
    
    //设置扫描区域外部底部的视图
    botView = [[UIView alloc]init];
    botView.frame = CGRectMake(0, _QRCodeWidth+topView.frame.size.height,SCREEN_WIDTH,SCREEN_HEIGHT-_QRCodeWidth-topView.frame.size.height);
    botView.backgroundColor = color;
    botView.alpha = alpha;
    
    //将设置好的扫描二维码区域之外的视图添加到视图图层上
    [self.view addSubview:topView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:botView];
}


- (void)setupScanWindowView
{
    //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
    scanWindow = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-_QRCodeWidth)/2.0,(SCREEN_HEIGHT-_QRCodeWidth)/2.0-14,_QRCodeWidth,_QRCodeWidth)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    //设置扫描区域的动画效果
    CGFloat scanNetImageViewH = 100;
    CGFloat scanNetImageViewW = scanWindow.frame.size.width;
    UIImageView *scanNetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    scanNetImageView.contentMode =  UIViewContentModeCenter;
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath =@"transform.translation.y";
    scanNetAnimation.byValue = @(_QRCodeWidth);
    scanNetAnimation.duration = 1.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    
    toplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    toplabel.text = @"请扫描用户的二维码";
    toplabel.textColor = [UIColor whiteColor];
    toplabel.backgroundColor = [UIColor clearColor];
    toplabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:toplabel];
    [toplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(scanWindow.mas_top).offset(-5);
        make.centerX.mas_equalTo(0);
    }];
    
    //设置扫描区域的四个角的边框
    CGFloat buttonWH = 18;
    UIButton *topLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"1"]forState:UIControlStateNormal];
    [scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc]initWithFrame:CGRectMake(_QRCodeWidth - buttonWH,0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"2"]forState:UIControlStateNormal];
    [scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,_QRCodeWidth - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"4"]forState:UIControlStateNormal];
    [scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc]initWithFrame:CGRectMake(_QRCodeWidth-buttonWH,_QRCodeWidth-buttonWH, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"3"]forState:UIControlStateNormal];
    [scanWindow addSubview:bottomRight];
    
    _lightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, scanWindow.frame.origin.y + 10, 100, 80)];
    _lightLabel.text = @"轻触点亮";
    _lightLabel.textColor = [UIColor lightGrayColor];
    _lightLabel.backgroundColor = [UIColor clearColor];
    _lightLabel.font = [UIFont systemFontOfSize:14.0f];
    [scanWindow addSubview:_lightLabel];
    [_lightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(scanWindow.mas_bottom).offset(0);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(scanWindow.mas_centerX).offset(0);
    }];
    _lightLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *openlabelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OpenLight)];
    [_lightLabel addGestureRecognizer:openlabelTapGestureRecognizer];
    [scanWindow addGestureRecognizer:openlabelTapGestureRecognizer];

}

-(void)OpenLight{
    if(isOpen){
        _lightLabel.text = @"轻触点亮";
        [self.captureSession beginConfiguration];
        [self.captureDevice lockForConfiguration:nil];
        if(self.captureDevice.torchMode == AVCaptureTorchModeOn)
        {
            [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        [self.captureDevice unlockForConfiguration];
        [self.captureSession commitConfiguration];
        [self.captureSession stopRunning];
        isOpen = NO;
    }else{
        if([self.captureDevice hasTorch] && [self.captureDevice hasFlash])
        {
            if(self.captureDevice.torchMode == AVCaptureTorchModeOff)
            {
                [self.captureSession beginConfiguration];
                [self.captureDevice lockForConfiguration:nil];
                [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
                [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
                [self.captureDevice unlockForConfiguration];
                [self.captureSession commitConfiguration];
            }
        }
        [self.captureSession startRunning];
        _lightLabel.text = @"轻触关闭";
        isOpen = YES;
    }
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    output = [[AVCaptureMetadataOutput alloc]init];
    
    //特别注意的地方：有效的扫描区域，定位是以设置的右顶点为原点。屏幕宽所在的那条线为y轴，屏幕高所在的线为x轴
    CGFloat x = ((SCREEN_HEIGHT-_QRCodeWidth)/2.0)/SCREEN_HEIGHT;
    CGFloat y = ((SCREEN_WIDTH-_QRCodeWidth)/2.0)/SCREEN_WIDTH;
    CGFloat width = _QRCodeWidth/SCREEN_HEIGHT;
    CGFloat height = _QRCodeWidth/SCREEN_WIDTH;
    output.rectOfInterest = CGRectMake(x, y, width, height);
    
    //设置代理在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];

    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];                                                                                                                  
}
-(void)endScanning{
    [self.session removeInput:input];
    [self.session removeOutput:output];
    [_session stopRunning];
}
//扫描完毕执行
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        //得到二维码上的所有数据
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0 ];
        NSString *str = metadataObject.stringValue;
        if ([str isEqualToString:kString(self.orderinfo.customerUkey)]) {
            // 扫码完成之后 进入到签入 签出页面
            _sgController.isnewLation = self.isnewLation;
            _sgController.isnewlate = self.isnewlate;
            _sgController.isnewearly = self.isnewearly;
            _sgController.isnewserviceTime = self.isnewserviceTime;
            _sgController.isnewserviceTimeLess = self.isnewserviceTimeLess;
            _sgController.orderinfo = self.orderinfo;
            _sgController.findAdmodel = self.detailsModel;
            [self.navigationController pushViewController:_sgController animated:YES];
        }else{
            [[AppDelegate sharedDelegate] showTextOnly:@"服务客户不一致！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_session startRunning];
            });
        }
    }
}

#pragma mark - post face info
-(void)postImageData:(UIImage *)image{ // 人脸识别
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"识别中..."];
    [[AktVipCmd sharedTool] requestFaceRecognition:@{@"customerImg":[self imageToBaseString:image],@"imgType":@"png"} type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSLog(@"---%@",responseObject);
        NSString *strcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:ResponseCode]];
        if ([strcode isEqualToString:@"1"]) {
            if ([[responseObject objectForKey:@"customerUkey"] isEqualToString:kString(self.orderinfo.customerUkey)]) {
                [[AppDelegate sharedDelegate] showTextOnly:[responseObject objectForKey:@"message"]];
                // 人脸识别完成之后 进入到签入 签出页面
                _sgController.isnewLation = self.isnewLation;
                _sgController.isnewlate = self.isnewlate;
                _sgController.isnewearly = self.isnewearly;
                _sgController.isnewserviceTime = self.isnewserviceTime;
                _sgController.isnewserviceTimeLess = self.isnewserviceTimeLess;
                _sgController.orderinfo = self.orderinfo;
                _sgController.findAdmodel = self.detailsModel;
                [self.navigationController pushViewController:_sgController animated:YES];
            }else{
                [[AppDelegate sharedDelegate] showTextOnly:@"人脸信息不一致！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [[AppDelegate sharedDelegate] showTextOnly:[responseObject objectForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] hidHUD];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)postFaceInfoDataToService:(UIImage *)oldImage{// 人脸采集
    //上传
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"采集中..."];
    NSDictionary * parameters =@{@"customerName":kString(self.orderinfo.customerName),@"customerUkey":kString(self.orderinfo.customerUkey),@"customerImg":[self imageToBaseString:oldImage],@"imgType":@"png"};
    [[AktVipCmd sharedTool] requestFaceCollect:parameters type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSLog(@"---%@",responseObject);
        [[AppDelegate sharedDelegate] showTextOnly:[responseObject objectForKey:@"message"]];
        [[AppDelegate sharedDelegate] hidHUD];
        NSString *strcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:ResponseCode]];
        // 人脸采集完成之后 进入到签入 签出页面
        if ([strcode isEqualToString:@"1"]) {
            _sgController.isnewLation = self.isnewLation;
            _sgController.isnewlate = self.isnewlate;
            _sgController.isnewearly = self.isnewearly;
            _sgController.isnewserviceTime = self.isnewserviceTime;
            _sgController.isnewserviceTimeLess = self.isnewserviceTimeLess;
            _sgController.orderinfo = self.orderinfo;
            _sgController.findAdmodel = self.detailsModel;
            [self.navigationController pushViewController:_sgController animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
        [[AppDelegate sharedDelegate] hidHUD];
    }];
}
#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
//    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    NSString *encodedImageStr = [[AktUtil resetSizeOfImageData:image maxSize:100] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

#pragma mark - face camera info
-(void)setFaceCamera{
    UIInterfaceOrientation uiOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    AVCaptureVideoOrientation videoOrientation = (AVCaptureVideoOrientation)uiOrientation;
    
    self.arrayAllFaceRectView = [NSMutableArray arrayWithCapacity:0];
    
    self.videoProcessor = [[ASFVideoProcessor alloc] init];
    self.videoProcessor.delegate = self;
    [self.videoProcessor initProcessor];
    
    [self setupCaptureSession:videoOrientation isFront:isback]; // 摄像权限
}
- (AVCaptureDevice *)videoDeviceWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
        if ([device position] == position)
            return device;
    
    return nil;
}
- (BOOL) setupCaptureSession:(AVCaptureVideoOrientation)videoOrientation isFront:(BOOL)isFront
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    [self.captureSession beginConfiguration];
    
    AVCaptureDevice *videoDevice = [self videoDeviceWithPosition:isFront ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];// 前、后摄像头
    // 创建输入流
    AVCaptureDeviceInput *videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    if ([self.captureSession canAddInput:videoIn])
        [self.captureSession addInput:videoIn];
    
    
    // 创建输出流
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [videoOut setAlwaysDiscardsLateVideoFrames:YES];

    //
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.frame = CGRectMake(0, 0, 0, 0); //self.view.bounds
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    previewLayer.cornerRadius = self.glView.frame.size.width/2;
    
#ifdef __OUTPUT_BGRA__
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
#else
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
#endif
    [videoOut setVideoSettings:dic];
    
    dispatch_queue_t videoCaptureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    [videoOut setSampleBufferDelegate:self queue:videoCaptureQueue];
    
    if ([self.captureSession canAddOutput:videoOut])
        [self.captureSession addOutput:videoOut];
    videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection.supportsVideoMirroring) {
        [videoConnection setVideoMirrored:TRUE];
    }
    
    if ([videoConnection isVideoOrientationSupported]) {
        [videoConnection setVideoOrientation:videoOrientation];
    }
    
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    
    [self.captureSession commitConfiguration];
    
    return YES;
}

- (void) startCaptureSession
{
    if ( !self.captureSession )
        return;
    
    if (!self.captureSession.isRunning )
        [self.captureSession startRunning];
}

- (void) stopCaptureSession
{
    [self.captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef cameraFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
    ASF_CAMERA_DATA* cameraData = [Utility getCameraDataFromSampleBuffer:sampleBuffer];
    NSArray *arrayFaceInfo = [self.videoProcessor process:cameraData];
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        [self.glView renderWithCVPixelBuffer:cameraFrame orientation:0 mirror:NO];
        
        if(self.arrayAllFaceRectView.count >= arrayFaceInfo.count)//隐藏人脸
        {
            for (NSUInteger face=arrayFaceInfo.count; face<self.arrayAllFaceRectView.count; face++) {
                faceRectView = [self.arrayAllFaceRectView objectAtIndex:face];
                faceRectView.hidden = YES;
            }
        }
        else
        {
            for (NSUInteger face=self.arrayAllFaceRectView.count; face<arrayFaceInfo.count; face++) {
                UIStoryboard *faceRectStoryboard = [UIStoryboard storyboardWithName:@"AktFace" bundle:nil];
                faceRectView = [faceRectStoryboard instantiateViewControllerWithIdentifier:@"FaceRectVC"].view;
                [self.view addSubview:faceRectView];
                [self.arrayAllFaceRectView addObject:faceRectView];
            }
        }
        
        for (NSUInteger face = 0; face < arrayFaceInfo.count; face++) {
            faceRectView = [self.arrayAllFaceRectView objectAtIndex:face];
            ASFVideoFaceInfo *faceInfo = [arrayFaceInfo objectAtIndex:face];
            faceRectView.hidden = NO;
            faceRectView.frame = [self dataFaceRect2ViewFaceRect:faceInfo.faceRect];
            
            // 判断是否是活体 并且状态正常
            CGRect faceInView = {0};
            faceInView = faceRectView.frame;
            if (faceInView.size.width>AKT_FaceCircleW || faceInView.size.height>AKT_FaceCircleW || faceInView.origin.x<(SCREEN_WIDTH-AKT_FaceCircleW)/2 || faceInView.origin.y<140|| faceInView.origin.x>AKT_FaceCircleW+(SCREEN_WIDTH-AKT_FaceCircleW)/2 || faceInView.origin.y>140+AKT_FaceCircleW) {
                faceRectView.hidden = YES;
            }else{// 人脸在有效区域内 偏航角不超过10°
                faceRectView.hidden = NO;
                if (faceInfo.face3DAngle.pitchAngle < AKT_Face3DAngle && faceInfo.face3DAngle.rollAngle < AKT_Face3DAngle && faceInfo.face3DAngle.yawAngle < AKT_Face3DAngle && faceInfo.face3DAngle.status == 0 && faceInfo.liveness == 1) { // 正常 活体
                    CIImage *image = [CIImage imageWithCVPixelBuffer:cameraFrame];
                    UIImage *imgF = [UIImage imageWithCIImage:image];
                    [self stopCaptureSession];
                 
                    if ([isOldpeopleface isEqualToString:@"1"]) {//人脸识别
                        [self postImageData:imgF];
                    }else{// 人脸采集
                        [self postFaceInfoDataToService:imgF];
                    }
                    
                    return;
                }
            }
            
        }
    });
    [Utility freeCameraData:cameraData];
}

- (CGRect)dataFaceRect2ViewFaceRect:(MRECT)faceRect
{
    // 获取的图像的宽 高度
     CGFloat faceimgeW = faceRect.right-faceRect.left;
     CGFloat faceimgeH = faceRect.bottom-faceRect.top;
    
    // 视图的位置 大小
    CGRect frameGLView = self.glView.frame;
    
    // 计算后的人脸捕捉位置 大小
    CGRect frameFaceRect = {0};
    frameFaceRect.size.width = CGRectGetWidth(frameGLView)*faceimgeW/imgeWidth;
    frameFaceRect.size.height = CGRectGetHeight(frameGLView)*faceimgeH/imgeHight;
    frameFaceRect.origin.x = CGRectGetWidth(frameGLView)*faceRect.left/imgeWidth;
    frameFaceRect.origin.y = CGRectGetHeight(frameGLView)*faceRect.top/imgeHight;

    return frameFaceRect;
    
}

#pragma mark - animation
- (void)startAnimation{
CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
[UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
 self.imgFaceC.transform = endAngle;
} completion:^(BOOL finished) {
    angle += 10;
    [self startAnimation];
}];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
