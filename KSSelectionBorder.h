//
//  KSSelectionBorder.h
//  Sandvox
//
//  Created by Mike on 06/09/2009.
//  Copyright 2009 Karelia Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuartzCore/QuartzCore.h>


typedef enum {
    kSVGraphicNoHandle,
    kSVGraphicUpperLeftHandle,
    kSVGraphicUpperMiddleHandle,
    kSVGraphicUpperRightHandle,
    kSVGraphicMiddleLeftHandle,
    kSVGraphicMiddleRightHandle,
    kSVGraphicLowerLeftHandle,
    kSVGraphicLowerMiddleHandle,
    kSVGraphicLowerRightHandle,
} SVGraphicHandle;



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
@property(nonatomic) unsigned int resizingMask; // bitmask of CAEdgeAntialiasingMask
- (BOOL)canResizeUsingHandle:(SVGraphicHandle)handle;


#pragma mark Layout

- (NSRect)frameRectForGraphicBounds:(NSRect)bounds;  // adjusts frame to suit -minSize if needed
- (NSRect)drawingRectForGraphicBounds:(NSRect)bounds;

- (BOOL)mouse:(NSPoint)mousePoint
    isInFrame:(NSRect)frameRect
       inView:(NSView *)view
       handle:(SVGraphicHandle *)handle;

- (NSInteger)handleAtPoint:(NSPoint)point frameRect:(NSRect)bounds;
- (NSPoint)locationOfHandle:(SVGraphicHandle)handle frameRect:(NSRect)bounds;


#pragma mark Drawing
- (void)drawWithFrame:(NSRect)frameRect inView:(NSView *)view;
- (void)drawWithGraphicBounds:(NSRect)bounds inView:(NSView *)view;


@end