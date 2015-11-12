//
//  FYBlurView.h
//  CleanMaskView
//
//  Created by mac on 15/11/11.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYBlurView : UIView

/**
 *  模糊系数,默认是0.15
 */
@property (nonatomic, assign) CGFloat blurAmount;

@property (nonatomic, strong) UIView* contentView;

@end
