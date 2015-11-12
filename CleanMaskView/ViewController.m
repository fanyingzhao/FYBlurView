//
//  ViewController.m
//  CleanMaskView
//
//  Created by mac on 15/11/11.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "FYBlurView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"范范好牛逼啊啊啊啊啊啊";
    
    FYBlurView* blur = [[FYBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:blur];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    view.backgroundColor = [UIColor redColor];
    [blur.contentView addSubview:view];
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    view1.backgroundColor = [UIColor redColor];
    [blur.contentView addSubview:view1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
