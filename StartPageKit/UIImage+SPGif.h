//
//  UIImage+SPGif.h
//  StartPageAdvertisingDemo
//
//  Created by weiguang on 2019/3/20.
//  Copyright © 2019 duia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SPGif)

+ (UIImage *)sp_setAnimatedGIFWithGifName:(NSString *)name;

+ (UIImage *)sp_setAnimatedGIFWithData:(NSData *)data;

+ (float)sp_setFrameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source;

@end

NS_ASSUME_NONNULL_END
