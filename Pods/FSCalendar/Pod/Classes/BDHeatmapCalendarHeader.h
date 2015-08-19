//
//  BDHeatmapCalendarHeader.h
//  CustomUITryer
//
//  Created by Chen YU on 19/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDHeatmapCalendarHeaderDelegate;

@interface BDHeatmapCalendarHeader : UIView

@property (nonatomic, strong) NSDate *displayedDate;
@property (nonatomic, weak) id <BDHeatmapCalendarHeaderDelegate> delegate;

- (instancetype)initWithDate:(NSDate *)date;

@end

@protocol BDHeatmapCalendarHeaderDelegate <NSObject>

- (void)heatmapCalendarHeaderDidSelectToday:(BDHeatmapCalendarHeader *)header;
- (void)heatmapCalendarHeader:(BDHeatmapCalendarHeader *)header selectMonth:(NSDate *)date;

@end
