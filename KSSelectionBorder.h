//
//  KSSelectionBorder.h
//  Sandvox
//
//  Created by Mike Abdullah on 06/09/2009.
//  Copyright © 2009 Karelia Software
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

#import <Cocoa/Cocoa.h>

#import <QuartzCore/QuartzCore.h>


typedef NS_ENUM(NSInteger, KSSelectionBorderHandle) {
    KSSelectionBorderNoHandle,
    KSSelectionBorderUpperLeftHandle,
    KSSelectionBorderUpperMiddleHandle,
    KSSelectionBorderUpperRightHandle,
    KSSelectionBorderMiddleLeftHandle,
    KSSelectionBorderMiddleRightHandle,
    KSSelectionBorderLowerLeftHandle,
    KSSelectionBorderLowerMiddleHandle,
    KSSelectionBorderLowerRightHandle,
};



enum
{
    kSVSelectionXResizeable     = 1U << 0,
    kSVSelectionYResizeable     = 1U << 1,
    kSVSelectionWidthResizeable = 1U << 2,
    kSVSelectionHeightResizeable= 1U << 3,
};
//typedef SVSelectionResizingMask NSInteger;


@interface KSSelectionBorder : NSObject
{
    BOOL            _isEditing;
    NSSize          _minSize;
    unsigned int    _resizingMask;
    NSColor         *_borderColor;
}

@property(nonatomic, getter=isEditing) BOOL editing;
@property(nonatomic, copy) NSColor *borderColor;
@property(nonatomic) NSSize minSize;


#pragma mark Resizing

// Bitmask of CAEdgeAntialiasingMask. Deliberately unsigned int to match CALayer.edgeAntialiasingMask
@property(nonatomic) unsigned int resizingMask;

- (BOOL)canResizeUsingHandle:(KSSelectionBorderHandle)handle;


#pragma mark Cursor
+ (NSCursor *)cursorWithHandle:(KSSelectionBorderHandle)handle;


#pragma mark Layout

- (NSRect)frameRectForGraphicBounds:(NSRect)bounds;  // adjusts frame to suit -minSize if needed
- (NSRect)drawingRectForGraphicBounds:(NSRect)bounds;

- (BOOL)mouse:(NSPoint)mousePoint
    isInFrame:(NSRect)frameRect
       inView:(NSView *)view
       handle:(KSSelectionBorderHandle *)handle __attribute((nonnull(3)));

- (NSInteger)handleAtPoint:(NSPoint)point frameRect:(NSRect)bounds;
- (NSPoint)locationOfHandle:(KSSelectionBorderHandle)handle frameRect:(NSRect)bounds;


#pragma mark Drawing
- (void)drawWithFrame:(NSRect)frameRect inView:(NSView *)view __attribute((nonnull(2)));
- (void)drawWithGraphicBounds:(NSRect)bounds inView:(NSView *)view __attribute((nonnull(2)));


@end


#pragma mark -


@interface NSCursor (Karelia)
// Draws the cursor's image, being cunning enough to draw the hot point at specified point
- (void)ks_drawAtPoint:(NSPoint)point;
- (NSRect)ks_drawingRectForPoint:(NSPoint)point;
@end