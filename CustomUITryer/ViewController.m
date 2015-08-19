//
//  ViewController.m
//  CustomUITryer
//
//  Created by Chen YU on 7/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "ViewController.h"
#import "VFSNavigationBar.h"
#import "FirstViewController.h"
#import "FontViewController.h"
#import "CalendarViewController.h"

#import "BPRTTabBar.h"

@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) FontViewController *fontVC;
@property (nonatomic, strong) CalendarViewController *calendarVC;
@property (nonatomic, strong) BPRTTabBar *tabBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:@{@"is_default": @NO}];
    [mutableDict setObject:@[@1, @2, @3] forKey:@"world"];

    self.title = @"Home";
    [self.navigationController setValue:[[VFSNavigationBar alloc]init] forKeyPath:@"navigationBar"];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoDetailPage)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
//    [self.view addSubview:self.segmentedControl];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        foo();
        NSLog(@"foo();");
        dispatch_semaphore_signal(sema);
    });
    
//    bar();
    NSLog(@"bar();");
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    self.tabBar = [[BPRTTabBar alloc] initWithTabNames:@[@"First", @"Second long long", @"Third", @"Fourth long long"]];
    [self.view addSubview:self.tabBar];
    
    self.fontVC = [[FontViewController alloc] init];
    [self displayContentController:self.fontVC];
    
    self.calendarVC = [CalendarViewController new];
    [self displayContentController:self.calendarVC];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    
//    [self.tabBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [self.tabBar autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
//    [self.tabBar autoSetDimensionsToSize:CGSizeMake(600.f, 60.f)];
    
    [self.fontVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.fontVC.view autoSetDimension:ALDimensionHeight toSize:300.f];
    
    [self.calendarVC.view autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [self.calendarVC.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.calendarVC.view autoSetDimensionsToSize:CGSizeMake(500, 500)];
    
    [super updateViewConstraints];
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"One", @"Two", @"Three"]];
        _segmentedControl.frame = CGRectMake(35, 200, 570, 40);
        [_segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 1;
    }
    return _segmentedControl;
}

#pragma mark - instances method

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];                 // 1
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

#pragma mark - User Interaction

- (void)gotoDetailPage {
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    [self.navigationController pushViewController:firstVC animated:YES];
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        [self.tabBar switchTabsAtIndex:1 withIndex:2];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
