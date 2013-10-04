//
//  SMVerticalSegmentedControl.m
//  Version 0.1.2
//
//  Created by Mikhail Shkutkov on 9/6/13.
//  Copyright (c) 2013 Mikhail Shkutkov. All rights reserved.
//

#import "SMVerticalSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

#define IS_IOS_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define DEFAULT_BACKGROUND_COLOR            [UIColor clearColor];
#define DEFAULT_TEXT_FONT                   [UIFont systemFontOfSize:14.0f]
#define DEFAULT_TEXT_COLOR                  [UIColor blackColor]
#define DEFAULT_SELECTION_INDICATOR_COLOR   [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]
#define DEFAULT_SEGMENT_EDGE_INSET          UIEdgeInsetsMake(5, 5, 5, 5);
#define DEFAULT_BOX_BACKGROUND_COLOR_ALPHA  0.2f;
#define DEFAULT_BOX_BORDER_COLOR_ALPHA      0.3f
#define DEFAULT_BOX_BORDER_WIDTH            1.0f;


static NSString * const kPositionCALayerAction = @"position";
static NSString * const kBoundsCALayerAction   = @"bounds";

static CFTimeInterval const kDefaultAnimationDuration    = 0.15f;
static CGFloat const kDefaultSelectionIndicatorThickness = 2.0f;
static CGFloat const kDefaultBoxBackgroundColorAlpha     = 0.2f;
static CGFloat const kDefaultBoxBorderColorAlpha         = 0.3f;
static CGFloat const kDefaultBoxBorderWidth              = 1.0f;
static CGFloat const kDefaultSegmentWidth                = 100.0f;

int const kSMVerticalSegmentedControlNoSegment           = -1;

@interface SMVerticalSegmentedControl()

@property (nonatomic, strong) CALayer *selectionIndicatorStripLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorBoxLayer;
@property (nonatomic, readwrite) CGFloat segmentHeight;

@property (nonatomic, assign) NSInteger visibleSelectedSegmentIndex;

@end

@implementation SMVerticalSegmentedControl

#pragma mark Init Methods
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        _selectedSegmentIndex = 0;
        _visibleSelectedSegmentIndex = 0;
        
        _backgroundColor = DEFAULT_BACKGROUND_COLOR;
        
        _textFont = DEFAULT_TEXT_FONT;
        _textColor = DEFAULT_TEXT_COLOR;
        
        _selectedTextColor = _textColor;
        
        _textAlignment = SMVerticalSegmentedControlTextAlignmentLeft;
        
        _selectionIndicatorColor = DEFAULT_SELECTION_INDICATOR_COLOR;
        _selectionIndicatorThickness = kDefaultSelectionIndicatorThickness;
        
        _selectionStyle = SMVerticalSegmentedControlSelectionStyleTextHeightStrip;
        _selectionLocation = SMVerticalSegmentedControlSelectionLocationLeft;
        
        _segmentEdgeInset = DEFAULT_SEGMENT_EDGE_INSET;
        
        _width = kDefaultSegmentWidth;
        
        _selectionIndicatorStripLayer = [CALayer layer];
        
        _selectionIndicatorBoxLayer = [CALayer layer];
        _selectionBoxBackgroundColorAlpha = DEFAULT_BOX_BACKGROUND_COLOR_ALPHA;
        _selectionBoxBorderColorAlpha = DEFAULT_BOX_BORDER_COLOR_ALPHA;
        _selectionBoxBorderWidth = DEFAULT_BOX_BORDER_WIDTH;
    }
    
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectionTitles
{
    if (self = [self initWithFrame:CGRectZero]) {
        _sectionTitles = sectionTitles;
        [self updateSegmentsRects:CGSizeZero];
    }
    
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorBoxLayer.backgroundColor = [self createColorFromOtherColor:self.selectionIndicatorColor
                                                                            withAlpha:self.selectionBoxBackgroundColorAlpha].CGColor;
    self.selectionIndicatorBoxLayer.borderColor = [self createColorFromOtherColor:self.selectionIndicatorColor
                                                                        withAlpha:self.selectionBoxBorderColorAlpha].CGColor;
    self.selectionIndicatorBoxLayer.borderWidth = self.selectionBoxBorderWidth;
    
    // Remove all sublayers to avoid drawing images over existing ones
    self.layer.sublayers = nil;
    
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat stringHeight = roundf([self getTextHeight:titleString]);
        CGFloat y = self.segmentHeight * idx + self.segmentHeight / 2 - stringHeight / 2;
        
        /*
         Workaround for iOS 5.x
         http://stackoverflow.com/questions/12567562/unwanted-vertical-padding-from-ios-6-on-catextlayer
         */
        if (IS_IOS_LESS_THAN(@"6.0")) {
            y +=(self.textFont.capHeight - self.textFont.xHeight);
        }
        
        CGRect rect = CGRectMake(self.selectionIndicatorThickness + self.segmentEdgeInset.left,
                                 y,
                                 self.width - self.selectionIndicatorThickness - self.segmentEdgeInset.left - self.segmentEdgeInset.right,
                                 stringHeight);
        
        CATextLayer *titleLayer = [CATextLayer layer];
        // Note: text inside the CATextLayer will appear blurry unless the rect values around rounded
        titleLayer.frame = rect;
        [titleLayer setFont:(__bridge CFTypeRef)(self.textFont.fontName)];
        [titleLayer setFontSize:self.textFont.pointSize];
        
        switch(self.textAlignment) {
            case SMVerticalSegmentedControlTextAlignmentLeft:
                [titleLayer setAlignmentMode:kCAAlignmentLeft];
                break;
            case SMVerticalSegmentedControlTextAlignmentCenter:
                [titleLayer setAlignmentMode:kCAAlignmentCenter];
                break;
            case SMVerticalSegmentedControlTextAlignmentRight:
                [titleLayer setAlignmentMode:kCAAlignmentRight];
                break;
        }
        
        [titleLayer setString:titleString];
        
        // Use visibileSelectedSegmentIndex for highlighting segment text instead of selectedSegmentIndex
        // This is necessary for proper selection animation
        if (self.visibleSelectedSegmentIndex == idx) {
            [titleLayer setForegroundColor:self.selectedTextColor.CGColor];
        } else {
            [titleLayer setForegroundColor:self.textColor.CGColor];
        }
        
        [titleLayer setContentsScale:[[UIScreen mainScreen] scale]];
        [self.layer addSublayer:titleLayer];
    }];
    
    // Add the selection indicators
    if (self.selectedSegmentIndex != kSMVerticalSegmentedControlNoSegment && !self.selectionIndicatorStripLayer.superlayer) {
        self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
        [self.layer addSublayer:self.selectionIndicatorStripLayer];
        
        if (self.selectionStyle == SMVerticalSegmentedControlSelectionStyleBox && !self.selectionIndicatorBoxLayer.superlayer) {
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [self.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
        }
    }
}

#pragma mark Private Methods

- (CGFloat)getTextHeight:(NSString *)text
{
    if ([text respondsToSelector:@selector(sizeWithAttributes:)]) {
        return [text sizeWithAttributes: @{NSFontAttributeName: self.textFont}].height;
    } else {
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
        return [text sizeWithFont:self.textFont].height;
#pragma clang diagnostic pop
    }
}

- (CGRect)frameForSelectionIndicator
{
    CGFloat indicatorXOffset = 0;
    
    if (self.selectionLocation == SMVerticalSegmentedControlSelectionLocationRight) {
        indicatorXOffset = self.bounds.size.width - self.selectionIndicatorThickness;
    }
    
    CGFloat sectionHeight = 0.0f;
    
    NSString *title = self.sectionTitles[self.selectedSegmentIndex];
    CGFloat stringHeight = [self getTextHeight:title];
    sectionHeight = stringHeight;
    
    if (self.selectionStyle == SMVerticalSegmentedControlSelectionStyleTextHeightStrip && sectionHeight <= self.segmentHeight) {
        CGFloat heightToStartOfSelectedIndex = (self.segmentHeight * self.selectedSegmentIndex);
        
        CGFloat y = heightToStartOfSelectedIndex + self.segmentHeight / 2 - (sectionHeight / 2);
        return CGRectMake(indicatorXOffset, y, self.selectionIndicatorThickness, sectionHeight);
    } else {
        return CGRectMake(indicatorXOffset, self.segmentHeight * self.selectedSegmentIndex, self.selectionIndicatorThickness, self.segmentHeight);
    }
}

- (CGRect)frameForFillerSelectionIndicator
{
    return CGRectMake(0, self.segmentHeight * self.selectedSegmentIndex, self.width, self.segmentHeight);
}

- (void)updateSegmentsRects:(CGSize)size
{
    // If there's no frame set, calculate the width of the control based on the number of segments and their size
    if (CGRectIsEmpty(self.frame)) {
        self.segmentHeight = 0;
        
        for (NSString *titleString in self.sectionTitles) {
            CGFloat stringHeight = [self getTextHeight:titleString] + self.segmentEdgeInset.top + self.segmentEdgeInset.bottom;
            self.segmentHeight = MAX(stringHeight, self.segmentHeight);
        }
        self.frame = CGRectMake(0, 0, self.width, self.segmentHeight * self.sectionTitles.count);
    } else {
        self.segmentHeight = size.height / self.sectionTitles.count;
        
        self.segmentHeight = roundf(self.segmentHeight);
        self.width = size.width;
    }
}

- (UIColor *)createColorFromOtherColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:alpha];
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index
{
    if (self.superview) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    if (self.indexChangeBlock) {
        self.indexChangeBlock(index);
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = touchLocation.y / self.segmentHeight;
        
        if (segment != self.selectedSegmentIndex) {
            [self setSelectedSegmentIndex:segment animated:YES notify:YES];
        }
    }
}

#pragma mark -

- (void)setSelectedSegmentIndex:(NSInteger)index
{
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated
{
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify
{
    _selectedSegmentIndex = index;
    // Reset visible selected index
    self.visibleSelectedSegmentIndex = kSMVerticalSegmentedControlNoSegment;
    
    if (index == kSMVerticalSegmentedControlNoSegment) {
        [self.selectionIndicatorStripLayer removeFromSuperlayer];
        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
    } else {
        if (animated) {
            
            /*
             If the selected segment layer is not added to the super layer, that means no
             index is currently selected, so add the layer then move it to the new
             segment index without animating.
             */
            if (![self.selectionIndicatorStripLayer superlayer]) {
                [self.layer addSublayer:self.selectionIndicatorStripLayer];
                
                if (self.selectionStyle == SMVerticalSegmentedControlSelectionStyleBox && ![self.selectionIndicatorBoxLayer superlayer])
                    [self.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                
                [self setSelectedSegmentIndex:index animated:NO notify:YES];
                return;
            }
            
            if (notify) {
                [self notifyForSegmentChangeToIndex:index];
            }
            
            // Restore CALayer animations
            self.selectionIndicatorStripLayer.actions = nil;
            self.selectionIndicatorBoxLayer.actions = nil;
            
            // Animate to new position
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                // When animation is finished, set proper visibleSelectedSegmentIndex
                self.visibleSelectedSegmentIndex = index;
                [self setNeedsDisplay];
            }];
            [CATransaction setAnimationDuration:kDefaultAnimationDuration];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [CATransaction commit];
        } else {
            self.visibleSelectedSegmentIndex = index;
            
            NSDictionary *newActions = @{kPositionCALayerAction : [NSNull null], kBoundsCALayerAction : [NSNull null]};
            self.selectionIndicatorStripLayer.actions = newActions;
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            
            self.selectionIndicatorBoxLayer.actions = newActions;
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            
            if (notify) {
                [self notifyForSegmentChangeToIndex:index];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.sectionTitles) {
        [self updateSegmentsRects:frame.size];
    }
    
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    if (self.sectionTitles) {
        [self updateSegmentsRects:bounds.size];
    }
    
    [self setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // Control is being removed
    if (!newSuperview) {
        return;
    }
    
    [self updateSegmentsRects:self.frame.size];
}

@end
