//
//  FSCalendarHeatmapHeader.h
//  CustomUITryer
//
//  Created by Chen YU on 19/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSCalendarHeatmapHeaderDelegate;

@interface FSCalendarHeatmapHeader : UIView

@property (nonatomic, strong) NSDate *displayedDate;
@property (nonatomic, weak) id <FSCalendarHeatmapHeaderDelegate> delegate;

- (instancetype)initWithDate:(NSDate *)date;

@end

@protocol FSCalendarHeatmapHeaderDelegate <NSObject>

- (void)calendarHeatmapHeaderDidSelectToday:(FSCalendarHeatmapHeader *)header;
- (void)calendarHeatmapHeader:(FSCalendarHeatmapHeader *)header selectMonth:(NSDate *)date;

@end
