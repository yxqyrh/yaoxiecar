//
// Copyright 2011 Jeff Verkoeyen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NetworkPhotoAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#ifdef DEBUG
@interface NetworkPhotoAlbumViewController()
@end
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NetworkPhotoAlbumViewController

@synthesize highQualityImageCache = _highQualityImageCache;
@synthesize thumbnailImageCache = _thumbnailImageCache;
@synthesize queue = _queue;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)shutdown_NetworkPhotoAlbumViewController {
  [_queue cancelAllOperations];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  [self shutdown_NetworkPhotoAlbumViewController];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)cacheKeyForPhotoIndex:(int)photoIndex {
  return [NSString stringWithFormat:@"%d", photoIndex];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (int)identifierWithPhotoSize:(NIPhotoScrollViewPhotoSize)photoSize
                          photoIndex:(int)photoIndex {
  BOOL isThumbnail = (NIPhotoScrollViewPhotoSizeThumbnail == photoSize);
  int identifier = isThumbnail ? -(photoIndex + 1) : photoIndex;
  return identifier;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)identifierKeyFromIdentifier:(int)identifier {
  return [NSNumber numberWithInt:identifier];
}

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestImageFromSource:(NSString *)source
                     photoSize:(NIPhotoScrollViewPhotoSize)photoSize
                    photoIndex:(int)photoIndex {
  BOOL isThumbnail = (NIPhotoScrollViewPhotoSizeThumbnail == photoSize);
  int identifier = [self identifierWithPhotoSize:photoSize photoIndex:photoIndex];
  id identifierKey = [self identifierKeyFromIdentifier:identifier];

  // Avoid duplicating requests.
  if ([_activeRequests containsObject:identifierKey]) {
    return;
  }

  NSURL* url = [NSURL URLWithString:source];
    //改https为http
    if([[url scheme] isEqualToString:@"https"]) {
        NSString *urlStr = [url absoluteString];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
        url = [[NSURL alloc] initWithString:urlStr];
    }

  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  request.timeoutInterval = 30;
  
    
    SDWebImageDownloaderOperation* readOp =
    [[SDWebImageDownloaderOperation alloc] initWithRequest:request options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished){
        
        // If you decide to move this code around then ensure that this method is called from
        // the main thread. Calling it from any other thread will have undefined results.
        [self.photoAlbumView didLoadPhoto: image
                                  atIndex: photoIndex
                                photoSize: photoSize];
        
        if (isThumbnail) {
            [self.thumbnailImageCache storeObject:image withName:[NSString stringWithFormat:@"%d", photoIndex]];
            [self.photoScrubberView didLoadThumbnail:image atIndex:photoIndex];
        } else {
            [self.highQualityImageCache storeObject:image withName:[NSString stringWithFormat:@"%d", photoIndex]];
        }
        
        [_activeRequests removeObject:identifierKey];
        
    } cancelled:^{}];
    
    // Set the operation priority level.
    
    if (NIPhotoScrollViewPhotoSizeThumbnail == photoSize) {
        // Thumbnail images should be lower priority than full-size images.
        [readOp setQueuePriority:NSOperationQueuePriorityLow];
        
    } else {
        [readOp setQueuePriority:NSOperationQueuePriorityNormal];
    }
    
    // Start the operation.
    [_activeRequests addObject:identifierKey];
    [_queue addOperation:readOp];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
  [super loadView];

  _activeRequests = [[NSMutableSet alloc] init];

  _highQualityImageCache = [[NIImageMemoryCache alloc] init];
  _thumbnailImageCache = [[NIImageMemoryCache alloc] init];

  [_highQualityImageCache setMaxNumberOfPixels:10240L*10240L*6L];
  [_thumbnailImageCache setMaxNumberOfPixelsUnderStress:10240L*10240L*6L];

  _queue = [[NSOperationQueue alloc] init];
  [_queue setMaxConcurrentOperationCount:5];

  // Set the default loading image.
  self.photoAlbumView.loadingImage = [UIImage imageWithContentsOfFile:
                                      NIPathForBundleResource(nil, @"NimbusPhotos.bundle/gfx/default.png")];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
  [self shutdown_NetworkPhotoAlbumViewController];

  [super viewDidUnload];
}


@end
