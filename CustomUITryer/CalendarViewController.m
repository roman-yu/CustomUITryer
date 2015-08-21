//
//  CalendarViewController.m
//  CustomUITryer
//
//  Created by Chen YU on 17/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"
#import "SHA512.h"
#import <AWFileHash/AWFileHash.h>

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource>

@property (nonatomic, strong) FSCalendar *calendar;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /********** SHA512 **********/
    NSString *psdSalt = @"comebackfRLVP1aApYNAh3skw9U1";
    for (int i=0; i<20; i++) {
        psdSalt = [self recursiveHashed:psdSalt];
    }
    NSLog(@"20 times hashed psdSalt = %@", psdSalt);
    
    SHA512 *sha512 = [SHA512 sha512WithString:@"comeback"];
    
    // Print the MD5 digest value as string.
    // This will show "md5 = 080aef839b95facf73ec599375e92d47".
    NSLog(@"sha512 = %@", sha512);
    
    // Another way to compute.
    sha512 = [[SHA512 alloc] init];
    [sha512 updateWithString:@"Hello, world."];
    [sha512 final];
    NSLog(@"sha512 = %@", sha512);
    /********** SHA512 **********/
    
    
    static NSInteger totalLength = 20;
    
    NSString *leftText = @"hello";
    NSString *centerText = @"123";
    NSString *rightText = @"world!";
    
    NSInteger leftPartOfCenterTextLength = ceil(centerText.length/2);
    NSInteger leftPartSpaceLength = totalLength/2 - leftText.length - leftPartOfCenterTextLength;
    NSInteger rightPartSpaceLength = totalLength/2 - rightText.length - (centerText.length - leftPartOfCenterTextLength);

    
    self.view.layer.borderWidth = 1.0f;
    self.view.layer.borderColor = [UIColor magentaColor].CGColor;
    
    // In loadView or viewDidLoad
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectZero headerType:FSCalendarHeaderTypeHeatmap];
    calendar.dataSource = self;
    calendar.delegate = self;
//    calendar.firstWeekday = 2;
//    calendar.appearance.headerDateFormat = @"MMM yy";
    calendar.appearance.cellStyle = FSCalendarCellStyleRectangle;
    calendar.headerHeight = 70;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[NSDate date]];
    [components setDay:1];
    [components setHour:12];
    NSDate *firstDate = [[NSCalendar currentCalendar] dateFromComponents:components];
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [self.calendar setSelectedDate:firstDate animate:NO];
    
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[NSDate date]];
    [components setDay:2];
    [components setHour:12];
    NSDate *secondDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.calendar setSelectedDate:secondDate animate:NO];
    });
    
//    [self oneMonth];
}

- (NSString *)recursiveHashed:(NSString *)string {
    NSData *unencryptedData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [AWFileHash sha512HashOfData:unencryptedData];
}

- (NSArray *)oneMonth {
    NSRange rng = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = rng.length;
    
    NSMutableArray *datesOfOneMonth = [NSMutableArray new];
    for (int i = 0; i < numberOfDaysInMonth; i++) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[NSDate date]];
        if (components.day == i + 1) {
            continue;
        }
        [components setDay:i + 1];
        [components setHour:12];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        [datesOfOneMonth addObject:date];
        
        [self.calendar setSelectedDate:date animate:NO];
    }
    return [NSArray arrayWithArray:datesOfOneMonth];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints {
    
    [self.calendar autoCenterInSuperview];
    [self.calendar autoSetDimensionsToSize:CGSizeMake(1340/2, 981/2 + 70)];  //670, 490.5
    
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
}

- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar {
    
}

@end
