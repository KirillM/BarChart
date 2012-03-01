//
//  RootController.m
//  BarChart
//
//  Created by MacBook on 15.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootController.h"
#import "UIViewSizeShortcuts.h"

@implementation RootController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	barChart = [[BarChartView alloc] initWithFrame:CGRectMake(40.0f, 40.0f, self.view.width - 80.0f, self.view.height - 80.0f)];
	[barChart setXmlData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"barChart" ofType:@"xml"]]];
	[self.view addSubview:barChart];
	[barChart release];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

#pragma mark - Rotations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
