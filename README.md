SMVerticalSegmentedControl
===================

SMVerticalSegmentedControl is plain vertical segmented control (like UISegmentedControl). Component inspired by [HMSegementedControl](https://github.com/HeshamMegid/HMSegmentedControl)

### Screenshots

![](https://raw.github.com/shkutkov/SMVerticalSegmentedControl/master/Screenshots/1.png)   ![](https://raw.github.com/shkutkov/SMVerticalSegmentedControl/master/Screenshots/2.png)

### UIAppearance support

| Property                                                             | Type           | Default value   	                | 
| -------------------------------------------------------------------- | -------------- | --------------------------------: | 
| `backgroundColor`                                                    | `UIColor`      | `[UIColor clearColor]`            |
| `textFont`                                                           | `UIFont`       | `[UIFont systemFontOfSize:14]`    |
| `textColor`                                                          | `UIColor`      | `#000000`                         |
| `selectedTextColor`                                                  | `UIColor`      | `#34B5E5`                         |
| `selectionIndicatorColor`                                            | `UIColor`      | `#000000`                         |
| `selectionIndicatorThickness`                                        | `CGFloat`      | `2`                               |
| `selectionBoxBackgroundColorAlpha`                                   | `CGFloat`      | `0.2`                             |
| `selectionBoxBorderColorAlpha`                                       | `CGFloat`      | `0.3`                             |
| `selectionBoxBorderWidth`                                            | `CGFloat`	    | `1`                               |
| `segmentEdgeInset`                                                   | `UIEdgeInsets` | `{ 5, 5, 5, 5 }`                  |
| `width`                                                              | `CGFloat`	    | `100`                             |				       


| Property                                                             | Type           | Default value   	                | 
| -------------------------------------------------------------------- | -------------- | --------------------------------: | 
| `selectionStyle`													   | `SMVerticalSegmentedControlSelectionStyle` | `SMVerticalSegmentedControlSelectionStyleTextHeightStrip`|
| `selectionLocation`												   | `SMVerticalSegmentedControlSelectionLocation` | `SMVerticalSegmentedControlTextAlignmentLeft`|
| `textAlignment`                                                      | `SMVerticalSegmentedControlTextAlignment`| `SMVerticalSegmentedControlTextAlignmentLeft`|


### ARC

---

SMVerticalSegmentedControl uses ARC.

### Installation

---

Add `pod 'SMVerticalSegmentedControl', '~> 0.1.1'` to your Podfile  or add manually 2 files `SMVerticalSegmentedControl.h`, `SMVerticalSegmentedControl.m` to your project.

### Examples

---

##### Simple
```objective-c
NSArray *titles = @[@"Title 1", @"Title 2", @"Title 3", @"Title 4"];
SMVerticalSegmentedControl *segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];
[self.view addSubview:segmentedControl];
```

##### Advanced
```objective-c
NSArray *titles = @[@"Title 1", @"Title 2", @"Title 3", @"Title 4"];
SMVerticalSegmentedControl *segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];
segmentedControl.selectedSegmentIndex = 3;
segmentedControl.textColor = [UIColor grayColor];
segmentedControl.selectedTextColor = [UIColor blackColor];
segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
segmentedControl.selectionIndicatorThickness = 0;
segmentedControl.selectionBoxBorderWidth = 2;
segmentedControl.selectionBoxBackgroundColorAlpha = 0.5;
segmentedControl.selectionBoxBorderColorAlpha = 0.7;
segmentedControl.indexChangeBlock = ^(NSInteger index) {
	//TODO: add handler
};
[self.view addSubview:segmentedControl];
```

##### Appearance 
```objective-c
//Customize the appearance of all vertical segmented control in you app
[SMVerticalSegmentedControl appearance].backgroundColor = [UIColor greyColor];
[SMVerticalSegmentedControl appearance].textColor = [UIColor whiteColor];
[SMVerticalSegmentedControl appearance].selectedTextColor = [UIColor blackColor];
[SMVerticalSegmentedControl appearance].selectionIndicatorColor = [UIColor redColor];
```

```objective-c
//Customize the appearance of vertical segmented control when they contained within a UIScrollView
[SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].backgroundColor = [UIColor greyColor];
[SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].textColor = [UIColor whiteColor];
[SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].selectedTextColor = [UIColor blackColor];
[SMVerticalSegmentedControl appearanceWhenContainedIn:[UIScrollView class], nil].selectionIndicatorColor = [UIColor redColor];
```

### Contact

---

* [@shkutkov](https://github.com/shkutkov) on Github
* <a href="mailTo:shkutkov@gmail.com">shkutkov@gmail.com</a>

### License

---

SMVerticalSegmentedController is available under the MIT license.

Copyright © 2013 Michael Shkutkov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.