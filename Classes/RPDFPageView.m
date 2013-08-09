//
//  RPDFPageView.m
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RPDFPageView.h"
#import <JCTiledScrollView/JCPDFTiledView.h>

@implementation RPDFPageView
{
    CGPDFPageRef _PDFPageRef;
}

+ (Class)tiledLayerClass
{
    return [JCPDFTiledView class];
}

- (id)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page
{
    CGSize contentSize = CGSizeZero;
    if (page != NULL) {
        _PDFPageRef = page;
        CGPDFPageRetain(_PDFPageRef);
        
        CGRect cropBoxRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
        CGRect mediaBoxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
        contentSize = effectiveRect.size;
    }
    self = [self initWithFrame:frame contentSize:contentSize];
    
    return self;
}

- (void)dealloc
{
    CGPDFPageRelease(_PDFPageRef);
}

@end
