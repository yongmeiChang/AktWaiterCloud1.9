//
//  AktOrderScanVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/17.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import "AktOrderScanVC.h"
#import "SignoutController.h"

@interface AktOrderScanVC ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL isOpen;// 是否 打开手电筒
}
@property(nonatomic,strong) SignoutController * sgController;

@property (nonatomic) float QRCodeWidth;//正方形边长
@property (nonatomic,strong)NSString * controller_type;
@property (nonatomic,strong) UILabel * lightLabel;
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * captureDevice;

@end

@implementation AktOrderScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     isOpen = false;
        self.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    if ([self.ordertype isEqualToString:@"1"]) {
        [self setNavTitle:@"二维码扫描签入"];
    }else{
        [self setNavTitle:@"二维码扫描签出"];
    }
        self.netWorkErrorView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_session stopRunning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    _QRCodeWidth = SCREEN_WIDTH*0.7;
    [self setupMaskView];//设置扫描区域之外的阴影视图
    
    [self setupScanWindowView];//设置扫描二维码区域的视图
    
    [self beginScanning];//开始扫二维码
    
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    /*签入 签出页面*/
    _sgController = [[SignoutController alloc] init];
       if([self.orderinfo.nodeName isEqualToString:@"待签出"]){
           _sgController.type = 1;
       }else if([self.orderinfo.nodeName isEqualToString:@"待签入"]){
           _sgController.type = 0;
       }
    
}

#pragma mark -

//-(id)initWithQRCode:(BaseControllerViewController *)viewcontroller Type:(NSString *)type{
//    if (self = [super init]) {
//        if([viewcontroller isKindOfClass:[LoginViewController class]]){
//            self.loginController = (LoginViewController*)viewcontroller;
//        }else if([viewcontroller isKindOfClass:[UnfinishOrderTaskController class]]){
//            self.unfinishController = (UnfinishOrderTaskController *)viewcontroller;
//        }
//        self.controller_type = type;
//    }
//    return self;
//}
#pragma mark - click back
-(void)LeftBarClick{
    if([self.controller_type isEqualToString:@"logincontoller"]){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-_QRCodeWidth)/2.0-64+50);
    //topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-64-_QRCodeWidth)/2.0-64+50);
    topView.backgroundColor = color;
    topView.alpha = alpha;
    
    //设置扫描区域外部左边的视图
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, topView.frame.size.height, (SCREEN_WIDTH-_QRCodeWidth)/2.0,_QRCodeWidth);
//    leftView.frame = CGRectMake(0, topView.frame.size.height, (SCREEN_WIDTH-_QRCodeWidth)/2.0,_QRCodeWidth);
    leftView.backgroundColor = color;
    leftView.alpha = alpha;
    
    //设置扫描区域外部右边的视图
    UIView *rightView = [[UIView alloc]init];
    rightView.frame = CGRectMake((SCREEN_WIDTH-_QRCodeWidth)/2.0+_QRCodeWidth,topView.frame.size.height, (SCREEN_WIDTH-_QRCodeWidth)/2.0,_QRCodeWidth);
    //rightView.frame = CGRectMake((SCREEN_WIDTH-_QRCodeWidth)/2.0+_QRCodeWidth,topView.frame.size.height, (SCREEN_WIDTH-_QRCodeWidth)/2.0,_QRCodeWidth);
    rightView.backgroundColor = color;
    rightView.alpha = alpha;
    
    //设置扫描区域外部底部的视图
    UIView *botView = [[UIView alloc]init];
    botView.frame = CGRectMake(0, _QRCodeWidth+topView.frame.size.height,SCREEN_WIDTH,SCREEN_HEIGHT-_QRCodeWidth-topView.frame.size.height);
    //botView.frame = CGRectMake(0, _QRCodeWidth+topView.frame.size.height,SCREEN_WIDTH,SCREEN_HEIGHT-_QRCodeWidth-topView.frame.size.height);
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
    UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-_QRCodeWidth)/2.0,(SCREEN_HEIGHT-_QRCodeWidth)/2.0-14,_QRCodeWidth,_QRCodeWidth)];
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
    
    UILabel * toplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
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
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
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

//扫描完毕执行
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        //得到二维码上的所有数据
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0 ];
        NSString *str = metadataObject.stringValue;
        
        // 扫码完成之后 进入到签入 签出页面
        _sgController.orderinfo = self.orderinfo;
        [self.navigationController pushViewController:_sgController animated:YES];
    }
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
