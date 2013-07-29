//
//  BarChartView.m
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

#import "BarChartView.h"
#import "UIViewSizeShortcuts.h"
#import "XMLParser.h"
#import "UIColor+i7HexColor.h"
#import "BarView.h"
#import "BarLabel.h"

@interface BarChartView() 
- (void) setUp;
- (void) setUpChartWithGloss:(BOOL)withGloss;
- (void) calculateFrames;

@end

@implementation BarChartView

- (id) init
{
	self = [super init];
	if (self) 
	{
		[self setUp];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) 
	{
		[self setUp];
	}
	return self;
}

- (void) setUp
{	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.clipsToBounds = false;
	self.backgroundColor = [UIColor colorWithHexString:@"e8ebee"];
	
	plotChart = [[PlotChartView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height - fontSize)];
	plotChart.stepValueAxisY = STEP_AXIS_Y;
	plotChart.fontSize = FONT_SIZE;
	plotChart.paddingTop = PLOT_PADDING_TOP;
	plotChart.paddingBotom = PLOT_PADDING_BOTTOM;
	plotChart.stepWidthAxisY = self.width/STROKE_AXIS_Y_SCALE;
	[self addSubview:plotChart];
	[plotChart release];
	
	plotView = [[UIView alloc] initWithFrame:CGRectZero];
	//plotView.backgroundColor = [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:0.5];
	plotView.backgroundColor = [UIColor clearColor];
	plotView.clipsToBounds = true;
	plotView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[plotChart addSubview:plotView];
	[plotView release];
	
	barViews = [[NSMutableArray alloc] initWithCapacity:0];
	barLabels = [[NSMutableArray alloc] initWithCapacity:0];
	chartDataArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if (colorAxisY) [colorAxisY release];
	[barViews release];
	[barLabels release];
	[chartDataArray release];
	[super dealloc];
}

- (void) didRotate:(NSNotification *)notification
{
	static UIDeviceOrientation previousOrientation = -1;
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

	if (orientation != UIDeviceOrientationFaceUp && orientation != UIDeviceOrientationFaceDown && orientation != UIDeviceOrientationUnknown && previousOrientation != orientation)
	{
		[self performSelector:@selector(animateBars) withObject:NULL afterDelay:0.5];
		previousOrientation = orientation;
	}		
}	

- (void) setUpChartWithGloss:(BOOL)withGloss
{	
	[self calculateFrames];
	
	NSUInteger _index = 0;
	for (NSDictionary *barInfo in chartDataArray) 
	{
		BarView *bar = [[BarView alloc] initWithFrame:CGRectMake((barFullWidth - barWidth)/2 + _index*(barFullWidth),  plotView.height - roundf([[barInfo objectForKey:@"value"] floatValue]*barHeightRatio), barWidth, roundf([[barInfo objectForKey:@"value"] floatValue]*barHeightRatio))];
		bar.cornerRadius = 10.0f;
		bar.barValue = [[barInfo objectForKey:@"value"] floatValue];
		bar.owner = self;
        bar.hasGloss = withGloss;
		if (realMaxValue == [[barInfo objectForKey:@"value"] floatValue]) 
		{
			bar.special = true;
		}
		bar.backgroundColor = [UIColor clearColor];
		bar.buttonColor = [barInfo objectForKey:@"color"];
		[plotView addSubview:bar];
		[barViews addObject:bar];
		[bar release];
		
		if (showAxisX) 
		{
			BarLabel *barLabel = [[BarLabel alloc] initWithFrame:CGRectMake(roundf(plotView.left + _index*barFullWidth), plotChart.bottom - PLOT_PADDING_BOTTOM,roundf(barFullWidth), fontSize + PLOT_PADDING_BOTTOM)];
			barLabel.textColor = [barInfo objectForKey:@"labelColor"];
			barLabel.text =  [barInfo objectForKey:@"label"];
			barLabel.font = [UIFont systemFontOfSize:fontSize];
			barLabel.textAlignment = UITextAlignmentCenter;
			barLabel.clipsToBounds = false;
			barLabel.backgroundColor = [UIColor clearColor];
			[barLabels addObject:barLabel];
			[self addSubview:barLabel];
			[barLabel release];
		}		 
		_index++;
	}
}

- (void) calculateFrames
{
	CGSize maxStringSize = [[NSString stringWithFormat:@"%i", (int)maxValue] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
	
	if (showAxisY)
		leftPadding = self.width/STROKE_AXIS_Y_SCALE + maxStringSize.width;
	else
		leftPadding = 0.0f;
	
	plotChart.stepWidthAxisY = showAxisY?self.width/STROKE_AXIS_Y_SCALE:0.0f;
	
	plotView.frame = CGRectMake(leftPadding, PLOT_PADDING_TOP, plotChart.width - leftPadding, plotChart.height - PLOT_PADDING_TOP - PLOT_PADDING_BOTTOM);
	
	barHeightRatio = plotView.height/maxValue;
	
	barWidth = plotView.width/chartDataArray.count;
	
	barFullWidth = plotView.width/chartDataArray.count;
	
	if (barWidth > MAX_BAR_WIDTH) 
	{
		barWidth = MAX_BAR_WIDTH;
	}
	else
	{
		barWidth = barWidth;
	}
	
	stepWidth = plotView.width/chartDataArray.count - MAX_BAR_WIDTH;
	
	if (stepWidth < 0.0f) 
	{
		stepWidth = 0.0f;
	}
	else
	{
		stepWidth = stepWidth;
	}
	
	[plotChart setNeedsDisplay];
}

- (void) setXmlData:(NSData *)xmlData
{
	[chartDataArray removeAllObjects];
	XMLElement *xml = [XMLParser parse:xmlData];
	
	if (!(xml != NULL && xml.children.count)) 
		return;
	
	NSMutableArray *barValues = [NSMutableArray arrayWithCapacity:0];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	for (XMLElement *barElement in xml.children) 
	{
		NSDictionary *barInfo = [NSDictionary dictionaryWithObjectsAndKeys:
														 [barElement getAttribute:@"label"], @"label", 
														 [NSNumber numberWithFloat:[[barElement getAttribute:@"value"] floatValue]], @"value", 
														 [UIColor colorWithHexString:[barElement getAttribute:@"color"]], @"color", 
														 [UIColor colorWithHexString:[barElement getAttribute:@"labelColor"]], @"labelColor", nil];
		[chartDataArray addObject:barInfo];
		[barValues addObject:[NSNumber numberWithFloat:[[barElement getAttribute:@"value"] floatValue]]];
	}
	[pool release];
	
	maxValue = [[barValues valueForKeyPath:@"@max.floatValue"] floatValue] + [[barValues valueForKeyPath:@"@max.floatValue"] floatValue]*15/100;
	realMaxValue = [[barValues valueForKeyPath:@"@max.floatValue"] floatValue];
	maxValue = maxValue - fmodf(maxValue, STEP_AXIS_Y);
	if (maxValue < realMaxValue) 
	{
		maxValue = maxValue + STEP_AXIS_Y;
	}
	
	showAxisY = [[xml getAttribute:@"showAxisY"] isEqualToString:@"true"];
	showAxisX = [[xml getAttribute:@"showAxisX"] isEqualToString:@"true"];
	plotVerticalLines = [[xml getAttribute:@"plotVerticalLines"] isEqualToString:@"true"];
	
	[colorAxisY release];
	colorAxisY = [[UIColor colorWithHexString:[xml getAttribute:@"colorAxisY"]] retain];
	
	if (showAxisX) 
	{
		fontSize = FONT_SIZE;	
	}
	
	CGSize maxStringSize = [[NSString stringWithFormat:@"%i", (int)maxValue] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
	
	plotChart.frame = CGRectMake(0.0f, 0.0f, self.width, self.height - fontSize);
	plotChart.fontSize = FONT_SIZE;
	plotChart.stepCountAxisX = chartDataArray.count;
	plotChart.stepWidthAxisY = self.width/STROKE_AXIS_Y_SCALE;
	plotChart.maxValueAxisY = maxValue;
	plotChart.stepValueAxisY = STEP_AXIS_Y;
	plotChart.colorAxisY = [colorAxisY CGColor];
	plotChart.plotVerticalLines = plotVerticalLines;
	
	if (showAxisY) 
		plotChart.labelSizeAxisY = maxStringSize;
	else
		plotChart.labelSizeAxisY = CGSizeZero;
	[self setUpChartWithGloss:YES];
}

- (void) setData:(NSArray *)arrData configuration:(NSDictionary *)confDict  {
	[chartDataArray removeAllObjects];
    
    if(!arrData || arrData.count <= 0)    {
        NSLog(@"Warning - No data given");
        return;
    }
	
	NSMutableArray *barValues = [NSMutableArray arrayWithCapacity:arrData.count];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int i=0;
	for (NSDictionary *dict in arrData)
	{
        NSString *label = [dict objectForKey:@"label"];
        NSNumber *value = [NSNumber numberWithFloat:[[dict objectForKey:@"value"] floatValue]];
        UIColor *colour = [UIColor colorWithHexString:[self getFlatColour:i]];
        UIColor *colourLabel = [UIColor blackColor];
        
		NSDictionary *barInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 label, @"label",
                                 value, @"value",
                                 colour, @"color",
                                 colourLabel, @"labelColor", nil];
		[chartDataArray addObject:barInfo];
		[barValues addObject:value];
        i += 1;
	}
	[pool release];
	
	maxValue = [[barValues valueForKeyPath:@"@max.floatValue"] floatValue] + [[barValues valueForKeyPath:@"@max.floatValue"] floatValue]*15/100;
	realMaxValue = [[barValues valueForKeyPath:@"@max.floatValue"] floatValue];
	maxValue = maxValue - fmodf(maxValue, STEP_AXIS_Y);
	if (maxValue < realMaxValue)
	{
		maxValue = maxValue + STEP_AXIS_Y;
	}
	
    showAxisY = YES;   // Default
    if([confDict objectForKey:@"showAxisY"])    {
        showAxisY = [[confDict objectForKey:@"showAxisY"] boolValue];
    }
    showAxisX = YES;   // Default
    if([confDict objectForKey:@"showAxisX"])    {
        showAxisX = [[confDict objectForKey:@"showAxisX"] boolValue];
    }
    plotVerticalLines = YES;   // Default
    if([confDict objectForKey:@"plotVerticalLines"])    {
        plotVerticalLines = [[confDict objectForKey:@"plotVerticalLines"] boolValue];
    }
	[colorAxisY release];
	colorAxisY = [[UIColor blackColor] retain];
	
	if (showAxisX)
	{
		fontSize = FONT_SIZE;
	}
	
	CGSize maxStringSize = [[NSString stringWithFormat:@"%i", (int)maxValue] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
	
	plotChart.frame = CGRectMake(0.0f, 0.0f, self.width, self.height - fontSize);
	plotChart.fontSize = FONT_SIZE;
	plotChart.stepCountAxisX = chartDataArray.count;
	plotChart.stepWidthAxisY = self.width/STROKE_AXIS_Y_SCALE;
	plotChart.maxValueAxisY = maxValue;
	plotChart.stepValueAxisY = STEP_AXIS_Y;
	plotChart.colorAxisY = [colorAxisY CGColor];
	plotChart.plotVerticalLines = plotVerticalLines;
	
	if (showAxisY)
		plotChart.labelSizeAxisY = maxStringSize;
	else
		plotChart.labelSizeAxisY = CGSizeZero;
	[self setUpChartWithGloss:NO];
}

- (void) animateBars
{
	for (BarView *bar in barViews) 
	{
		bar.bottom += bar.height;
	}
	
	[UIView animateWithDuration:1.0 animations:^{
		
		NSUInteger _index = 0;
		for (NSDictionary *barInfo in chartDataArray) 
		{
			BarView *bar = [barViews objectAtIndex:_index];
			bar.frame = CGRectMake((barFullWidth - barWidth)/2 + _index*(barFullWidth),  plotView.height - roundf([[barInfo objectForKey:@"value"] floatValue]*barHeightRatio), barWidth, roundf([[barInfo objectForKey:@"value"] floatValue]*barHeightRatio));
			_index++;
		}
	}];
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	[self calculateFrames];
	NSUInteger _index = 0;
	for (NSDictionary *barInfo in chartDataArray) 
	{
		BarView *bar = [barViews objectAtIndex:_index];
		bar.frame = CGRectMake((barFullWidth - barWidth)/2 + _index*(barFullWidth),  plotView.height - roundf([[barInfo objectForKey:@"value"] floatValue]*barHeightRatio), barWidth, roundf([[barInfo objectForKey:@"value"] floatValue]*barHeightRatio));
		[bar setNeedsDisplay];
		
		if (showAxisX) 
		{			
			BarLabel *barLabel = [barLabels objectAtIndex:_index];
			barLabel.frame = CGRectMake(roundf(plotView.left + _index*barFullWidth), plotChart.bottom - PLOT_PADDING_BOTTOM,barFullWidth, fontSize + PLOT_PADDING_BOTTOM);
		
			[barLabel setNeedsDisplay];
		}	
		_index++;
	}
}

#pragma mark - Convenience methods

- (NSString *)getFlatColour:(int)index  {
    index = index % 10;
    switch (index) {
        case 0:
            return @"2ecc71";
        case 1:
            return @"3498db";
        case 2:
            return @"9b59b6";
        case 3:
            return @"f1c40f";
        case 4:
            return @"e74c3c";
        case 5:
            return @"95a5a6";
        case 6:
            return @"1abc9c";
        case 7:
            return @"c0392b";
        case 8:
            return @"34495e";
        case 9:
            return @"8e44ad";
        default:
            return nil;
    }
}

@end
