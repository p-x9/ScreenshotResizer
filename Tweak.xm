#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <IOSurface/IOSurfaceRef.h>
#import <VideoToolbox/VideoToolbox.h>

#define PREF_PATH @"/var/mobile/Library/Preferences/com.p-x9.screenshotresizer.pref.plist"
#define NOTIFY "com.p-x9.screenshotresizer.prefschanged"

BOOL isTweakEnabled = false;
CGFloat scale = 0.5;

static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object,
                            CFDictionaryRef userInfo) {
  @autoreleasepool {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];

    isTweakEnabled = (BOOL)[dict[@"isEnabled"] ?: @NO boolValue];
    scale = (CGFloat)[dict[@"scale"] ?: @0.5 floatValue];
  }
}

@implementation UIImage (Resize)
- (UIImage *)resizedWithScale:(CGFloat)scale {
	CGSize size = self.size;
	CGSize newSize = CGSizeMake(size.width*scale, size.height*scale);
	return [self resizedWithSize:newSize];
}

- (UIImage *)resizedWithSize:(CGSize)newSize
{
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext*_Nonnull myContext) {
        [self drawInRect:(CGRect) {.origin = CGPointZero, .size = newSize}];
    }];
    return [image imageWithRenderingMode:self.renderingMode];
}
@end

%hook SSMainScreenSnapshotter

- (UIImage *)takeScreenshot{
	UIImage *image = %orig;
	if(!isTweakEnabled){
		return image;
	}
	IOSurfaceRef ioSurface = (__bridge IOSurfaceRef)[image performSelector:@selector(ioSurface)];
	
	NSDictionary *pixelBufferAttributes = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
	CVPixelBufferRef pixcelBuffer;
    CVPixelBufferCreateWithIOSurface(NULL, ioSurface, (__bridge CFDictionaryRef _Nullable)(pixelBufferAttributes), &pixcelBuffer);
	
	CGImageRef cgimage;
	VTCreateCGImageFromCVPixelBuffer(pixcelBuffer, nil, &cgimage);

	image = [[UIImage alloc] initWithCGImage:cgimage];
	return [image resizedWithScale:fmax(scale, 0.001)];
}
%end


%hook _SSScreenCaptureResults
- (UIImage *)image{
	UIImage *image = %orig;

	return image;
}
%end


%ctor{
  @autoreleasepool {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL, settingsChanged,
                                    CFSTR(NOTIFY), NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);

	settingsChanged(NULL, NULL, NULL, NULL, NULL);
    %init;
  }
}