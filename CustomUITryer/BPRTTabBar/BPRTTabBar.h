//
//  BPRTTabBar.h
//  ChildVCPureLayoutTryer
//
//  Created by Chen YU on 26/6/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BPTabBarDelegate;

@interface BPRTTabBar : UIView
//{
//@protected
//    Class _classOfPopoverViewController;
//}

@property (nonatomic, assign) BOOL isEditMode;      //default: NO
@property (nonatomic, weak) id <BPTabBarDelegate> delegate;

@property (nonatomic, strong) UIButton *editButton;

- (instancetype)initWithTabNames:(NSArray *)tabNames;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)setEditMode:(BOOL)isEditMode;

- (void)updateTabWithName:(NSString *)tabName atIndex:(NSInteger)index;
- (void)switchTabsAtIndex:(NSInteger)index1 withIndex:(NSInteger)index2;
- (void)insertTabWithName:(NSString *)tabName atIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
//- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

- (void)editButtonPressed:(UIButton *)sender;
- (void)didSelectTabAtIndex:(NSInteger)index;

@end

@protocol BPTabBarDelegate  <NSObject>

- (void)tabBar:(BPRTTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index;

@optional
- (void)tabBarDidPressEditButton;

@end