//
//  ViewController.m
//  TestNSThreadLoadImage
//
//  Created by 吴朋 on 16/2/15.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "ViewController.h"
#import "ImageModel.h"

#define kDeviceScreenWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_2.jpg
    
    for (int i = 0; i < 12; i++) {
        for (int j = 0; j < 12; j++) {
            int row = i / 3;
            int col = j % 3;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceScreenWidth / 3.0 * col, kDeviceScreenHeight / 4.0 * row, kDeviceScreenWidth / 3.0, kDeviceScreenHeight / 4.0)];
            int tagValue = row * 3 + col + 1;
            imgView.tag = tagValue;
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            
            //开启多线程
            NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:tagValue]];
            [thread start];
            [self.view addSubview:imgView];
        }
    }
}
// 在子线程中加载数据信息
- (void)loadImage:(NSNumber *)number {
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%d.jpg", [number intValue]]];
    NSData *data = [NSData dataWithContentsOfURL:imgUrl];
    ImageModel *model = [[ImageModel alloc] init];
    model.image = [UIImage imageWithData:data];
    model.number = number;
    //图片下载完成之后 回到主线程中刷新UI
    [self performSelectorOnMainThread:@selector(reloadImageWithModel:) withObject:model waitUntilDone:YES];
}
// 回到主线程中刷新UI
- (void)reloadImageWithModel:(ImageModel *)model {
    
    UIImageView *imgView = (UIImageView*)[self.view viewWithTag:[model.number intValue]];
    imgView.image = model.image;
    
//    NSLog(@"加载完成的是第%d个图片", [model.number intValue]);
//    NSLog(@"%@", [NSThread currentThread]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
