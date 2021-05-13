//
//  AktOrderScanVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/17.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import "AktOrderScanVC.h"
#import "SignoutController.h"

@interface AktOrderScanVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
}
@property (weak, nonatomic) IBOutlet UIView *faceBgView; // 人脸识别背景
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
     isFace = false;
        self.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        self.netWorkErrorView.hidden = YES;
    
    _QRCodeWidth = SCREEN_WIDTH*0.7;
    [self setupMaskView];//设置扫描区域之外的阴影视图

    [self setupScanWindowView];//设置扫描二维码区域的视图

    [self beginScanning];//开始扫二维码

        if ([self.ordertype isEqualToString:@"1"]) {
            [self setNavTitle:@"二维码扫描签入"];
        }else{
            [self setNavTitle:@"二维码扫描签出"];
        }
        [self setNomalRightNavTilte:@"" RightTitleTwo:@"人脸识别"];

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
    [_session startRunning];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_session stopRunning];
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
    if (isFace) {
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
    }else{
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
        [self facePhoto];
       
        if ([self.ordertype isEqualToString:@"1"]) {
            [self setNomalRightNavTilte:@"" RightTitleTwo:@"扫码签入"];
        }else{
            [self setNomalRightNavTilte:@"" RightTitleTwo:@"扫码签出"];
        }
        [self setNavTitle:@"人脸识别"];
        isFace =true;
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

#pragma mark - face info
-(void)facePhoto{
    UIButton *btnSelect = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-120)/2, 100, 120, 50)];
    [btnSelect setTitle:@"点击拍照识别" forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(checkFacePhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSelect.backgroundColor = kColor(@"C8");
    [self.faceBgView addSubview:btnSelect];
}

-(void)checkFacePhotoClick:(UIButton *)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;// 暂时使用相册 后台修改分辨率之后再更改拍照
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        [[AppDelegate sharedDelegate] showTextOnly:@"您暂时没有拍照权限，请打开照相机权限！"];
    }
}
#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"识别中..."];
    [[AktVipCmd sharedTool] requestFaceRecognition:@{@"customerImg":[self imageToBaseString:image],@"imgType":@"png"} type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSLog(@"---%@",responseObject);
        [[AppDelegate sharedDelegate] showTextOnly:[responseObject objectForKey:@"message"]];
        if ([[responseObject objectForKey:@"customerUkey"] isEqualToString:kString(self.orderinfo.customerUkey)]) {
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
        }
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] hidHUD];
    }];
}
#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
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
