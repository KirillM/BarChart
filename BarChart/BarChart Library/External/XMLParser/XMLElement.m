//
//  XMLElement.m
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

#import "XMLElement.h"

@implementation XMLElement

@synthesize children, attributes, parent, name, innerText;

- init {
	return [self initWithName:nil];
}

- initWithName:(NSString *)aname {
	if ( self = [super init] ) {
		name = aname;
		children = [[NSMutableArray alloc] init];
		attributes = [[NSMutableDictionary alloc] init];
		innerText = [[NSMutableString alloc] init];
	}
	return self;
}


- (bool) hasAttribute:(NSString *)aname {
	return ([attributes objectForKey:aname] != nil);
}

- (NSString *) getAttribute:(NSString *)aname {
	return [attributes objectForKey:aname];
}

- (void)setAttribute:(NSString *)aname value:(NSString *)value {
	[attributes setValue:value forKey:aname];
}

- (NSString *) escapedXmlString:(NSString *)string replaceQuotes:(bool)replaceQuotes {
	NSMutableString *ms = [NSMutableString stringWithString:string];
	[ms replaceOccurrencesOfString:@"&" withString:@"&amp;" options:0 range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, [ms length])];
	if (replaceQuotes)
		[ms replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:0 range:NSMakeRange(0, [ms length])];
	return ms;
}

- (XMLElement *) getChild:(NSString *)childName {
	for (XMLElement *el in children)
		if ([el.name isEqual:childName])
			return el;
	return nil;
}

- (XMLElement *) appendElement:(NSString *)aname {
	XMLElement *el = [[XMLElement alloc] init];
	el.name = aname;
	el.parent = self;
	[self.children addObject:el];
	 // collection now pwns el
	
	return el;
}

- (XMLElement *) appendElement:(NSString *)aname withText:(NSString *)text {
	XMLElement *el = [self appendElement:aname];
	el.innerText = text;
	return el;
}

- (NSString *) childText:(NSString *)childName {
	for (XMLElement *el in children)
		if ([el.name isEqual:childName])
			return el.innerText;
	return nil;
}

- (NSString *) copyOuterXml {
	NSMutableString* xml = [[NSMutableString alloc] init];

	// Open start tag
	[xml appendFormat: @"<%@", name];
	
	// Attributes
	for (NSString *aname in attributes) {
		NSString *avalue = [self escapedXmlString:[attributes objectForKey:aname] replaceQuotes:YES];
		[xml appendFormat: @" %@=\"%@\"", aname, avalue];
	}
	
	// Close start tag
	if ( (innerText != nil && [innerText length] > 0) || ([children count] > 0))
		[xml appendString: @">"];
	else {
		[xml appendString: @"/>"];
		return xml;
	}

	// Inner text
	if (innerText != nil && [innerText length] > 0) {
		NSString *avalue = [self escapedXmlString:innerText replaceQuotes:NO];
		[xml appendString:avalue];
	}
	
	// Children
	for (int i = 0; i < [children count]; i++) {
		NSString *childXml = [(XMLElement*)[children objectAtIndex: i] copyOuterXml];
		[xml appendString:childXml];
	}
		
	// End tag
	[xml appendFormat: @"</%@>", name];

	return xml;
}

- (XMLElement *) rootElement {
	if (parent == nil)
		return self;
	else
		return [parent rootElement];
}

- (XMLElement *) firstChild {
	if ([children count] > 0)
		return [children objectAtIndex:0];
	else
		return nil;
}

@end
