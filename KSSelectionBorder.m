//
//  KSSelectionBorder.m
//  Sandvox
//
//  Created by Mike on 06/09/2009.
//  Copyright 2009 Karelia Software. All rights reserved.
//


#import "KSSelectionBorder.h"

#import "NSColor+Karelia.h"


@interface KSSelectionBorder ()
- (BOOL)isPoint:(NSPoint)point withinHandle:(SVGraphicHandle)handle frameRect:(NSRect)bounds;
- (BOOL)isPoint:(NSPoint)point withinHandleAtPoint:(NSPoint)handlePoint;

- (void)drawSelectionHandleAtPoint:(NSPoint)point inView:(NSView *)view enabled:(BOOL)enabled;
@end


#pragma mark -


@implementation KSSelectionBorder

#pragma mark Init

- (id)init
{
    self = [super init];
    
    _resizingMask = /*kCALayerLeftEdge | */kCALayerRightEdge | kCALayerBottomEdge/* | kCALayerTopEdge*/;
    _borderColor = [[[NSColor aquaColor] colorWithAlphaComponent:0.5] copy];
    
    return self;
}

- (void)dealloc
{
    [_borderColor release];
    [super dealloc];
}

#pragma mark Properties

@synthesize editing = _isEditing;
@synthesize borderColor = _borderColor;
@synthesize minSize = _minSize;

#pragma mark Resizing

@synthesize resizingMask = _resizingMask;

- (BOOL)canResizeUsingHandle:(SVGraphicHandle)handle;
{
    BOOL result = NO;
    
    unsigned int mask = [self resizingMask];
    switch (handle)
    {
        case kSVGraphicUpperLeftHandle:
            result = (mask & kCALayerLeftEdge && mask & kCALayerTopEdge);
            break;
        case kSVGraphicUpperMiddleHandle:
            result = (mask & kCALayerTopEdge);
            break;
        case kSVGraphicUpperRightHandle:
            result = (mask & kCALayerRightEdge && mask & kCALayerTopEdge);
            break;
        case kSVGraphicMiddleLeftHandle:
            result = (mask & kCALayerLeftEdge);
            break;
        case kSVGraphicMiddleRightHandle:
            result = (mask & kCALayerRightEdge);
            break;
        case kSVGraphicLowerLeftHandle:
            result = (mask & kCALayerLeftEdge && mask & kCALayerBottomEdge);
            break;
        case kSVGraphicLowerMiddleHandle:
            result = (mask & kCALayerBottomEdge);
            break;
        case kSVGraphicLowerRightHandle:
            result = (mask & kCALayerRightEdge && mask & kCALayerBottomEdge);
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark Layout

- (NSRect)frameRectForGraphicBounds:(NSRect)frameRect;
{
    // Make sure the frame meets the requirements of -minFrame.
    NSSize frameSize = frameRect.size;
    NSSize minSize = NSZeroSize;
    
    if (frameSize.width < minSize.width || frameSize.height < minSize.height)
    {
        CGFloat dX = 0.5 * (MAX(frameSize.width, minSize.width) - frameSize.width);
        CGFloat dY = 0.5 * (MAX(frameSize.height, minSize.height) - frameSize.height);
        frameRect = NSInsetRect(frameRect, dX, dY);
    }
    
    return frameRect;
}

- (NSRect)drawingRectForGraphicBounds:(NSRect)frameRect;
{
    // First, make sure the frame meets the requirements of -minFrame.
    frameRect = [self frameRectForGraphicBounds:frameRect];
    
    // Then enlarge to accomodate selection handles
    NSRect result = NSInsetRect(frameRect, -4.0, -3.0);
    return result;
}

/*  Mostly a simple question of if frame contains point, but also return yes if the point is in one of our selection handles
 */
- (BOOL)mouse:(NSPoint)mousePoint
    isInFrame:(NSRect)frameRect
       inView:(NSView *)view
       handle:(SVGraphicHandle *)outHandle;
{
    // Search through the handles
    SVGraphicHandle handle = [self handleAtPoint:mousePoint frameRect:frameRect];
    BOOL result = [self canResizeUsingHandle:handle];
    
    // Fallback to the frame if appropriate. Make sure to reset handle
    if (!result)
    {
        result = [view mouse:mousePoint inRect:frameRect];
        handle = kSVGraphicNoHandle;
    }
    
    if (outHandle) *outHandle = handle;
    return result;
}

- (NSInteger)handleAtPoint:(NSPoint)point frameRect:(NSRect)bounds;
{
    // Check handles at the corners and on the sides.
    NSInteger result = kSVGraphicNoHandle;
    if ([self isPoint:point withinHandle:kSVGraphicUpperLeftHandle frameRect:bounds])
    {
        result = kSVGraphicUpperLeftHandle;
    }
    else if ([self isPoint:point withinHandle:kSVGraphicUpperMiddleHandle frameRect:bounds])
    {
        result = kSVGraphicUpperMiddleHandle;
    }
    else if ([self isPoint:point withinHandle:kSVGraphicUpperRightHandle frameRect:bounds])
    {
        result = kSVGraphicUpperRightHandle;
    }
    else if ([self isPoint:point withinHandle:kSVGraphicMiddleLeftHandle frameRect:bounds])
    {
        result = kSVGraphicMiddleLeftHandle;
    }
    else if ([self isPoint:point withinHandle:kSVGraphicMiddleRightHandle frameRect:bounds])
    {
        result = kSVGraphicMiddleRightHandle;
    }
    else if ([self isPoint:point withinHandle:kSVGraphicLowerLeftHandle frameRect:bounds])
    {
        result = kSVGraphicLowerLeftHandle;
    }
    else if ([self isPoint:point withinHandle:kSVGraphicLowerMiddleHandle frameRect:bounds])
    {
        result = kSVGraphicLowerMiddleHandle;
    }
    else if ([self isPoint:point withinHandle:kSVGraphicLowerRightHandle frameRect:bounds])
    {
        result = kSVGraphicLowerRightHandle;
    }
    
    return result;
}

- (NSPoint)locationOfHandle:(SVGraphicHandle)handle frameRect:(NSRect)bounds;
{
    NSPoint result = NSZeroPoint;
    
    switch (handle)
    {
        case kSVGraphicUpperLeftHandle:
            result = NSMakePoint(NSMinX(bounds), NSMinY(bounds));
            break;
            
        case kSVGraphicUpperMiddleHandle:
            result = NSMakePoint(NSMidX(bounds), NSMinY(bounds));
            break;
            
        case kSVGraphicUpperRightHandle:
            result = NSMakePoint(NSMaxX(bounds), NSMinY(bounds));
            break;
            
        case kSVGraphicMiddleLeftHandle:
            result = NSMakePoint(NSMinX(bounds), NSMidY(bounds));
            break;
            
        case kSVGraphicMiddleRightHandle:
            result = NSMakePoint(NSMaxX(bounds), NSMidY(bounds));
            break;
            
        case kSVGraphicLowerLeftHandle:
            result = NSMakePoint(NSMinX(bounds), NSMaxY(bounds));
            break;
            
        case kSVGraphicLowerMiddleHandle:
            result = NSMakePoint(NSMidX(bounds), NSMaxY(bounds));
            break;
            
        case kSVGraphicLowerRightHandle:
            result = NSMakePoint(NSMaxX(bounds), NSMaxY(bounds));
            break;
            
        default:
            OBASSERT_NOT_REACHED("Unknown handle");
            break;
    }
    
    return result;
}

- (BOOL)isPoint:(NSPoint)point withinHandle:(SVGraphicHandle)handle frameRect:(NSRect)bounds;
{
    NSPoint handlePoint = [self locationOfHandle:handle frameRect:bounds];
    BOOL result = [self isPoint:point withinHandleAtPoint:handlePoint];
    return result;
}

- (BOOL)isPoint:(NSPoint)point withinHandleAtPoint:(NSPoint)handlePoint;
{
    // Check a handle-sized rectangle that's centered on the handle point.
    NSRect handleBounds = NSMakeRect(handlePoint.x - 3.0,
                                     handlePoint.y - 3.0,
                                     7.0,
                                     7.0);
    
    return NSPointInRect(point, handleBounds);
}

#pragma mark Drawing

- (void)drawWithFrame:(NSRect)frameRect inView:(NSView *)view;
{
    unsigned int mask = [self resizingMask];
    
    // First draw overall frame. enlarge by 1 pixel to avoid drawing directly over the graphic
    NSColor *border = [self borderColor];
    if (border)
    {
        NSRect outlineRect = NSInsetRect(frameRect, -1.0, -1.0);
        if (!mask) frameRect = outlineRect; // Non-resizeable borders draw their handles slightly differently
        
        [border setFill];
        
        NSFrameRectWithWidthUsingOperation([view centerScanRect:outlineRect],
                                           1.0,
                                           NSCompositeSourceOver);
    }
    
    
    // Then draw handles. Pixels are weird, need to draw using a slightly smaller rectangle otherwise edges get cut off
    if (![self isEditing])
    {
        NSRect editingHandlesRect = frameRect;
        editingHandlesRect.size.width -= 1.0f;
        editingHandlesRect.size.height -= 1.0f;
        
        
        CGFloat minX = NSMinX(editingHandlesRect);
        CGFloat midX = NSMidX(editingHandlesRect);
        CGFloat maxX = NSMaxX(editingHandlesRect);
        CGFloat minY = NSMinY(editingHandlesRect);
        CGFloat midY = NSMidY(editingHandlesRect);
        CGFloat maxY = NSMaxY(editingHandlesRect);
        
        
        BOOL canResizeLeft = (mask & kCALayerLeftEdge);
        BOOL canResizeTop = (mask & kCALayerTopEdge);
        BOOL canResizeRight = (mask & kCALayerRightEdge);
        BOOL canResizeBottom = (mask & kCALayerBottomEdge);
        
        if (canResizeTop || canResizeBottom)
        {
            [self drawSelectionHandleAtPoint:NSMakePoint(minX, minY)
                                      inView:view
                                     enabled:(canResizeTop && canResizeLeft)];
            
            [self drawSelectionHandleAtPoint:NSMakePoint(maxX, minY)
                                      inView:view
                                     enabled:(canResizeTop && canResizeRight)];
            
            [self drawSelectionHandleAtPoint:NSMakePoint(minX, maxY)
                                      inView:view
                                     enabled:(canResizeBottom && canResizeLeft)];
            
            [self drawSelectionHandleAtPoint:NSMakePoint(maxX, maxY)
                                      inView:view
                                     enabled:(canResizeBottom && canResizeRight)];
            
            if (NSWidth(frameRect) > 16.0f)
            {
                [self drawSelectionHandleAtPoint:NSMakePoint(midX, minY)
                                          inView:view
                                         enabled:canResizeTop];
                
                [self drawSelectionHandleAtPoint:NSMakePoint(midX, maxY)
                                          inView:view
                                         enabled:canResizeBottom];
            }
        }
        
        // Want to draw side handles, unless height is adjustable and there isn't enough space
        if ((canResizeTop || canResizeBottom) && NSHeight(frameRect) <= 16.0f) return;
        
        [self drawSelectionHandleAtPoint:NSMakePoint(minX, midY)
                                  inView:view
                                 enabled:canResizeLeft];
        
        [self drawSelectionHandleAtPoint:NSMakePoint(maxX, midY)
                                  inView:view
                                 enabled:canResizeRight];
    }
}

- (void)drawWithGraphicBounds:(NSRect)frameRect inView:(NSView *)view;
{
    [self drawWithFrame:[self frameRectForGraphicBounds:frameRect] inView:view];
}

- (void)drawSelectionHandleAtPoint:(NSPoint)point inView:(NSView *)view enabled:(BOOL)enabled;
{
    NSRect rect = [view centerScanRect:NSMakeRect(point.x - 3.0,
                                                  point.y - 3.0,
                                                  7.0,
                                                  7.0)];
    
    
    // For unresizeable borders draw circular handles. Needs some layout tweaks to pull off
    if (![self resizingMask])
    {
         [[NSColor blackColor] setStroke];
        [[NSColor whiteColor] setFill];
        
        rect = NSInsetRect(rect, 0.5, 0.5);
        NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:rect];
        [path setLineWidth:1.0];
        [path fill];
        
        NSGraphicsContext *context = [NSGraphicsContext currentContext];
        [context saveGraphicsState];
        [context setShouldAntialias:NO];
        [path stroke];
        [context restoreGraphicsState];
        
        return;
    }
    
    
    // Draw middle
    [[NSColor colorWithCalibratedWhite:1.0 alpha:(enabled ? 1.0 : 0.5)] setFill];
    NSRectFillUsingOperation(NSInsetRect(rect, 1.0f, 1.0f), NSCompositeSourceOver);
    
    // Draw border
    if (enabled)
    {
        [[NSColor blackColor] setFill];
        NSFrameRect(rect);
    }
    else
    {
        [[[NSColor aquaColor] colorWithAlphaComponent:0.5] setFill];
        NSFrameRectWithWidthUsingOperation(rect, 1.0, NSCompositeSourceOver);
    }
}

@end
