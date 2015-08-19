//
//  BDHeatmapCalendarHeader.m
//  CustomUITryer
//
//  Created by Chen YU on 19/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "BDHeatmapCalendarHeader.h"
#import "PureLayout.h"

@interface BDHeatmapCalendarHeader ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *todayButton;
@property (nonatomic, strong) UIButton *prevMonthButton;
@property (nonatomic, strong) UIButton *nextMonthButton;

@end

@implementation BDHeatmapCalendarHeader

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super initWithFrame:CGRectZero]) {
        
        _displayedDate = date;
        
        _dateLabel = [UILabel new];
        _dateLabel.text = @"April 2015";
        [self addSubview:_dateLabel];
        
        UIColor *cyan = [UIColor cyanColor];
        UIColor *red = [UIColor redColor];
        
        _todayButton = [UIButton new];
        _todayButton.backgroundColor = cyan;
        [_todayButton setTitle:@"Today" forState:UIControlStateNormal];
        [_todayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_todayButton addTarget:self action:@selector(gotoToday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_todayButton];
        
        _prevMonthButton = [UIButton new];
        _prevMonthButton.backgroundColor = cyan;
        [_prevMonthButton setTitle:@"<" forState:UIControlStateNormal];
        [_prevMonthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_prevMonthButton addTarget:self action:@selector(gotoPrevMonth:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_prevMonthButton];
        
        _nextMonthButton = [UIButton new];
        _nextMonthButton.backgroundColor = cyan;
        [_nextMonthButton setTitle:@">" forState:UIControlStateNormal];
        [_nextMonthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextMonthButton addTarget:self action:@selector(gotoNextMonth:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextMonthButton];
    }
    return self;
}

- (void)updateConstraints {
    
    self.layoutMargins = UIEdgeInsetsMake(15, 30, 15, 30);
    
    [self.dateLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
    
//    [self.nextMonthButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
    
//    [@[self.todayButton, self.prevMonthButton, self.nextMonthButton] autoDistributeViewsAlongAxis:ALAxisBaseline alignedTo:ALAttributeBaseline withFixedSpacing:10.f insetSpacing:YES];
    
    [self.nextMonthButton autoPinEdgeToSuperviewMargin:ALEdgeRight];
    [self.nextMonthButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    [self.nextMonthButton autoSetDimension:ALDimensionWidth toSize:40.f];
    
    [self.prevMonthButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.nextMonthButton withOffset:-10.f];
    [self.prevMonthButton autoSetDimension:ALDimensionWidth toSize:40.f];
    
    [self.todayButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.prevMonthButton withOffset:-10.f];
    [self.todayButton autoSetDimension:ALDimensionWidth toSize:80.0];
    
    [@[self.todayButton, self.prevMonthButton, self.nextMonthButton] autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.todayButton, self.prevMonthButton, self.nextMonthButton] autoMatchViewsDimension:ALDimensionHeight];
    
    [super updateConstraints];
}

- (void)gotoToday:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heatmapCalendarHeaderDidSelectToday:)]) {
        [self.delegate heatmapCalendarHeaderDidSelectToday:self];
    }
}

- (void)gotoPrevMonth:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heatmapCalendarHeader:selectMonth:)]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.displayedDate];
        if (components.month == 1) {
            components.month = 12;
            components.year -= 1;
        } else {
            components.month -= 1;
        }
        components.day = 15;
        self.displayedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        [self.delegate heatmapCalendarHeader:self selectMonth:self.displayedDate];
    }
}

- (void)gotoNextMonth:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heatmapCalendarHeader:selectMonth:)]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.displayedDate];
        if (components.month == 12) {
            components.month = 1;
            components.year += 1;
        } else {
            components.month += 1;
        }
        self.displayedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        [self.delegate heatmapCalendarHeader:self selectMonth:self.displayedDate];
    }
}

@end
