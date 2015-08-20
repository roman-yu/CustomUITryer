//
//  FSCalendarHeatmapHeader.m
//  CustomUITryer
//
//  Created by Chen YU on 19/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "FSCalendarHeatmapHeader.h"

static const CGFloat buttonSize = 40.0;

@interface FSCalendarHeatmapHeader ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *todayButton;
@property (nonatomic, strong) UIButton *prevMonthButton;
@property (nonatomic, strong) UIButton *nextMonthButton;

@end

@implementation FSCalendarHeatmapHeader

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super initWithFrame:CGRectZero]) {
        
        _displayedDate = date;
        
        _dateLabel = [UILabel new];
        _dateLabel.text = @"April 2015";
        [self addSubview:_dateLabel];
        
        UIColor *cyan = [UIColor cyanColor];
        
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    static CGFloat horiMargin = 10.0;
    
    self.dateLabel.frame = CGRectMake(30, 15, 100, 40);
    
    self.nextMonthButton.frame = CGRectMake(self.frame.size.width - 30 - buttonSize, 15, buttonSize, buttonSize);
    
    self.prevMonthButton.frame = CGRectMake(self.nextMonthButton.frame.origin.x - horiMargin - buttonSize, 15, buttonSize, buttonSize);
    
    self.todayButton.frame = CGRectMake(self.prevMonthButton.frame.origin.x - horiMargin - 80, 15, 80, buttonSize);
}

- (void)gotoToday:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarHeatmapHeaderDidSelectToday:)]) {
        [self.delegate calendarHeatmapHeaderDidSelectToday:self];
    }
}

- (void)gotoPrevMonth:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarHeatmapHeader:selectMonth:)]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.displayedDate];
        if (components.month == 1) {
            components.month = 12;
            components.year -= 1;
        } else {
            components.month -= 1;
        }
        components.day = 15;
        self.displayedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        [self.delegate calendarHeatmapHeader:self selectMonth:self.displayedDate];
    }
}

- (void)gotoNextMonth:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarHeatmapHeader:selectMonth:)]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.displayedDate];
        if (components.month == 12) {
            components.month = 1;
            components.year += 1;
        } else {
            components.month += 1;
        }
        self.displayedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        [self.delegate calendarHeatmapHeader:self selectMonth:self.displayedDate];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
