//
//  ViewController.m
//  openCV-Practice
//
//  Created by Realank on 16/4/29.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"

#import "openCVUtil.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imgView.image = [openCVUtil convertImage:[UIImage imageNamed:@"img"]];
}



@end
