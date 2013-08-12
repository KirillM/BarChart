//
//  XMLElement.h
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

@interface XMLElement : NSObject  {
	NSMutableArray *children;
	NSMutableDictionary *attributes;
	XMLElement *__unsafe_unretained parent;
	NSString *name;
	NSString *innerText;
}

@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, unsafe_unretained) XMLElement *parent;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *innerText;

- initWithName:(NSString *)aname;
- (bool) hasAttribute:(NSString *)name;
- (NSString *) getAttribute:(NSString *)name;
- (void)setAttribute:(NSString *)name value:(NSString *)value;
- (XMLElement *) getChild:(NSString *)childName;
- (XMLElement *) appendElement:(NSString *)aname;
- (XMLElement *) appendElement:(NSString *)aname withText:(NSString *)text;
- (NSString *) childText:(NSString *)childName;
- (NSString *) copyOuterXml;
- (XMLElement *) rootElement;
- (XMLElement *) firstChild;

@end
