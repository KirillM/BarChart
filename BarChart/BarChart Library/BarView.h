//
//  Bar.h
//
//  Created by Mezrin Kirill on 17.02.12.
//  Copyright (c) Mezrin Kirill 2012-2013.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CMPopTipView.h"
#import "BarTypes.h"

@interface BarView : UIButton {
	CGFloat barValue;
	CGFloat cornerRadius;
	UIColor *buttonColor;
	CMPopTipView *popTipView;
}

@property (nonatomic, assign) BOOL special;
@property (nonatomic, weak) id owner;
@property (nonatomic, assign) CGFloat barValue;
@property (readwrite, nonatomic) CGFloat cornerRadius;
@property (readwrite, strong, nonatomic) UIColor *buttonColor;
@property (assign) BarDisplayStyle barViewDisplayStyle;
@property (assign) BarShape barViewShape;
@property (assign) BarShadow barViewShadow;

- (void)setupBarStyle:(BarDisplayStyle)displayStyle;
- (void)setupBarShape:(BarShape)shape;
- (void)setupBarShadow:(BarShadow)shadow;

@end
