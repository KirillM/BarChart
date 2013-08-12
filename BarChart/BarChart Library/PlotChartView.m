//
//  PlotChart.m
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

#import "PlotChartView.h"
#import "UIColor+i7HexColor.h"

@interface PlotChartView() 
- (void)setUp;
@end

@implementation PlotChartView

@synthesize paddingTop;
@synthesize paddingBotom;
@synthesize fontSize;
@synthesize colorAxisY;
@synthesize stepCountAxisX;
@synthesize stepWidthAxisY;
@synthesize maxValueAxisY;
@synthesize stepValueAxisY;
@synthesize labelSizeAxisY;
@synthesize plotVerticalLines;

#pragma mark - Initialization and teardown

- (id) init {
	self = [super init];
	if (self)  {
		[self setUp];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self)  {
		[self setUp];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.backgroundColor = [UIColor clearColor];
}

- (void)didRotate:(NSNotification *)notification { 
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	if (orientation != UIDeviceOrientationFaceUp && orientation != UIDeviceOrientationFaceDown && orientation != UIDeviceOrientationUnknown) {
		[self setNeedsDisplay];
	}	
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	rect = CGRectMake(0.0f, paddingTop, rect.size.width, rect.size.height - paddingTop - paddingBotom);

	CGFloat leftPaddingAxisY = stepWidthAxisY + labelSizeAxisY.width;
	NSUInteger stepCountAxisY = maxValueAxisY/stepValueAxisY;
	CGFloat stepHeightAxisY = rect.size.height/stepCountAxisY;
	
	CGFloat barFullWidth = (rect.size.width - leftPaddingAxisY)/stepCountAxisX;

	CGContextSetLineWidth(context, 1.0f);
	CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHexString:@"e8ebee"] CGColor]);
	
	for (NSUInteger i = 0; i < stepCountAxisY; i++)  {
		if (i % 2) {
			CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"e8ebee"] CGColor]);
		} else {
			CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"e3e5e7"] CGColor]);
		}
		
		CGContextBeginPath(context);
		CGContextAddRect(context, CGRectMake(CGRectGetMinX(rect) + leftPaddingAxisY,  CGRectGetMinY(rect) + i*stepHeightAxisY, CGRectGetMaxX(rect) + leftPaddingAxisY, stepHeightAxisY));
				CGContextClosePath(context);
		CGContextDrawPath(context, kCGPathFill);
	}
		
	CGContextSetFillColorWithColor(context, colorAxisY);
	CGContextSetStrokeColorWithColor(context, colorAxisY);
	
	if (!CGSizeEqualToSize(labelSizeAxisY, CGSizeZero))  {
		for (NSUInteger i = 0; i <= stepCountAxisY; i++) {
			NSString *textX = [NSString stringWithFormat:@"%i",(NSUInteger)(maxValueAxisY - i*stepValueAxisY)];
			CGRect textRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + i*stepHeightAxisY - labelSizeAxisY.height/2, labelSizeAxisY.width, labelSizeAxisY.height);
		
			[textX drawInRect:textRect withFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
		
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, CGRectGetMinX(rect) + labelSizeAxisY.width, CGRectGetMinY(rect) + i*stepHeightAxisY);
			CGContextAddLineToPoint(context, CGRectGetMinX(rect) + leftPaddingAxisY, CGRectGetMinY(rect) + i*stepHeightAxisY);
			CGContextClosePath(context);
			CGContextDrawPath(context, kCGPathStroke);	
		}
	}	
	
	if (plotVerticalLines)  {
		CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHexString:@"dadadb"] CGColor]);
		
		for (NSUInteger i = 1; i <= stepCountAxisX; i++) {
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, CGRectGetMinX(rect) + leftPaddingAxisY + (barFullWidth/2)*(2*i - 1), CGRectGetMinY(rect));
			CGContextAddLineToPoint(context, CGRectGetMinX(rect) + leftPaddingAxisY + (barFullWidth/2)*(2*i - 1), CGRectGetMaxY(rect));
			CGContextClosePath(context);
			CGContextDrawPath(context, kCGPathStroke);
			
		}		
	}
	
	CGContextSetStrokeColorWithColor(context, colorAxisY);
	CGContextStrokeRect(context, CGRectMake(CGRectGetMinX(rect) + leftPaddingAxisY,  CGRectGetMinY(rect), CGRectGetMaxX(rect) - leftPaddingAxisY - 1.0f, rect.size.height));
}

@end
