
#import <Foundation/Foundation.h>

@interface RPDFDocumentOutline : NSObject <NSObject>

+ (NSArray *)outlineFromFileURL:(NSURL *)fileURL password:(NSString *)phrase;

+ (NSArray *)outlineFromDocument:(CGPDFDocumentRef)document password:(NSString *)phrase;

+ (void)logDocumentOutlineArray:(NSArray *)array;

@end

@interface RPDFOutlineEntry : NSObject <NSObject>

+ (id)newWithTitle:(NSString *)title target:(id)target level:(NSInteger)level;

- (id)initWithTitle:(NSString *)title target:(id)target level:(NSInteger)level;

@property (nonatomic, assign, readonly) NSInteger level;
@property (nonatomic, strong, readwrite) NSMutableArray *children;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) id target;

@end
