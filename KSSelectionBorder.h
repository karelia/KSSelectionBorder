//
//  KSSelectionBorder.h
//  Sandvox
//
//  Created by Mike on 06/09/2009.
//  Copyright 2009-2012 Karelia Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuartzCore/QuartzCore.h>


typedef enum {
    KSSelectionBorderNoHandle,
    KSSelectionBorderUpperLeftHandle,
    KSSelectionBorderUpperMiddleHandle,
    KSSelectionBorderUpperRightHandle,
    KSSelectionBorderMiddleLeftHandle,
    KSSelectionBorderMiddleRightHandle,
    KSSelectionBorderLowerLeftHandle,
    KSSelectionBorderLowerMiddleHandle,
    KSSelectionBorderLowerRightHandle,
} KSSelectionBorderHandle;



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
       handle:(KSSelectionBorderHandle *)handle;

- (NSInteger)handleAtPoint:(NSPoint)point frameRect:(NSRect)bounds;
- (NSPoint)locationOfHandle:(KSSelectionBorderHandle)handle frameRect:(NSRect)bounds;


#pragma mark Drawing
- (void)drawWithFrame:(NSRect)frameRect inView:(NSView *)view;
- (void)drawWithGraphicBounds:(NSRect)bounds inView:(NSView *)view;


@end


#pragma mark -


@interface NSCursor (Karelia)
// Draws the cursor's image, being cunning enough to draw the hot point at specified point
- (void)ks_drawAtPoint:(NSPoint)point;
- (NSRect)ks_drawingRectForPoint:(NSPoint)point;
@end