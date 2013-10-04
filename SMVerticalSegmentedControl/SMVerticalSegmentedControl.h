/*
 Version 0.1.2

 SMVerticalSegmentedControl is available under the MIT license.

 Copyright (c) 2013 Mikhail Shkutkov.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included
 in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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
