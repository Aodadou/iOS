
#import "UIImage+KIAdditions.h"

@implementation UIImage (KIAdditions)

//- (UIImage *)flip:(BOOL)isHorizontal {
//    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    if (((&UIGraphicsBeginImageContextWithOptions)) != NULL) {
//        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//    } else {
//        UIGraphicsBeginImageContext(rect.size);
//    }
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextClipToRect(ctx, rect);
//    if (isHorizontal) {
//        CGContextRotateCTM(ctx, M_PI);
//        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
//    }
//    CGContextDrawImage(ctx, rect, self.CGImage);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

//- (UIImage *)flipVertical {
//    return [self flip:NO];
//}
//
//- (UIImage *)flipHorizontal {
//    return [self flip:YES];
//}

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    } else {
        //UIGraphicsBeginImageContext(size);
    }
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return image;
}


+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



- (UIColor *)colorAtPixel:(CGPoint)point {

    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
//    NSInteger pointX = trunc(point.x);
//    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = self.CGImage;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -point.x, point.y - self.size.height);

    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
