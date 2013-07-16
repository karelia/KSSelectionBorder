//
//  KSSelectionBorder.m
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

#import "KSSelectionBorder.h"

#import "ESCursors.h"


#define AQUA_COLOR [NSColor colorWithCalibratedHue:0.583333f saturation:1.0f brightness:1.0f alpha:1.0f]


@interface KSSelectionBorder ()
- (BOOL)isPoint:(NSPoint)point withinHandle:(KSSelectionBorderHandle)handle frameRect:(NSRect)bounds;
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
    _borderColor = [[AQUA_COLOR colorWithAlphaComponent:0.5] copy];
    
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

- (BOOL)canResizeUsingHandle:(KSSelectionBorderHandle)handle;
{
    BOOL result = NO;
    
    unsigned int mask = [self resizingMask];
    switch (handle)
    {
        case KSSelectionBorderUpperLeftHandle:
            result = (mask & kCALayerLeftEdge && mask & kCALayerTopEdge);
            break;
        case KSSelectionBorderUpperMiddleHandle:
            result = (mask & kCALayerTopEdge);
            break;
        case KSSelectionBorderUpperRightHandle:
            result = (mask & kCALayerRightEdge && mask & kCALayerTopEdge);
            break;
        case KSSelectionBorderMiddleLeftHandle:
            result = (mask & kCALayerLeftEdge);
            break;
        case KSSelectionBorderMiddleRightHandle:
            result = (mask & kCALayerRightEdge);
            break;
        case KSSelectionBorderLowerLeftHandle:
            result = (mask & kCALayerLeftEdge && mask & kCALayerBottomEdge);
            break;
        case KSSelectionBorderLowerMiddleHandle:
            result = (mask & kCALayerBottomEdge);
            break;
        case KSSelectionBorderLowerRightHandle:
            result = (mask & kCALayerRightEdge && mask & kCALayerBottomEdge);
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark Cursor

+ (NSCursor *)cursorWithHandle:(KSSelectionBorderHandle)handle;
{
    CGFloat radians = 0.0;
    switch(handle)
    {
            // We might want to consider using angled size cursors  even for middle handles to show that you are resizing both dimensions?
            
        case KSSelectionBorderUpperLeftHandle:		radians = M_PI_4 + M_PI_2;			break;
        case KSSelectionBorderUpperMiddleHandle:	radians = M_PI_2;					break;
        case KSSelectionBorderUpperRightHandle:	radians = M_PI_4;					break;
        case KSSelectionBorderMiddleLeftHandle:	radians = M_PI;						break;
        case KSSelectionBorderMiddleRightHandle:	radians = M_PI;						break;
        case KSSelectionBorderLowerLeftHandle:		radians = M_PI + M_PI_4;			break;
        case KSSelectionBorderLowerMiddleHandle:	radians = M_PI + M_PI_2;			break;
        case KSSelectionBorderLowerRightHandle:	radians = M_PI + M_PI_2 + M_PI_4;	break;
        default: break;
    }
    return [ESCursors straightCursorForAngle:radians withSize:16.0];
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
       handle:(KSSelectionBorderHandle *)outHandle;
{
    // Search through the handles
    KSSelectionBorderHandle handle = [self handleAtPoint:mousePoint frameRect:frameRect];
    BOOL result = [self canResizeUsingHandle:handle];
    
    // Fallback to the frame if appropriate. Make sure to reset handle
    if (!result)
    {
        result = [view mouse:mousePoint inRect:frameRect];
        handle = KSSelectionBorderNoHandle;
    }
    
    if (outHandle) *outHandle = handle;
    return result;
}

- (NSInteger)handleAtPoint:(NSPoint)point frameRect:(NSRect)bounds;
{
    // Check handles at the corners and on the sides.
    NSInteger result = KSSelectionBorderNoHandle;
    if ([self isPoint:point withinHandle:KSSelectionBorderUpperLeftHandle frameRect:bounds])
    {
        result = KSSelectionBorderUpperLeftHandle;
    }
    else if ([self isPoint:point withinHandle:KSSelectionBorderUpperMiddleHandle frameRect:bounds])
    {
        result = KSSelectionBorderUpperMiddleHandle;
    }
    else if ([self isPoint:point withinHandle:KSSelectionBorderUpperRightHandle frameRect:bounds])
    {
        result = KSSelectionBorderUpperRightHandle;
    }
    else if ([self isPoint:point withinHandle:KSSelectionBorderMiddleLeftHandle frameRect:bounds])
    {
        result = KSSelectionBorderMiddleLeftHandle;
    }
    else if ([self isPoint:point withinHandle:KSSelectionBorderMiddleRightHandle frameRect:bounds])
    {
        result = KSSelectionBorderMiddleRightHandle;
    }
    else if ([self isPoint:point withinHandle:KSSelectionBorderLowerLeftHandle frameRect:bounds])
    {
        result = KSSelectionBorderLowerLeftHandle;
    }
    else if ([self isPoint:point withinHandle:KSSelectionBorderLowerMiddleHandle frameRect:bounds])
    {
        result = KSSelectionBorderLowerMiddleHandle;
    }
    else if ([self isPoint:point withinHandle:KSSelectionBorderLowerRightHandle frameRect:bounds])
    {
        result = KSSelectionBorderLowerRightHandle;
    }
    
    return result;
}

- (NSPoint)locationOfHandle:(KSSelectionBorderHandle)handle frameRect:(NSRect)bounds;
{
    NSPoint result = NSZeroPoint;
    
    switch (handle)
    {
        case KSSelectionBorderUpperLeftHandle:
            result = NSMakePoint(NSMinX(bounds), NSMinY(bounds));
            break;
            
        case KSSelectionBorderUpperMiddleHandle:
            result = NSMakePoint(NSMidX(bounds), NSMinY(bounds));
            break;
            
        case KSSelectionBorderUpperRightHandle:
            result = NSMakePoint(NSMaxX(bounds), NSMinY(bounds));
            break;
            
        case KSSelectionBorderMiddleLeftHandle:
            result = NSMakePoint(NSMinX(bounds), NSMidY(bounds));
            break;
            
        case KSSelectionBorderMiddleRightHandle:
            result = NSMakePoint(NSMaxX(bounds), NSMidY(bounds));
            break;
            
        case KSSelectionBorderLowerLeftHandle:
            result = NSMakePoint(NSMinX(bounds), NSMaxY(bounds));
            break;
            
        case KSSelectionBorderLowerMiddleHandle:
            result = NSMakePoint(NSMidX(bounds), NSMaxY(bounds));
            break;
            
        case KSSelectionBorderLowerRightHandle:
            result = NSMakePoint(NSMaxX(bounds), NSMaxY(bounds));
            break;
            
        default:
            OBASSERT_NOT_REACHED("Unknown handle");
            break;
    }
    
    return result;
}

- (BOOL)isPoint:(NSPoint)point withinHandle:(KSSelectionBorderHandle)handle frameRect:(NSRect)bounds;
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
        [[AQUA_COLOR colorWithAlphaComponent:0.5] setFill];
        NSFrameRectWithWidthUsingOperation(rect, 1.0, NSCompositeSourceOver);
    }
}

@end


#pragma mark -


@implementation NSCursor (Karelia)

- (void)ks_drawAtPoint:(NSPoint)point;
{
    NSImage *image = [self image];
    
    
    // Figure where to draw accounting for hot point
    NSRect rect;
    rect.origin.x = point.x - [self hotSpot].x;
    rect.origin.y = point.y - [self hotSpot].y;
    rect.size = [image size];
    
    
    // Flip the context
    NSGraphicsContext *graphicsContext = [NSGraphicsContext currentContext];
    CGContextRef context = [graphicsContext graphicsPort];
    if ([graphicsContext isFlipped])
    {
        CGContextSaveGState(context);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0.0, -2.0*rect.origin.y-NSHeight(rect));
    }
    
    [image drawInRect:rect
             fromRect:NSZeroRect
            operation:NSCompositeSourceOver
             fraction:1.0f];
    
    if ([graphicsContext isFlipped]) CGContextRestoreGState(context);
}

- (NSRect)ks_drawingRectForPoint:(NSPoint)point;
{
    NSRect result;
    result.origin.x = point.x - [self hotSpot].x;
    result.origin.y = point.y - [self hotSpot].y;
    result.size = [[self image] size];
    
    return result;
}

@end
