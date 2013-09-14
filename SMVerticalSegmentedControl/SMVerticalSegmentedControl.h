//
//  SMVerticalSegmentedControl.h
//
//  Created by Mikhail Shkutkov on 9/6/13.
//  Copyright (c) 2013 Mikhail Shkutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

typedef NS_ENUM(NSInteger, SMVerticalSegmentedControlSelectionStyle) {
    SMVerticalSegmentedControlSelectionStyleTextHeightStrip, // Indicator height will only be as big as the text height
    SMVerticalSegmentedControlSelectionStyleFullHeightStrip, // Indicator height will fill the whole segment
    SMVerticalSegmentedControlSelectionStyleBox
};

typedef NS_ENUM(NSInteger, SMVerticalSegmentedControlSelectionLocation) {
    SMVerticalSegmentedControlSelectionLocationLeft,
    SMVerticalSegmentedControlSelectionLocationRight,
};

typedef NS_ENUM(NSInteger, SMVerticalSegmentedControlTextAlignment){
    SMVerticalSegmentedControlTextAlignmentLeft,
    SMVerticalSegmentedControlTextAlignmentCenter,
    SMVerticalSegmentedControlTextAlignmentRight,
};

extern int const kSMVerticalSegmentedControlNoSegment;

@interface SMVerticalSegmentedControl : UIControl

@property (nonatomic, copy, readonly) NSArray *sectionTitles;

@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont  *textFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *selectedTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) SMVerticalSegmentedControlTextAlignment textAlignment UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *selectionIndicatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat  selectionIndicatorThickness UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat  selectionBoxBackgroundColorAlpha UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat  selectionBoxBorderColorAlpha UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat  selectionBoxBorderWidth UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) SMVerticalSegmentedControlSelectionStyle selectionStyle UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) SMVerticalSegmentedControlSelectionLocation selectionLocation UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) UIEdgeInsets segmentEdgeInset UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat width UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;

@end
