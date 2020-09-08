//
//  AktOrderDetailsModel.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/16.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import "AktOrderDetailsModel.h"

@implementation AktOrderDetailsModel

@end
@implementation AktFindAdvanceModel

-(void)saveDetailsModel
{
    NSDictionary *local;
    NSString *path = [AktUtil getCachePath:@"AktFindAdvanceModel"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        local= [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self toDictionary]];
    [dict writeToFile:path atomically:YES];
}

-(AktFindAdvanceModel *)getDetailsModel
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:Token]){
              NSString *path = [AktUtil getCachePath:@"AktFindAdvanceModel"];
              if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
                  return [[AktFindAdvanceModel alloc] initWithDictionary:dict error:nil];
              }
          }
          return nil;
    
}

@end


@implementation DownOrderUserInfo

@end
