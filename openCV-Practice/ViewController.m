//
//  ViewController.m
//  openCV-Practice
//
//  Created by Realank on 16/4/29.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"

#import "OpenCVUtil.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imgView.image = [OpenCVUtil circleDetectForImage:[UIImage imageNamed:@"face"]];
}



@end
