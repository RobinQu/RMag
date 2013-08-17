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
    CGPDFDocumentRef _PDFDocRef;
}

+ (Class)tiledLayerClass
{
    return [JCPDFTiledView class];
}

- (id)initWithFrame:(CGRect)frame document:(CGPDFDocumentRef)document page:(CGPDFPageRef)page
{
    CGSize contentSize = CGSizeZero;
    _PDFDocRef = document;
    if (page != NULL) {
        _PDFPageRef = page;
        CGPDFPageRetain(_PDFPageRef);
        CGRect cropBoxRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
        CGRect mediaBoxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
        contentSize = effectiveRect.size;
    }
    self = [self initWithFrame:frame contentSize:contentSize];
    self.magazineMode = YES;
    self.scrollView.minimumZoomScale = 0.5f;
    self.zoomScale = 0.5f;
    return self;
}

- (void)setMagazineMode:(BOOL)magazineMode
{
    if (magazineMode != _magazineMode) {
        [self willChangeValueForKey:@"magazineMode"];
        _magazineMode = magazineMode;
        
        self.scrollView.showsHorizontalScrollIndicator = !magazineMode;
        self.scrollView.showsVerticalScrollIndicator = !magazineMode;
        self.zoomsInOnDoubleTap = !magazineMode;
        self.zoomsOutOnTwoFingerTap = !magazineMode;
        [self didChangeValueForKey:@"magazineMode"];
    }
}

- (void)dealloc
{
    CGPDFPageRelease(_PDFPageRef);
}


#pragma mark - JCPDFTiledViewDelegate

- (CGPDFDocumentRef)pdfDocumentForTiledView:(__unused JCPDFTiledView *)tiledView
{
    return _PDFDocRef;
}

- (CGPDFPageRef)pdfPageForTiledView:(__unused JCPDFTiledView *)tiledView
{
    return _PDFPageRef;
}

@end
