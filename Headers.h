//
//  Headers.h
//  AssetsUnpacker
//
//  Created by kinda on 29.08.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

@interface SBApplication
- (NSBundle *)bundle;
- (NSString *)displayName;
@end

@interface SBApplicationController
+ (id)sharedInstance;
- (id)allApplications;
- (id)allDisplayIdentifiers;
- (SBApplication *)applicationWithDisplayIdentifier:(id)displayIdentifier;
@end

@interface SpringBoard
- (id)_accessibilityFrontMostApplication;
@end

@interface CUICommonAssetStorage
- (id)allAssetKeys;
- (id)allRenditionNames;
@end

@interface CUIStructuredThemeStore
- (CUICommonAssetStorage *)themeStore;
@end

@interface CUICatalog
- (CUIStructuredThemeStore *)_themeStore;
@end

@interface _UIAssetManager
+ (_UIAssetManager *)assetManagerForBundle:(NSBundle *)bundle;
- (CUICatalog *)_catalog;
- (UIImage *)imageNamed:(NSString *)name;
@end

@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end
