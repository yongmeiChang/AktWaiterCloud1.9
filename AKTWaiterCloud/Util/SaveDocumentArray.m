//
//  SaveDocumentArray.m
//  AnKangTong
//
//  Created by juli on 2017/4/25.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import "SaveDocumentArray.h"

@implementation SaveDocumentArray
static SaveDocumentArray *app_instance = nil;

+ (SaveDocumentArray *)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        app_instance = [[SaveDocumentArray alloc]init];
        
    });
    
    return app_instance;
}
//沙盒存入数组
- (void)saveArray:(NSArray *)array
{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    // 3.新建数据
    //    MJPerson *p = [[MJPerson alloc] init];
    //    p.name = @"rose";
    
    NSArray *data = array;
    
    
    NSString *filepath = [docPath stringByAppendingPathComponent:@"data1.plist"];
    
    
    [data writeToFile:filepath atomically:YES];
}
//读取沙盒数组
- (NSArray *)read {
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    // 3.文件路径
    NSString *filepath = [docPath stringByAppendingPathComponent:@"data1.plist"];
    
    // 4.读取数据
    NSArray *data = [NSArray arrayWithContentsOfFile:filepath];
    NSLog(@"%@", data);
    return data;
}

- (void)deleteDocumentArray{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
//    NSString * docpathUserDb = [docPath stringByAppendingString:@"/MyDatabase.db"];
//    NSFileManager * UserDbFile = [NSFileManager defaultManager];
//    BOOL dbhave = [UserDbFile fileExistsAtPath:docpathUserDb];
//    if(dbhave){
//        BOOL isok = [UserDbFile removeItemAtPath:docpathUserDb error:nil];
//        if(isok){
//            DDLogInfo(@"MyDatabase.db删除成功");
//        }else{
//            DDLogInfo(@"MyDatabase.db删除失败");
//        }
//    }else{
//        DDLogInfo(@"MyDatabase.db文件不存在");
//    }
    
    // 3.文件路径
//    NSString *filepath = [docPath stringByAppendingPathComponent:@"data1.plist"];
    //4.删除文件
//    NSFileManager* fileManager=[NSFileManager defaultManager];
//    BOOL blHave = [fileManager fileExistsAtPath:filepath];
//    if (!blHave) {
//        NSLog(@"no have");
//        return;
//    }else{
//        NSLog(@"have");
//        BOOL res = [fileManager removeItemAtPath:filepath error:nil];
//        if (res) {
//            NSLog(@"delete success");
//        }else{
//            NSLog(@"felete fail");
//        }
//    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:docPath error:NULL]) {
        NSLog(@"Removed successfully");
    }
}

-(void)removefmdb{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString * docpathUserDb = [docPath stringByAppendingString:@"/MyDatabase.db"];
    NSFileManager * UserDbFile = [NSFileManager defaultManager];
    BOOL dbhave = [UserDbFile fileExistsAtPath:docpathUserDb];
    if(dbhave){
        BOOL isok = [UserDbFile removeItemAtPath:docpathUserDb error:nil];
        if(isok){
            DDLogInfo(@"MyDatabase.db删除成功");
        }else{
            DDLogInfo(@"MyDatabase.db删除失败");
        }
    }else{
        DDLogInfo(@"MyDatabase.db文件不存在");
    }
}

-(void)removeTrapWithName:(NSString *)trapName{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents/tempAudio/"];
    NSString * docpathTrapName = [docPath stringByAppendingString:trapName];
    NSFileManager * TrapNameFile = [NSFileManager defaultManager];
    BOOL dbhave = [TrapNameFile fileExistsAtPath:docpathTrapName];
    if(dbhave){
        BOOL isok = [TrapNameFile removeItemAtPath:docpathTrapName error:nil];
        if(isok){
            DDLogInfo(@"录音删除成功");
        }else{
            DDLogInfo(@"录音删除失败");
        }
    }else{
        DDLogInfo(@"录音文件不存在");
    }
}


//沙盒存入数组
- (void)saveArray:(NSArray *)array FileName:(NSString *)fileName
{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    // 3.新建数据
    //    MJPerson *p = [[MJPerson alloc] init];
    //    p.name = @"rose";
    
    NSArray *data = array;
    
    
    NSString *filepath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    
    [data writeToFile:filepath atomically:YES];
}
//读取沙盒数组
- (NSArray *)readFileName:(NSString *)fileName{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    // 3.文件路径
    NSString *filepath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    // 4.读取数据
    NSArray *data = [NSArray arrayWithContentsOfFile:filepath];
    NSLog(@"%@", data);
    return data;
}
//删除沙盒文件
- (void)deleteFileName:(NSString *)fileName{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    // 3.文件路径
    NSString *filepath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    //4.删除文件
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave = [fileManager fileExistsAtPath:filepath];
    if (!blHave) {
        NSLog(@"no have");
        return;
    }else{
        NSLog(@"have");
        BOOL res = [fileManager removeItemAtPath:filepath error:nil];
        if (res) {
            NSLog(@"delete success");
        }else{
            NSLog(@"felete fail");
        }
    }
}


@end
