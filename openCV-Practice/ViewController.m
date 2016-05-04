//
//  ViewController.m
//  openCV-Practice
//
//  Created by Realank on 16/4/29.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"
#import "VideoViewController.h"

#import "OpenCVUtil.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"very before");
    NSLog(@"before");
    self.imgView.image = [OpenCVUtil faceDetectForImage:[UIImage imageNamed:@"face"]];
    NSLog(@"after");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    VideoViewController *vc = [[VideoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
