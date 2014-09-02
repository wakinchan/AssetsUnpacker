//
//  Tweak.xm
//  AssetsUnpacker
//
//  Created by kinda on 29.08.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

%config(generator=internal)

#import <substrate.h>
#import <libactivator/libactivator.h>
#import "Headers.h"

UIKIT_EXTERN UIApplication* UIApp;

#define DIRECTORY @"/var/mobile/Assets/"

@interface AssetsUnpacker : NSObject <LAListener> {
}
@end

static AssetsUnpacker *unpacker = nil;

@implementation AssetsUnpacker
+ (void)load
{
    unpacker = [[self alloc] init];
    [unpacker register];
}

- (void)register
{
    if ([LASharedActivator isRunningInsideSpringBoard]) {
        [LASharedActivator registerListener:unpacker forName:@"com.kindadev.activator.assetsunpacker"];
    }
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName
{
    SBApplication *app = [(SpringBoard *)UIApp _accessibilityFrontMostApplication];
    _UIAssetManager *manager = [%c(_UIAssetManager) assetManagerForBundle:[app bundle]];
    NSArray *allRenditionNames = [[[[manager _catalog] _themeStore] themeStore] allRenditionNames];
    if (!allRenditionNames) {
        [[[UIAlertView alloc] initWithTitle:@"Faild :(" message:[NSString stringWithFormat:@"Assets.car doesn't exist in %@.app.", [app displayName]] delegate:nil cancelButtonTitle:@"Yep!" otherButtonTitles:nil] show];
        return;
    }
    for (NSString *name in allRenditionNames) {
        UIImage *image = [manager imageNamed:name];
        NSData *data = UIImagePNGRepresentation(image);

        NSString *dir = [DIRECTORY stringByAppendingPathComponent:[app displayName]];
        NSString *file = [dir stringByAppendingPathComponent:[name stringByAppendingString:@".png"]];

        NSError *error = nil;
        BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
        if (!created) {
            NSLog( @"createDirectoryAtPath:... failed with error: %@", error );
        }

        BOOL success = [data writeToURL:[NSURL fileURLWithPath:file]
                                options:NSDataWritingAtomic
                                  error:&error];
        if (!success) {
            NSLog( @"doesn't overwrite file:... %@", file );
        }
    }
    [[[UIAlertView alloc] initWithTitle:@"Successfully ;P" message:[NSString stringWithFormat:@"output to decompress data in /var/mobile/Assets/%@.", [app displayName]] delegate:nil cancelButtonTitle:@"Yep!" otherButtonTitles:nil] show];
    [event setHandled:YES]; 
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
    return @"AssetsUnpacker";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
    return @"Unpack Assets.car by Activator action.";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName
{
    return @[@"application"];
}

- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
    return [UIImage _applicationIconImageForBundleIdentifier:@"com.apple.Preferences" format:0 scale:[UIScreen mainScreen].scale];
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
    return [UIImage _applicationIconImageForBundleIdentifier:@"com.apple.Preferences" format:0 scale:[UIScreen mainScreen].scale];
}
@end

