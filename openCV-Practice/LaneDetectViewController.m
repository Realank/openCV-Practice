//
//  LaneDetectViewController.m
//  openCV-Practice
//
//  Created by Realank on 2016/10/18.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "LaneDetectViewController.h"
#import "openCVUtil.h"
@interface LaneDetectViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *laneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage1View;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage2View;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage3View;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage4View;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage5View;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage6View;

@end

@implementation LaneDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* images = [OpenCVUtil laneDetectForImage:[UIImage imageNamed:@"lane1"]];
    self.stepImage1View.image = images[0];
    self.stepImage2View.image = images[1];
    self.stepImage3View.image = images[2];
    self.stepImage4View.image = images[3];
    self.stepImage5View.image = images[4];
    self.stepImage6View.image = images[5];
    self.laneImageView.image = images[6];
}



@end
