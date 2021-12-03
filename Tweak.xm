/*%hook SBScreenshotManagerDataSource
-(id)screenshotManagerScreensToScreenshot:(id)arg1 {
	NSLog(@"ajfpoasjpoasjf%@",arg1);
	%orig;
}
%end*/
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <IOSurface/IOSurfaceRef.h>
#import <VideoToolbox/VideoToolbox.h>


@implementation UIImage (Resize)
- (UIImage *)imageWithSize:(CGSize)newSize
{
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext*_Nonnull myContext) {
        [self drawInRect:(CGRect) {.origin = CGPointZero, .size = newSize}];
    }];
    return [image imageWithRenderingMode:self.renderingMode];
}
@end

%hook SSMainScreenSnapshotter

-(UIImage*)takeScreenshot{
	UIImage *image = %orig;
	CGSize size = image.size;
	CGSize newSize = CGSizeMake(size.width/15, size.height/15);
	IOSurfaceRef ioSurface = (__bridge IOSurfaceRef)[image performSelector:@selector(ioSurface)];
	

	NSDictionary *pixelBufferAttributes = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
	CVPixelBufferRef pixcelBuffer;
    CVPixelBufferCreateWithIOSurface(NULL, ioSurface, (__bridge CFDictionaryRef _Nullable)(pixelBufferAttributes), &pixcelBuffer);
	CGImageRef cgimage;
	VTCreateCGImageFromCVPixelBuffer(pixcelBuffer, nil, &cgimage);

	image = [[UIImage alloc] initWithCGImage:cgimage];
	return [image imageWithSize:newSize];
}
%end


%hook _SSScreenCaptureResults
-(UIImage *)image{
	UIImage *image = %orig;

	return image;
}
%end