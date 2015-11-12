//
//  FYBlurView.m
//  CleanMaskView
//
//  Created by mac on 15/11/11.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "FYBlurView.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@interface FYBlurView ()

@property (nonatomic, strong) UIWindow* showWindow;
@end

@implementation FYBlurView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.showWindow addSubview:self.contentView];
    }
    
    return self;
}

- (void)didMoveToWindow
{
    [self setBackImage];
}

- (void)setBackImage
{
    UIView* snapView = [UIApplication sharedApplication].keyWindow;
    NSData* imageData = UIImageJPEGRepresentation(screenshot(snapView), .0001f);
    
    UIImage *blurredImage = [self blurredImage:self.blurAmount image:[UIImage imageWithData:imageData]];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = blurredImage;

    [self.contentView addSubview:imageView];
    [self.contentView sendSubviewToBack:imageView];
    [self.showWindow makeKeyAndVisible];
}

UIImage * screenshot(UIView *view)
{
    UIGraphicsBeginImageContext(view.frame.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)blurredImage:(CGFloat)blurAmount image:(UIImage*)image
{
    if (blurAmount < 0.0 || blurAmount > 1.0) {
        blurAmount = 0.5;
    }
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (!error) {
            error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (CGFloat)blurAmount
{
    if (!_blurAmount) {
        
        _blurAmount = 0.15;
    }
    
    return _blurAmount;
}

- (UIWindow *)showWindow
{
    if (!_showWindow) {
        
        _showWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _showWindow.windowLevel = UIWindowLevelAlert;
    }
    
    return _showWindow;
}

- (UIView *)contentView
{
    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    
    return _contentView;
}

@end
