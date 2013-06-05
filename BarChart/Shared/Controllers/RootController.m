//
//  RootController.m
//  BarChart
//
//  Created by Kirill Mezrin on 15.02.12. Updated by iRare Media on June 4, 2013
//  Copyright (c) 2012 Kirill Mezrin. All rights reserved.
//

#import "RootController.h"
#import "UIViewSizeShortcuts.h"

@implementation RootController
@synthesize barChart;

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	barChart = [[BarChartView alloc] initWithFrame:self.barChart.frame];
	[barChart setXmlData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"barChart" ofType:@"xml"]]];
	[self.view addSubview:barChart];
}

- (void)viewDidUnload {
    [self setBarChart:nil];
	[super viewDidUnload];
}

@end
