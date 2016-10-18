//
//  OpenCVUtil.m
//  openCV-Practice
//
//  Created by Realank on 16/4/29.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "OpenCVUtil.h"
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/highgui/ios.h>

@interface OpenCVUtil (){

}

@end

@implementation OpenCVUtil

+ (UIImage*)convertImage:(UIImage*)image {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    if(!cvImage.empty()){
        cv::Mat gray;
        // 将图像转换为灰度显示
        cv::cvtColor(cvImage,gray,CV_RGB2GRAY);
        // 应用高斯滤波器去除小的边缘
        cv::GaussianBlur(gray, gray, cv::Size(5,5), 1.2,1.2);
        // 计算与画布边缘
        cv::Mat edges;
        cv::Canny(gray, edges, 0, 50);
        // 使用白色填充
        cvImage.setTo(cv::Scalar::all(225));
        // 修改边缘颜色
        cvImage.setTo(cv::Scalar(0,128,255,255),edges);
        // 将Mat转换为Xcode的UIImageView显示
        return MatToUIImage(cvImage);
    }
    return nil;
}

+ (NSArray*)facePointDetectForImage:(UIImage*)image{
    
    static cv::CascadeClassifier faceDetector;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 添加xml文件
        NSString* cascadePath = [[NSBundle mainBundle]
                                 pathForResource:@"haarcascade_frontalface_alt2"
                                 ofType:@"xml"];
        faceDetector.load([cascadePath UTF8String]);
    });
    
    
    cv::Mat faceImage;
    UIImageToMat(image, faceImage);
    
    // 转为灰度
    cv::Mat gray;
    cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    // 检测人脸并储存
    std::vector<cv::Rect>faces;
    faceDetector.detectMultiScale(gray, faces,1.1,2,CV_HAAR_FIND_BIGGEST_OBJECT,cv::Size(30,30));
    
    NSMutableArray *array = [NSMutableArray array];

    for(unsigned int i= 0;i < faces.size();i++)
    {
        const cv::Rect& face = faces[i];
//        NSLog(@"image:%d,%d,\ndetect:\nstart:%d,%d,%d,%d",faceImage.rows, faceImage.cols,face.x,face.y,face.width,face.height );
        float height = (float)faceImage.rows;
        float width = (float)faceImage.cols;
        CGRect rect = CGRectMake(face.x/width, face.y/height, face.width/width, face.height/height);
        [array addObject:[NSNumber valueWithCGRect:rect]];
        
    }
    
    
    return [array copy];
}

+ (UIImage*)faceDetectForImage:(UIImage*)image {
//    cv::CascadeClassifier faceDetector;
//    // 添加xml文件
//    NSString* cascadePath = [[NSBundle mainBundle]
//                             pathForResource:@"haarcascade_frontalface_alt"
//                             ofType:@"xml"];
//    faceDetector.load([cascadePath UTF8String]);
    static cv::CascadeClassifier faceDetector;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 添加xml文件
        NSString* cascadePath = [[NSBundle mainBundle]
                                 pathForResource:@"haarcascade_frontalface_alt"
                                 ofType:@"xml"];
        faceDetector.load([cascadePath UTF8String]);
    });
    
    
    cv::Mat faceImage;
    UIImageToMat(image, faceImage);
    
    // 转为灰度
    cv::Mat gray;
    cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    NSLog(@"%d",faceImage.channels());
    
    // 检测人脸并储存
    std::vector<cv::Rect>faces;
    faceDetector.detectMultiScale(gray, faces,1.1,2,0,cv::Size(30,30));
    
    // 在每个人脸上画一个红色四方形
    for(unsigned int i= 0;i < faces.size();i++)
    {
        const cv::Rect& face = faces[i];
        cv::Point tl(face.x,face.y);
        cv::Point br = tl + cv::Point(face.width,face.height);
        // 四方形的画法
        cv::Scalar magenta = cv::Scalar(255, 0, 0, 255);
        cv::rectangle(faceImage, tl, br, magenta, 11, 8, 0);
    }
    
    return MatToUIImage(faceImage);
}

+ (UIImage*)circleDetectForImage:(UIImage*)image{
    cv::Mat circleImage,src_gray;
    UIImageToMat(image, circleImage);
    /// Convert it to gray
    cvtColor( circleImage, src_gray, CV_BGR2GRAY );
    
    /// Reduce the noise so we avoid false circle detection
    GaussianBlur( src_gray, src_gray, cv::Size(9, 9), 2, 2 );
    
    std::vector<cv::Vec3f> circles;
    
    /// Apply the Hough Transform to find the circles
    HoughCircles( src_gray, circles, CV_HOUGH_GRADIENT, 1, src_gray.rows/8, 200, 100, 0, 0 );
    
    /// Draw the circles detected
    for( size_t i = 0; i < circles.size(); i++ )
    {
        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
        int radius = cvRound(circles[i][2]);
        // circle center
        circle( circleImage, center, 3, cv::Scalar(0,255,0,255), -1, 8, 0 );
        // circle outline
        circle( circleImage, center, radius, cv::Scalar(0,0,255,255), 3, 8, 0 );
    }
    
    /// Show your results
    
    return MatToUIImage(circleImage);
    
    
}

@end
