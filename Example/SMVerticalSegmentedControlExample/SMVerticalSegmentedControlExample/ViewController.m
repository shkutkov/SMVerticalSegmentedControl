//
//  ViewController.m
//  SMVerticalSegmentedControlExample
//
//  Created by Mikhail Shkutkov on 9/13/13.
//  Copyright (c) 2013 Mikhail Shkutkov. All rights reserved.
//

#import "ViewController.h"
#import "SMVerticalSegmentedControl.h"

static const int kSegmentedControlWidth = 85;
#define UI_COLOR_FROM_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                               green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface ViewController ()

@property (nonatomic, retain) SMVerticalSegmentedControl *segmentedControl;
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *titles = @[@"Example 1", @"Example 2", @"Example 3", @"Example 4", @"Example 5"];
    self.segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];
    self.segmentedControl.backgroundColor = UI_COLOR_FROM_RGB(0xecf0f1);
    self.segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorThickness = 4;
    [self.segmentedControl setFrame:CGRectMake(0, 0, kSegmentedControlWidth, CGRectGetHeight(self.view.bounds))];
    [self.view addSubview:self.segmentedControl];

    CGFloat scrollWidth = CGRectGetWidth(self.view.bounds) - kSegmentedControlWidth;
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kSegmentedControlWidth,
                                                                     0,
                                                                     scrollWidth,
                                                                     screenHeight)];
                                                                     
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(scrollWidth, [titles count] * screenHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 200) animated:NO];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // set default settings for semented controls in UIScrollView
    [SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].backgroundColor = UI_COLOR_FROM_RGB(0x3498db);
    [SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].textColor = [UIColor whiteColor];
    [SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].selectedTextColor = UI_COLOR_FROM_RGB(0x34495e);
    [SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].selectionIndicatorColor = UI_COLOR_FROM_RGB(0x34495e);

    NSArray *colors = @[@0x169E6F, @0x18A84D, @0x1C9126, @0x3BA818, @0x669E16];
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, idx * screenHeight, scrollWidth, screenHeight)];
        NSNumber *number = colors[idx];
        [view setBackgroundColor:UI_COLOR_FROM_RGB([number intValue])];
        [self.scrollView addSubview:view];
        [self createExample:idx inView:view];
    }];
    
    __block ViewController *_self = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        [_self.scrollView scrollRectToVisible:CGRectMake(0, index * screenHeight, scrollWidth, screenHeight) animated:YES];
    };
}

- (void)createExample:(int)exampleNumber inView:(UIView *)view
{
    NSArray *titles = @[@"item 1", @"item 2", @"item 3", @"item 4", @"item 5"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 20, CGRectGetWidth(view.frame) - 4, 80)];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    [view addSubview:label];
    
    SMVerticalSegmentedControl *segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];
    
    CGFloat segmentedControlHeight = 250;
    CGFloat segmentedControlWidth  = 100;
    
    switch(exampleNumber) {
        case 0:
            label.text = @"Left aligned text\nLeft aligned selection indicator\nSelection indicator height is equal to text height";
            break;
        case 1:
            label.text = @"Right aligned text\nRight aligned selection indicator\nSelection indicator height is equal to text height";
            segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentRight;
            segmentedControl.selectionLocation = SMVerticalSegmentedControlSelectionLocationRight;
            break;
        case 2:
            label.text = @"Center aligned text\nSelection indictator style is equal to cell height";
            segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleFullHeightStrip;
            segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
            break;
        case 3:
            label.text = @"Center aligned text\nBox selection style\nSelection indicator thickness is equal to zero\nBox border is equal to zero";
            segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
            segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
            segmentedControl.selectionIndicatorThickness = 0;
            segmentedControl.selectionBoxBorderWidth = 0;
            break;
        case 4:
            label.text = @"Center aligned text\nBox selection style\nSelection indicator thickness is equal to zero\nBox border is equal to 2\nBox background color alpha is equal to 0.5\nBox border color alpha is equal to 0.7";
            segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
            segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
            segmentedControl.selectionIndicatorThickness = 0;
            segmentedControl.selectionBoxBorderWidth = 2;
            segmentedControl.selectionBoxBackgroundColorAlpha = 0.5;
            segmentedControl.selectionBoxBorderColorAlpha = 0.7;
            
            break;
        default:
            break;
    }
    
    segmentedControl.frame = CGRectMake(CGRectGetWidth(view.frame) / 2 - segmentedControlWidth / 2,
                                        CGRectGetHeight(view.frame) / 2 - segmentedControlHeight / 2,
                                        segmentedControlWidth,
                                        segmentedControlHeight);
    [view addSubview:segmentedControl];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageHeight = CGRectGetHeight(scrollView.frame);
    NSInteger page = scrollView.contentOffset.y / pageHeight;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

@end
