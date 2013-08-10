//
//  RPDFPageView.h
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <JCTiledScrollView/JCTiledPDFScrollView.h>

@interface RPDFPageView : JCTiledScrollView

@property (nonatomic, assign) BOOL magazineMode;

- (id)initWithFrame:(CGRect)frame document:(CGPDFDocumentRef)document page:(CGPDFPageRef)page;

@end
