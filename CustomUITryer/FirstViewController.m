//
//  FirstViewController.m
//  CustomUITryer
//
//  Created by Chen YU on 7/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "FirstViewController.h"
#import "VFSNavigationBar.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detail";
    [self.navigationController setValue:[[VFSNavigationBar alloc]init] forKeyPath:@"navigationBar"];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
