//
//  BarChartView.h
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

#define MAX_BAR_WIDTH 60.0f
#define STEP_AXIS_Y 20.0f
#define STROKE_AXIS_Y_SCALE 85
#define FONT_SIZE 12.0f
#define PLOT_PADDING_TOP 10.0f
#define PLOT_PADDING_BOTTOM 10.0f

#import <UIKit/UIKit.h>
#import "PlotChartView.h"

@interface BarChartView : UIView
{
	PlotChartView *plotChart;
	UIView *plotView;
	
	NSMutableArray *barViews;
	NSMutableArray *barLabels;
	NSMutableArray *chartDataArray;
	
	BOOL showAxisY;
	BOOL showAxisX;
	BOOL plotVerticalLines;
	
	UIColor *colorAxisY;
	UIColor *bgColor;
	
	CGFloat realMaxValue;
	CGFloat maxValue;
	
	double barHeightRatio;
	CGFloat leftPadding;
	CGFloat barWidth;
	CGFloat stepWidth;
	CGFloat barFullWidth;
	CGFloat fontSize;
}

- (void) setXmlData:(NSData *)xmlData;

@end
