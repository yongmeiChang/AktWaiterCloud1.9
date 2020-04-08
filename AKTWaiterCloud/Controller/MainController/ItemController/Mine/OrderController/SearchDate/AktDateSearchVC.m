//
//  AktDateSearchVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/9/20.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktDateSearchVC.h"

@interface AktDateSearchVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfStartDate;
@property (weak, nonatomic) IBOutlet UITextField *tfEndDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *viewBgBlack;
@property (weak, nonatomic) IBOutlet UIView *viewPickerBg;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;


@end

@implementation AktDateSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
#pragma mark - UIButton Action
- (IBAction)todayDate:(UIButton *)sender {
    NSLog(@" 今天");
}
- (IBAction)toWeekDate:(UIButton *)sender {
    NSLog(@"本周");
}
- (IBAction)toMounceDate:(UIButton *)sender {
    
}

- (IBAction)searchDate:(UIButton *)sender {

}
- (IBAction)cancelPicke:(UIButton *)sender {

}
- (IBAction)surePicke:(id)sender {

}
- (IBAction)starDate:(UIButton *)sender {
  
}
- (IBAction)endDate:(UIButton *)sender {

}
#pragma mark - PickeView delegate
- (IBAction)ValueChage:(UIDatePicker *)sender {
   
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
