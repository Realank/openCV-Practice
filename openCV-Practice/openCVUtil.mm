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
#include <opencv2/imgproc/imgproc.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/highgui/ios.h>
#include "opencv2/highgui/highgui.hpp"
#include <opencv2/objdetect/objdetect.hpp>
#include <vector>
#include <stdio.h>
#include <iostream>
#import "linefinder.h"

#define PI 3.1415926

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

+ (NSArray*)laneDetectForImage:(UIImage*)rawImage{

    NSMutableArray *imageArray = [NSMutableArray array];
    
    cv::Mat image;
    UIImageToMat(rawImage, image);
    
    cv::Mat whiteOnly;
    cvtColor(image,whiteOnly,CV_RGB2HSV);
    cv::inRange(whiteOnly, cv::Scalar(20, 20, 20), cv::Scalar(255, 255, 255), whiteOnly);
    [imageArray addObject:MatToUIImage(whiteOnly)];//1
    cv::Mat gray;
    cv::cvtColor(image,gray,CV_RGB2GRAY);
    cv::vector<cv::string> codes;
    cv::Mat corners;
    findDataMatrix(gray, codes, corners);

    drawDataMatrixCodes(image, codes, corners);
    cv::Rect roi(0,image.cols/3,image.cols-1,image.rows - image.cols/3);// set the ROI for the image
    
    cv::Mat imgROI = image(roi);
//    [imageArray addObject:MatToUIImage(imgROI)];//1
    
    // Canny algorithm
    cv::Mat contours;
    Canny(imgROI,contours,50,250);
    cv::Mat contoursInv;
    cv::threshold(contours,contoursInv,128,255,cv::THRESH_BINARY_INV);
    [imageArray addObject:MatToUIImage(contoursInv)];//2
    /*
     Hough tranform for line detection with feedback
     Increase by 25 for the next frame if we found some lines.
     This is so we don't miss other lines that may crop up in the next frame
     but at the same time we don't want to start the feed back loop from scratch.
     */
    int houghVote = 200;
    std::vector<cv::Vec2f> lines;
    if (houghVote < 1 or lines.size() > 2){ // we lost all lines. reset
        houghVote = 200;
    }
    else{ houghVote += 25;}
    while(lines.size() < 5 && houghVote > 0){
        HoughLines(contours,lines,1,PI/180, houghVote);
        houghVote -= 5;
    }
//    std::cout << houghVote << "\n";
    cv::Mat result(imgROI.size(),CV_8U,cv::Scalar(255));
    imgROI.copyTo(result);
    
    
    // Draw the lines
    std::vector<cv::Vec2f>::const_iterator it= lines.begin();
    cv::Mat hough(imgROI.size(),CV_8U,cv::Scalar(0));
    while (it!=lines.end()) {
        
        float rho= (*it)[0];   // first element is distance rho
        float theta= (*it)[1]; // second element is angle theta
        NSLog(@"%lf",theta);
        if ( (theta > 0.1 && theta < 1.47) || (theta < 3.04 && theta > 1.67) ) { // filter to remove vertical and horizontal lines
            
            // point of intersection of the line with first row
            cv::Point pt1(rho/cos(theta),0);
            // point of intersection of the line with last row
            cv::Point pt2((rho-result.rows*sin(theta))/cos(theta),result.rows);
            // draw a white line
            line( result, pt1, pt2, cv::Scalar(255), 8);
            line( hough, pt1, pt2, cv::Scalar(255), 8);
        }
        
        //std::cout << "line: (" << rho << "," << theta << ")\n"; 
        ++it;
    }
    [imageArray addObject:MatToUIImage(result)];//3
    // Create LineFinder instance
    LineFinder ld;
    
    // Set probabilistic Hough parameters
    ld.setLineLengthAndGap(60,10);
    ld.setMinVote(4);
    
    // Detect lines
    std::vector<cv::Vec4i> li= ld.findLines(contours);
    cv::Mat houghP(imgROI.size(),CV_8U,cv::Scalar(0));
    ld.setShift(0);
    ld.drawDetectedLines(houghP);
    
    [imageArray addObject:MatToUIImage(houghP)];//4
    
    bitwise_and(houghP,hough,houghP);
    cv::Mat houghPinv(imgROI.size(),CV_8U,cv::Scalar(0));
    cv::Mat dst(imgROI.size(),CV_8U,cv::Scalar(0));
    threshold(houghP,houghPinv,150,255,cv::THRESH_BINARY_INV); // threshold and invert to black lines
    
    [imageArray addObject:MatToUIImage(houghPinv)];//5
    
    Canny(houghPinv,contours,100,350);
    li= ld.findLines(contours);
    
    [imageArray addObject:MatToUIImage(contours)];//6
    
    // Set probabilistic Hough parameters
    ld.setLineLengthAndGap(5,2);
    ld.setMinVote(1);
    ld.setShift(image.cols/3);
    ld.drawDetectedLines(image);
    
    int count = lines.size();
    NSLog(@"Lines Segments:%d",count);
    [imageArray addObject:MatToUIImage(image)];
    
    return [imageArray copy];
}

@end
