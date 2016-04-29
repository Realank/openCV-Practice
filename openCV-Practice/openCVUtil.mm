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
#import <opencv2/imgcodecs/ios.h>

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

+ (UIImage*)faceDetectForImage:(UIImage*)image {
    cv::CascadeClassifier faceDetector;
    // 添加xml文件
    NSString* cascadePath = [[NSBundle mainBundle]
                             pathForResource:@"haarcascade_frontalface_alt"
                             ofType:@"xml"];
    faceDetector.load([cascadePath UTF8String]);
    
    cv::Mat faceImage;
    UIImageToMat(image, faceImage);
    
    // 转为灰度
    cv::Mat gray;
    cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    // 检测人脸并储存
    std::vector<cv::Rect>faces;
    faceDetector.detectMultiScale(gray, faces,1.1,2,0|CV_HAAR_SCALE_IMAGE,cv::Size(30,30));
    
    // 在每个人脸上画一个红色四方形
    for(unsigned int i= 0;i < faces.size();i++)
    {
        const cv::Rect& face = faces[i];
        cv::Point tl(face.x,face.y);
        cv::Point br = tl + cv::Point(face.width,face.height);
        
        // 四方形的画法
        cv::Scalar magenta = CV_RGB(0.5,0,0);//cv::Scalar(255, 0, 255);
        cv::rectangle(faceImage, tl, br, cv::Scalar( 255, 0, 0 ), 11, 8, 0);
    }
    
    return MatToUIImage(faceImage);
}

@end
