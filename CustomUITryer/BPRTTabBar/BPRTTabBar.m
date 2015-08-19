//
//  BPRTTabBar.m
//  ChildVCPureLayoutTryer
//
//  Created by Chen YU on 26/6/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "BPRTTabBar.h"
#import "BDConstraintButton.h"
//#import "BPScrollableIndicator.h"

CGFloat const tabWidth = 664.f / 3.f;
CGFloat const tabMinimumWidth = 90.f;
CGFloat const tabHeight = 40.f;
CGFloat const tabTextHoriPadding = 20.f;
CGFloat const posIndicViewWidth = 40.f;
CGFloat const cornerRadius = 6.f;
NSUInteger const tagPrefix = 10000;

@interface BPRTTabBar () <UIScrollViewDelegate> {
    BOOL goingToHideLeftIndic;      //default NO
    BOOL goingToHideRightIndic;     //default NO
    NSInteger _selectedIndex;
}

@property (nonatomic, assign) NSInteger insertIndex;
@property (nonatomic, assign) NSInteger removeIndex;

@property (nonatomic, assign) NSInteger switchIndex1;
@property (nonatomic, assign) NSInteger switchIndex2;

@property (nonatomic, assign) BOOL didInitTabWidthArr;
@property (nonatomic, assign) BOOL needUpdateTabWidth;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSMutableArray *constraints;
@property (nonatomic, strong) NSMutableArray *widthConstraints;

@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, strong) UIScrollView *tabsContainer;
@property (nonatomic, strong) NSMutableArray *tabWidthArr;

//@property (nonatomic, strong) BPScrollableIndicator *leftScrollableIndic;
//@property (nonatomic, strong) BPScrollableIndicator *rightScrollableIndic;

@end

@implementation BPRTTabBar

- (instancetype)initWithTabNames:(NSArray *)tabNames
{
    if (self = [super initForAutoLayout])
    {
        _selectedIndex = 0;
        
        goingToHideLeftIndic = YES;
        goingToHideRightIndic = YES;
        self.isEditMode = NO;
        
        [self resetIndexes];
        self.didInitTabWidthArr = NO;
        self.didSetupConstraints = NO;
        
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self addSubview:self.tabsContainer];
//        self.tabsContainer.contentSize = CGSizeMake(tabWidth * tabNames.count, tabHeight);
        
        [self initTabViews:tabNames];
        
//        self.leftScrollableIndic.hidden = YES;
//
//        [self addSubview:self.leftScrollableIndic];
//        [self addSubview:self.rightScrollableIndic];
//        
//        [self bringSubviewToFront:self.leftScrollableIndic];
//        [self bringSubviewToFront:self.rightScrollableIndic];
        
        self.editButton = [UIButton new];
        self.editButton.hidden = YES;
        [self.editButton setContentMode:UIViewContentModeCenter];
        [self.editButton setImage:[UIImage imageNamed:@"more"]
                         forState:UIControlStateNormal];
        [self.editButton setBackgroundColor:[UIColor whiteColor]];
        [self.editButton addTarget:self
                            action:@selector(editButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.editButton];
    }
    return self;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    __block NSMutableArray *tabNames = [NSMutableArray new];
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((UIViewController *)obj).title) {
            [tabNames addObject:((UIViewController *)obj).title];
        }
    }];
    return [self initWithTabNames:tabNames];
}

- (void)setEditMode:(BOOL)isEditMode
{
    self.isEditMode = isEditMode;
    self.editButton.hidden = !isEditMode;
}

- (void)updateTabWithName:(NSString *)tabName
                  atIndex:(NSInteger)index
{
    [((BDConstraintButton *)[self.tabs objectAtIndex:index]) setTitle:tabName
                                                   forState:UIControlStateNormal];
}

- (void)switchTabsAtIndex:(NSInteger)index1 withIndex:(NSInteger)index2
{
    if (index1 < [self.tabs count] && index1 > -1 && index2 < [self.tabs count] && index2 > -1 && index1 != index2) {
        self.switchIndex1 = index1 > index2 ? index2 : index1;
        self.switchIndex2 = index1 > index2 ? index1 : index2;
        
        [self.tabs exchangeObjectAtIndex:self.switchIndex1 withObjectAtIndex:self.switchIndex2];
        
        [self _resetTabTags];
        
        // update selected index
        if (_selectedIndex == self.switchIndex1 || _selectedIndex == self.switchIndex2) {
            if (_selectedIndex == self.switchIndex1) {
                _selectedIndex = self.switchIndex2;
            } else {
                _selectedIndex = self.switchIndex1;
            }
        }
        
        self.needUpdateTabWidth = YES;
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
}

- (void)insertTabWithName:(NSString *)tabName
                  atIndex:(NSInteger)index
{
    self.insertIndex = index;
    
    UIButton *newTab = [self createTabWithTitle:tabName atIndex:index];
    [self.tabs insertObject:newTab atIndex:index];
    [self.tabsContainer insertSubview:newTab atIndex:index];
    [self _resetTabTags];
    
    // update selected index
    [self _updateSelectedForInsertAt:index];
    
    self.tabsContainer.contentSize = CGSizeMake(tabWidth * self.tabs.count, tabHeight);
    
    self.needUpdateTabWidth = YES;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)removeTabAtIndex:(NSInteger)index
{
    self.removeIndex = index;
    
    [self.tabsContainer.subviews[index] removeFromSuperview];
    [self.tabs removeObjectAtIndex:index];
    [self _resetTabTags];
    
    // update selected index
    [self _updateSelectedForRemoveAt:index];
    
    self.tabsContainer.contentSize = CGSizeMake(tabWidth * self.tabs.count, tabHeight);
    
    self.needUpdateTabWidth = YES;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)_resetTabTags
{
    [self.tabs enumerateObjectsUsingBlock:^(UIButton *tabButton, NSUInteger idx, BOOL *stop) {
        tabButton.tag = idx + tagPrefix;
    }];
}

- (void)_updateSelectedForInsertAt:(NSInteger)index
{
    if (index < _selectedIndex) {
        _selectedIndex ++;
    }
}

- (void)_updateSelectedForRemoveAt:(NSInteger)index
{
    if (index <= _selectedIndex) {
        _selectedIndex --;
    }
    
    if (_selectedIndex < 0)
    {
        _selectedIndex = 0;
    }
}

#pragma mark - Layout

- (void)initTabViews:(NSArray *)tabNames {
    
    typeof(self) __weak weakSelf = self;
    
    [tabNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        UIButton *tab = [self createTabWithTitle:obj atIndex:idx];
        [weakSelf.tabs addObject:tab];
        [weakSelf.tabsContainer addSubview:tab];
    }];
}

- (void)reloadTabs {
    [self.tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *tab = obj;
        if (_selectedIndex == idx) {
            [tab setBackgroundColor:[UIColor cyanColor]];
        } else {
            [tab setBackgroundColor:[UIColor whiteColor]];
        }
    }];
}

- (NSArray *)tabWidthArr {
    if (!_tabWidthArr) {
        _tabWidthArr = [NSMutableArray new];
    }
    return _tabWidthArr;
}

- (void)_reloadTabWidthArr {
    __block NSMutableArray *tabWidthArr = [NSMutableArray new];
    __block NSInteger totalWidth = 0;
    [self.tabs enumerateObjectsUsingBlock:^(UIButton *tab, NSUInteger idx, BOOL *stop) {
        NSDictionary *textAttributes = @{NSFontAttributeName: tab.titleLabel.font,
                                         NSForegroundColorAttributeName: tab.titleLabel.textColor};
        CGSize size = [tab.titleLabel.text sizeWithAttributes:textAttributes];
        
        size.width += tabTextHoriPadding * 2;
        if (size.width < tabMinimumWidth) {
            size.width = tabMinimumWidth;
        }
        
        totalWidth += size.width;
        [tabWidthArr addObject:[NSNumber numberWithInteger:size.width]];
    }];
    if (totalWidth < self.frame.size.width) {
        [tabWidthArr enumerateObjectsUsingBlock:^(NSNumber *tabWidth, NSUInteger idx, BOOL *stop) {
            tabWidthArr[idx] = [NSNumber numberWithFloat:[tabWidth floatValue] + (self.frame.size.width - totalWidth) / tabWidthArr.count];
        }];
    }
    __block CGFloat contentWidth = 0.f;
    [tabWidthArr enumerateObjectsUsingBlock:^(NSNumber *tabWidth, NSUInteger idx, BOOL *stop) {
        contentWidth += [tabWidth floatValue];
    }];
    self.tabsContainer.contentSize = CGSizeMake(contentWidth, tabHeight);
    _tabWidthArr = tabWidthArr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.rightScrollableIndic.hidden = !(self.tabsContainer.contentSize.width > self.frame.size.width);
    
    /**
     Raven's logic to dynamically adjust the width of tab bar.
     1. Each tab should be 180px (@2x) minimum in width.
     2. There should be 40px (@2x) left margin and 40px (@2x) right margin for the text on the tab.
     3. If all the tabs together is below the width of the whole tab bar - 1200px (@2x), share the remaining width equally with the tabs.
     Example 1: only one tab ---> that tab is 1200px wide.
     Example 2: only three tabs, first tab is 180px, second tab is 280px, third tab is 200px ---> the three tabs will share the remaining 540px ---> first tab becomes 360px, second tab becomes 460px, third tab becomes 380px.
     */
    if (!CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        self.didInitTabWidthArr = YES;
        [self _reloadTabWidthArr];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
}

- (void)updateConstraints {
    
    [self _reloadTabWidthArr];
    
    [self.tabsContainer.constraints autoRemoveConstraints];
    [self.tabsContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    typeof(self) __weak weakSelf = self;
    
    [self.tabs enumerateObjectsUsingBlock:^(BDConstraintButton *tab, NSUInteger idx, BOOL *stop) {
        BDConstraintButton *prevTab;
        
        [tab.constraints autoRemoveConstraints];
        if (idx == 0) {
            tab.leftConstraint = [tab autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:weakSelf.tabsContainer];
        } else {
            prevTab = [weakSelf.tabs objectAtIndex:(idx - 1)];
            //                [weakSelf.constraints addObject:[tab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:prevTab]];
            tab.leftConstraint = [tab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:prevTab];
        }
        [tab autoAlignAxis:ALAxisHorizontal toSameAxisOfView:weakSelf.tabsContainer];
        [tab autoSetDimension:ALDimensionWidth toSize:[weakSelf.tabWidthArr[idx] floatValue]];
        [tab autoSetDimension:ALDimensionHeight toSize:tabHeight];
    }];
    
    if (self.needUpdateTabWidth) {
        self.needUpdateTabWidth = NO;
        
        typeof(self) __weak weakSelf = self;
        [self.tabs enumerateObjectsUsingBlock:^(UIButton *tab, NSUInteger idx, BOOL *stop) {
            [tab autoSetDimension:ALDimensionWidth toSize:[weakSelf.tabWidthArr[idx] floatValue]];
        }];
    }
    
    [self resetIndexes];
    [self _resetTabTags];
    
    if (!self.didSetupConstraints) {
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Getters

- (NSMutableArray *)constraints {
    if (!_constraints) {
        _constraints = [NSMutableArray new];
    }
    return _constraints;
}

- (NSMutableArray *)widthConstraints {
    if (!_widthConstraints) {
        _widthConstraints = [NSMutableArray new];
    }
    return _widthConstraints;
}

- (UIScrollView *)tabsContainer {
    if (!_tabsContainer) {
        _tabsContainer = [UIScrollView newAutoLayoutView];
        _tabsContainer.delegate = self;
        _tabsContainer.delaysContentTouches = YES;
        [_tabsContainer setShowsHorizontalScrollIndicator:NO];
    }
    return _tabsContainer;
}

- (NSMutableArray *)tabs {
    if (!_tabs) {
        _tabs = [NSMutableArray new];
    }
    return _tabs;
}

//- (BPScrollableIndicator *)leftScrollableIndic {
//    if (!_leftScrollableIndic) {
//        _leftScrollableIndic = [[BPScrollableIndicator alloc] initWithDirection:BPScrollableIndicatorDirectionLeft];
//    }
//    return _leftScrollableIndic;
//}
//
//- (BPScrollableIndicator *)rightScrollableIndic {
//    if (!_rightScrollableIndic) {
//        _rightScrollableIndic = [[BPScrollableIndicator alloc] initWithDirection:BPScrollableIndicatorDirectionRight];
//    }
//    return _rightScrollableIndic;
//}

#pragma mark - Private

- (void)resetIndexes {
    self.insertIndex = -1;
    self.removeIndex = -1;
    self.switchIndex1 = -1;
    self.switchIndex2 = -1;
}

- (UIButton *)createTabWithTitle:(NSString *)title atIndex:(NSInteger)idx {
    BDConstraintButton *tab = [BDConstraintButton newAutoLayoutView];
    tab.tag = tagPrefix + idx;
    [tab addTarget:self action:@selector(didSelectTabWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [tab setTitle:title forState:UIControlStateNormal];
    tab.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:15.f];
    if (_selectedIndex == idx) {
        [tab setSelected:YES];
        [tab setBackgroundColor:[UIColor cyanColor]];
    } else {
        [tab setSelected:NO];
        [tab setBackgroundColor:[UIColor whiteColor]];
    }
    [tab setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return tab;
}

- (void)addOrReplaceObjectAtIndex:(NSInteger)index withObject:(id)object {
    if (index < self.widthConstraints.count) {
        [self.widthConstraints[index] autoRemove];
        [self.widthConstraints replaceObjectAtIndex:index withObject:object];
    } else {
        [self.widthConstraints addObject:object];
    }
}

- (void)addOrReplaceObjectForConstraintsArray:(NSMutableArray *)constraints AtIndex:(NSInteger)index withObject:(id)object {
    if (index < constraints.count) {
        [constraints[index] autoRemove];
        [constraints replaceObjectAtIndex:index withObject:object];
    } else {
        [constraints addObject:object];
    }
}

#pragma mark - Button

- (void)editButtonPressed:(UIButton *)sender {
    
}

- (void)didSelectTabWithTag:(id)sender {
    
    [((UIButton *)[self.tabs objectAtIndex:_selectedIndex]) setSelected:NO];
    _selectedIndex = ((UIButton *)sender).tag - tagPrefix;
    [((UIButton *)[self.tabs objectAtIndex:_selectedIndex]) setSelected:YES];
    [self reloadTabs];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectTabAtIndex:)]) {
        [self.delegate tabBar:self didSelectTabAtIndex:_selectedIndex];
    }
}

- (void)didSelectTabAtIndex:(NSInteger)index
{
    if (index > -1 && index < [self.tabs count]) {
        [((UIButton *)[self.tabs objectAtIndex:_selectedIndex]) setSelected:NO];
        _selectedIndex = index;
        [((UIButton *)[self.tabs objectAtIndex:_selectedIndex]) setSelected:YES];
        [self reloadTabs];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectTabAtIndex:)]) {
            [self.delegate tabBar:self didSelectTabAtIndex:_selectedIndex];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    if (self.tabsContainer.contentOffset.x <= 0 && !self.leftScrollableIndic.hidden) {
//        self.leftScrollableIndic.hidden = YES;
//    } else if (self.tabsContainer.contentOffset.x > 0 && self.leftScrollableIndic.hidden) {
//        self.leftScrollableIndic.hidden = NO;
//    }
//    
//    if (self.tabsContainer.contentOffset.x >= self.tabsContainer.contentSize.width - self.frame.size.width && !self.rightScrollableIndic.hidden) {
//        self.rightScrollableIndic.hidden = YES;
//    } else if (self.tabsContainer.contentOffset.x < self.tabsContainer.contentSize.width - self.frame.size.width && self.rightScrollableIndic.hidden) {
//        self.rightScrollableIndic.hidden = NO;
//    }
}

@end
