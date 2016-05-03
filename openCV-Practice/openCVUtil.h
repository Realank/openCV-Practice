//
//  OpenCVUtil.h
//  openCV-Practice
//
//  Created by Realank on 16/4/29.
//  Copyright © 2016年 realank. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface OpenCVUtil : NSObject

+ (UIImage*)convertImage:(UIImage*)image;
+ (UIImage*)faceDetectForImage:(UIImage*)image;
+ (UIImage*)circleDetectForImage:(UIImage*)image;
@end
