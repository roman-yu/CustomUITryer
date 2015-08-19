//
//  FontViewController.m
//  CustomUITryer
//
//  Created by Chen YU on 17/8/15.
//  Copyright (c) 2015 Chen YU. All rights reserved.
//

#import "FontViewController.h"

const CGFloat labelWidth = 500.f;

@interface FontViewController ()

@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, strong) UILabel *latoLabel;
@property (nonatomic, strong) UILabel *ptSansLabel;

@property (nonatomic, strong) UIImageView *labelImageView;

@property (nonatomic, strong) UIView *labelContainer;
@property (nonatomic, strong) UILabel *label;

@end

@implementation FontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    "Lato-Regular",
//    "Lato-Bold"
//    "PTSans-NarrowBold",
//    "PTSans-Narrow"

    self.view.backgroundColor = [UIColor orangeColor];
    [self printAllFonts];
    
    UIFont *defaultFont = [UIFont systemFontOfSize:14.f];
    UIFont *latoFont = [UIFont fontWithName:@"Lato-Regular" size:14.F];
    UIFont *ptSansFont = [UIFont fontWithName:@"PTSans-Narrow" size:14.F];
    
    self.defaultLabel = [UILabel new];
    self.defaultLabel.text = @"Hello world";
    self.defaultLabel.font = defaultFont;
    self.defaultLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.defaultLabel];
    
    self.latoLabel = [UILabel new];
    self.latoLabel.text = @"Hello world";
    self.latoLabel.font = latoFont;
    self.latoLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.latoLabel];
    
    self.ptSansLabel = [UILabel new];
    self.ptSansLabel.text = @"Hello world";
    self.ptSansLabel.font = ptSansFont;
    self.ptSansLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.ptSansLabel];
    
    [self transformWhitespaceTextOnLabel:self.defaultLabel];
    [self transformWhitespaceTextOnLabel:self.latoLabel];
    [self transformWhitespaceTextOnLabel:self.ptSansLabel];
    
//    [self widthPerCharacterForFont:latoFont];
//    [self widthPerCharacterForFont:ptSansFont];
    
    self.labelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 32)];
    self.labelContainer.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:self.labelContainer];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(400, 0, 100, 32)];
    self.label.text = @"Hello world";
    self.label.textAlignment = NSTextAlignmentRight;
    self.label.font = ptSansFont;
    [self.labelContainer addSubview:self.label];
    
    UIImage *labelImage = [FontViewController imageWithView:self.labelContainer];
    self.labelImageView = [UIImageView new];
    [self.labelImageView setImage:labelImage];
    [self.view addSubview:self.labelImageView];
}

- (CGFloat)widthPerCharacterForFont:(UIFont *)font {
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
//    CGRect rect = [@"a" boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
//                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                  attributes:attributes
//                                     context:nil];
    CGSize size = [@"a" sizeWithAttributes:@{NSFontAttributeName: font}];
    
    NSLog(@"a: %@: @%f", font.fontName, size.width);
    
    size = [@"s" sizeWithAttributes:@{NSFontAttributeName: font}];
    
    NSLog(@"s: %@: @%f", font.fontName, size.width);
    
    size = [@" " sizeWithAttributes:@{NSFontAttributeName: font}];
    
    NSLog(@"whitespace: %@: @%f", font.fontName, size.width);
    
    return size.width;
}

- (void)transformWhitespaceTextOnLabel:(UILabel *)label {
    CGSize textSize = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
    
    CGSize whitespaceSize = [@" " sizeWithAttributes:@{NSFontAttributeName: label.font}];
    
    CGFloat whitespaceWidth = labelWidth - textSize.width;
    NSInteger whitespaceCount = whitespaceWidth / whitespaceSize.width;
    
    NSString *finalText = [NSString stringWithFormat:@"%*s%@", whitespaceCount, " ", label.text];
    
    CGSize finalTextSize = [finalText sizeWithAttributes:@{NSFontAttributeName: label.font}];
    
    NSLog(@"%@: size: %@", finalText, NSStringFromCGSize(finalTextSize));
    
    label.text = [NSString stringWithFormat:@"%*s%@", whitespaceCount, " ", label.text];
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)printAllFonts {
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

- (void)updateViewConstraints {
    
    self.view.layoutMargins = UIEdgeInsetsMake(20.f, 0, 20.f, 0);
    
    [self.defaultLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];

    [@[self.defaultLabel, self.latoLabel, self.ptSansLabel, self.labelImageView] autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSize:32.f insetSpacing:YES];
    [@[self.defaultLabel, self.latoLabel, self.ptSansLabel, self.labelImageView] autoSetViewsDimension:ALDimensionWidth toSize:500.f];

//    [self.label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];

    [super updateViewConstraints];
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
