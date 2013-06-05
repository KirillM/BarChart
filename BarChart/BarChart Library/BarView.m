//
//  Bar.m
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

#import "BarView.h"

@interface BarView()
- (void)setUp;
@end

@implementation BarView

#pragma mark - Accessors

@synthesize owner;
@synthesize barValue;
@synthesize cornerRadius, buttonColor, special;
@synthesize barViewDisplayStyle, barViewShape, barViewShadow;

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
	self.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)didRotate:(NSNotification *)notification { 
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	if (orientation != UIDeviceOrientationFaceUp && orientation != UIDeviceOrientationFaceDown && orientation != UIDeviceOrientationUnknown) {
		if (popTipView != nil) {
			[popTipView dismissAnimated:false];
			popTipView = nil;
			return;
		}
	}	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (popTipView != nil)  {
		[popTipView dismissAnimated:true];
		popTipView = nil;
		return;
	}
	
	NSString *contentMessage = [NSString stringWithFormat:@"%.1f", barValue];
	popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
	popTipView.backgroundColor = buttonColor;
	popTipView.textColor = [UIColor whiteColor];
	popTipView.animation = arc4random() % 2;
	[popTipView presentPointingAtView:self inView:owner animated:YES];
	
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[popTipView dismissAnimated:true];
		popTipView = nil;
	});
}

#pragma mark - Drawing methods

- (void)drawRect:(CGRect)rect  {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect currentBounds = self.bounds;
    
	//First, draw the rounded rectangle for the button fill color
    if (barViewShape == BarShapeSquared) {
        //Draw bars in a square shape
        CGContextSetFillColorWithColor(context, [buttonColor CGColor]);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds));
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextClosePath(context);
        CGContextClip(context);
    } else if (barViewShape == BarShapeRounded) {
        //Draw bars with rounded edges
        CGContextSetFillColorWithColor(context, [buttonColor CGColor]);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, 3 * M_PI / 2, 0, 0);
        
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds) - cornerRadius);
        CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, M_PI, 3 * M_PI / 2, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, 3 * M_PI / 2, 0, 0);
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds) - cornerRadius);
        CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, M_PI, 3 * M_PI / 2, 0);
        CGContextClosePath(context);
        CGContextClip(context);
    } else {
        //No BarShape has been set - default to rounded edges
        CGContextSetFillColorWithColor(context, [buttonColor CGColor]);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, 3 * M_PI / 2, 0, 0);
        
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds) - cornerRadius);
        CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, M_PI, 3 * M_PI / 2, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
        CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, 3 * M_PI / 2, 0, 0);
        CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds) - cornerRadius);
        CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, M_PI, 3 * M_PI / 2, 0);
        CGContextClosePath(context);
        CGContextClip(context);
    }
	
    if (barViewDisplayStyle == BarStyleGlossy) {
        //Draw the bars with a full gloss effect
        CGGradientRef shadowGradient;
        CGColorSpaceRef rgbColorspace;
        size_t num_locations = 2;
        CGFloat locations2[2] = { 0.0, 1.0 };
        CGFloat components2[8] = { 0.0, 0.0, 0.0, 0.0,  // Start color
            0.0, 0.0, 0.0, 0.3 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        shadowGradient = CGGradientCreateWithColorComponents(rgbColorspace, components2, locations2, num_locations);
        CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
        CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
        CGContextDrawLinearGradient(context, shadowGradient, topCenter, bottomCenter, 0); //Lighting Gradient
        CGGradientRelease(shadowGradient);
        
        CGFloat glossCornerRadius = cornerRadius;
        CGRect glossRect;
        
        glossRect = CGRectMake(0.0f, 0.0f, currentBounds.size.width, currentBounds.size.height);
        
        CGContextSaveGState(context);
        
        CGContextBeginPath(context);
        
		CGContextMoveToPoint(context, CGRectGetMidX(glossRect), CGRectGetMinY(glossRect));
		CGContextAddLineToPoint(context, CGRectGetMidX(glossRect), CGRectGetMaxY(glossRect));
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMaxY(glossRect));
		
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMinY(glossRect) - cornerRadius);
		
		CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMaxY(glossRect) - glossCornerRadius, glossCornerRadius, M_PI / 2, M_PI, 0);
		CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, M_PI, 3 * M_PI / 2, 0);
        
        CGContextClosePath(context);
        
        CGContextClip(context);
        
        //Draw the gloss gradient
        CGGradientRef glossGradient;
        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
            1.0, 1.0, 1.0, 0.06 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
        
        topCenter = CGPointMake(CGRectGetMinX(glossRect), CGRectGetMidY(glossRect));
        bottomCenter = CGPointMake(CGRectGetMaxX(glossRect), CGRectGetMidY(glossRect));
        CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0); //Gloss Effect
        
        CGGradientRelease(glossGradient);
        
        CGContextRestoreGState(context);
        CGFloat lastPoint = currentBounds.size.height;
        
        if (lastPoint < 100.0) {
            lastPoint = currentBounds.size.height;
        } else if (lastPoint < 200.0) {
            lastPoint = currentBounds.size.height/2;
        } else {
            lastPoint = currentBounds.size.height/4;
        }
        
        CGColorSpaceRelease(rgbColorspace);
        
    } else if (barViewDisplayStyle == BarStyleMatte) {
        //Draw the bars without a darkened shadow gradient or a gloss effect
        CGGradientRef shadowGradient;
        CGColorSpaceRef rgbColorspace;
        size_t num_locations = 2;
        CGFloat locations2[2] = { 0.0, 1.0 };
        CGFloat components2[8] = { 0.0, 0.0, 0.0, 0.0,  // Start color
            0.0, 0.0, 0.0, 0.3 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        shadowGradient = CGGradientCreateWithColorComponents(rgbColorspace, components2, locations2, num_locations);
        CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
        CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
        CGContextDrawLinearGradient(context, shadowGradient, topCenter, bottomCenter, 0); //Lighting Gradient
        CGGradientRelease(shadowGradient);
        
        CGFloat glossCornerRadius = cornerRadius;
        CGRect glossRect;
        
        glossRect = CGRectMake(0.0f, 0.0f, currentBounds.size.width, currentBounds.size.height);
        
        CGContextSaveGState(context);
        
        CGContextBeginPath(context);
        
		CGContextMoveToPoint(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect));
		CGContextAddArc(context, CGRectGetMaxX(glossRect) - glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, 3 * M_PI / 2, 0, 0);
		
		CGContextAddLineToPoint(context, CGRectGetMaxX(glossRect), CGRectGetMaxY(glossRect));
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMaxY(glossRect));
		
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMinY(glossRect) - cornerRadius);
		CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, M_PI, 3 * M_PI / 2, 0);
        
        CGContextClosePath(context);
        
        CGContextClip(context);
        
        //Draw the gloss gradient
        CGGradientRef glossGradient;
        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
            1.0, 1.0, 1.0, 0.06 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
        
        topCenter = CGPointMake(CGRectGetMinX(glossRect), CGRectGetMidY(glossRect));
        bottomCenter = CGPointMake(CGRectGetMaxX(glossRect), CGRectGetMidY(glossRect));
        CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0); //Gloss Effect
        
        CGGradientRelease(glossGradient);
        
        CGContextRestoreGState(context);
        CGFloat lastPoint = currentBounds.size.height;
        
        if (lastPoint < 100.0) {
            lastPoint = currentBounds.size.height;
        } else if (lastPoint < 200.0) {
            lastPoint = currentBounds.size.height/2;
        } else {
            lastPoint = currentBounds.size.height/4;
        }
        
        CGColorSpaceRelease(rgbColorspace);
        
    } else if (barViewDisplayStyle == BarStyleFlat) {
        //Draw the bars with no effects at all - just plain colored bars
        CGGradientRef shadowGradient;
        CGColorSpaceRef rgbColorspace;
        size_t num_locations = 2;
        CGFloat locations2[2] = { 0.0, 1.0 };
        CGFloat components2[8] = { 0.0, 0.0, 0.0, 0.0,  // Start color
            0.0, 0.0, 0.0, 0.3 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        shadowGradient = CGGradientCreateWithColorComponents(rgbColorspace, components2, locations2, num_locations);
        CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
        CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
        //CGContextDrawLinearGradient(context, shadowGradient, topCenter, bottomCenter, 0); //Lighting Gradient
        CGGradientRelease(shadowGradient);
        
        CGFloat glossCornerRadius = cornerRadius;
        CGRect glossRect;
        
        glossRect = CGRectMake(0.0f, 0.0f, currentBounds.size.width, currentBounds.size.height);
        
        CGContextSaveGState(context);
        
        CGContextBeginPath(context);
        
		CGContextMoveToPoint(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect));
		CGContextAddArc(context, CGRectGetMaxX(glossRect) - glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, 3 * M_PI / 2, 0, 0);
		
		CGContextAddLineToPoint(context, CGRectGetMaxX(glossRect), CGRectGetMaxY(glossRect));
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMaxY(glossRect));
		
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMinY(glossRect) - cornerRadius);
		CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, M_PI, 3 * M_PI / 2, 0);
        
        CGContextClosePath(context);
        
        CGContextClip(context);
        
        //Draw the gloss gradient
        CGGradientRef glossGradient;
        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
            1.0, 1.0, 1.0, 0.06 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
        
        topCenter = CGPointMake(CGRectGetMinX(glossRect), CGRectGetMidY(glossRect));
        bottomCenter = CGPointMake(CGRectGetMaxX(glossRect), CGRectGetMidY(glossRect));
        //CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0); //Gloss Effect
        
        CGGradientRelease(glossGradient);
        
        CGContextRestoreGState(context);
        CGFloat lastPoint = currentBounds.size.height;
        
        if (lastPoint < 100.0) {
            lastPoint = currentBounds.size.height;
        } else if (lastPoint < 200.0) {
            lastPoint = currentBounds.size.height/2;
        } else {
            lastPoint = currentBounds.size.height/4;
        }
        
        CGColorSpaceRelease(rgbColorspace);
        
    } else {
        //Draw the bars with a full gloss effect - this is the default behavior
        CGGradientRef shadowGradient;
        CGColorSpaceRef rgbColorspace;
        size_t num_locations = 2;
        CGFloat locations2[2] = { 0.0, 1.0 };
        CGFloat components2[8] = { 0.0, 0.0, 0.0, 0.0,  // Start color
            0.0, 0.0, 0.0, 0.3 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        shadowGradient = CGGradientCreateWithColorComponents(rgbColorspace, components2, locations2, num_locations);
        CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
        CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
        CGContextDrawLinearGradient(context, shadowGradient, topCenter, bottomCenter, 0); //Lighting Gradient
        CGGradientRelease(shadowGradient);
        
        CGFloat glossCornerRadius = cornerRadius;
        CGRect glossRect;
        
        glossRect = CGRectMake(0.0f, 0.0f, currentBounds.size.width, currentBounds.size.height);
        
        CGContextSaveGState(context);
        
        CGContextBeginPath(context);
        
		CGContextMoveToPoint(context, CGRectGetMidX(glossRect), CGRectGetMinY(glossRect));
		CGContextAddLineToPoint(context, CGRectGetMidX(glossRect), CGRectGetMaxY(glossRect));
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMaxY(glossRect));
		
		CGContextAddLineToPoint(context, CGRectGetMinX(glossRect), CGRectGetMinY(glossRect) - cornerRadius);
		
		CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMaxY(glossRect) - glossCornerRadius, glossCornerRadius, M_PI / 2, M_PI, 0);
		CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, M_PI, 3 * M_PI / 2, 0);
        
        CGContextClosePath(context);
        
        CGContextClip(context);
        
        //Draw the gloss gradient
        CGGradientRef glossGradient;
        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
            1.0, 1.0, 1.0, 0.06 }; // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
        
        topCenter = CGPointMake(CGRectGetMinX(glossRect), CGRectGetMidY(glossRect));
        bottomCenter = CGPointMake(CGRectGetMaxX(glossRect), CGRectGetMidY(glossRect));
        CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0); //Gloss Effect
        
        CGGradientRelease(glossGradient);
        
        CGContextRestoreGState(context);
        CGFloat lastPoint = currentBounds.size.height;
        
        if (lastPoint < 100.0) {
            lastPoint = currentBounds.size.height;
        } else if (lastPoint < 200.0) {
            lastPoint = currentBounds.size.height/2;
        } else {
            lastPoint = currentBounds.size.height/4;
        }
        
        CGColorSpaceRelease(rgbColorspace);
    }
    
    
    //Add a shadow to each bar
    if (barViewShadow == BarShadowLight) {
        //Light shading
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(1,1);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.4;
    } else if (barViewShadow == BarShadowHeavy) {
        //Heavy shading
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(1,1);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.6;
    } else if (barViewShadow == BarShadowNone) {
        //Do not add shading
        self.layer.masksToBounds = NO;
    } else {
        //Default shading is Light
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(1,1);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.4;
    }
}

#pragma mark - Settings

- (void)setupBarStyle:(BarDisplayStyle)displayStyle {
    self.barViewDisplayStyle = displayStyle;
}

- (void)setupBarShape:(BarShape)shape {
    self.barViewShape = shape;
}

- (void)setupBarShadow:(BarShadow)shadow {
    self.barViewShadow = shadow;
}

@end
