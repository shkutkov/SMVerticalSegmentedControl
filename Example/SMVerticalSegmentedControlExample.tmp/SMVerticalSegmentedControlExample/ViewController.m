//
//  ViewController.m
//  SMVerticalSegmentedControlExample
//
//  Created by Mikhail Shkutkov on 9/13/13.
//  Copyright (c) 2013 Mikhail Shkutkov. All rights reserved.
//

#import "ViewController.h"
#import "SMVerticalSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *titles = @[@"Search", @"Images", @"Maps", @"Play", @"YouTube", @"News", @"Mail", @"Drive", @"Calendar"];
    SMVerticalSegmentedControl *segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];

    segmentedControl.font = [UIFont systemFontOfSize:11];
   // segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
    segmentedControl.selectionLocation = SMVerticalSegmentedControlSelectionLocationRight;
    segmentedControl.selectionIndicatorThinkness = 2;
    segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentRight;
//    segmentedControl.selectionLocation = SMVerticalSegmentedControlSelectionLocationLeft;
    segmentedControl.backgroundColor = [UIColor clearColor];
   // [segmentedControl setFrame:CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.height)];
 
    [self.view addSubview:segmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
