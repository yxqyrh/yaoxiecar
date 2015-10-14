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

#import "MDPhotoAlbumViewController.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MDPhotoAlbumViewController


//////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWith:(id)object {
  if ((self = [self initWithNibName:nil bundle:nil])) {
      self.object = object;
      self.scrubberIsEnabled = YES;
      self.hidesChromeWhenScrolling = NO;
  }
  return self;
}

- (id)initWith:(id)object andImages:(NSArray *)images {
    if ((self = [self initWithNibName:nil bundle:nil])) {
        self.object = object;
        self.images = images;
        self.scrubberIsEnabled = YES;
        self.hidesChromeWhenScrolling = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoAlbumView.zoomingIsEnabled = YES;
    self.photoAlbumView.zoomingAboveOriginalSizeIsEnabled = YES;
//    [self addTapGestureToView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.initialIndex != 0) {
        [self.photoAlbumView moveToPageAtIndex:self.initialIndex animated:NO];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePhoto)];
    NSMutableArray *array = [self.toolbar.items mutableCopy];
    [array addObject:item];
    self.toolbar.items = array;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // hide back button on navigation bar
    self.navigationItem.hidesBackButton = YES;
        UIButton *navigationBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        navigationBarLeftButton.frame = CGRectMake(0, 0, 48, 33);
        [navigationBarLeftButton setBackgroundImage:[UIImage imageNamed:@"navigation_bar_back_button.png"]
                                           forState:UIControlStateNormal];
        [navigationBarLeftButton addTarget:self
                                    action:@selector(backButtonTouchUpInside:)
                          forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:navigationBarLeftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    
    //    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    
    // navigation bar background color
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
    //        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.09 green:0.54 blue:0.86 alpha:1];
    //    } else {
    //        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09 green:0.54 blue:0.86 alpha:1];
    //    }
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // delete navigationbar shadow
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_color.png"] forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)backButtonTouchUpInside:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setChromeVisibility:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadThumbnails {
  for (int ix = 0; ix < [_photoInformation count]; ++ix) {
    NSDictionary* photo = [_photoInformation objectAtIndex:ix];

    NSString* photoIndexKey = [self cacheKeyForPhotoIndex:ix];

    // Don't load the thumbnail if it's already in memory.
    if (![self.thumbnailImageCache containsObjectWithName:photoIndexKey]) {
      NSString* source = [photo objectForKey:@"thumbnailSource"];
      [self requestImageFromSource: source
                         photoSize: NIPhotoScrollViewPhotoSizeThumbnail
                        photoIndex: ix];
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadAlbumInformation {

        if (self.images != nil && self.images.count > 0) {
            
            NSMutableArray* photoInformation = [NSMutableArray arrayWithCapacity:[_images count]];
            for (NSString *imagePath in _images) {
                
                // Gather the high-quality photo information.
                NSString *address = [NSString stringWithFormat:@"%@/%@", IMGURL,imagePath];
                NSURL *url = [NSURL URLWithString:address];
                
                NSString* originalImageSource = url;
                
                // We gather the highest-quality photo's dimensions so that we can size the thumbnails
                // correctly until the high-quality image is downloaded.
                CGSize dimensions = CGSizeMake(0, 0);
                
                NSString* thumbnailImageSource = address;
                
                NSDictionary* prunedPhotoInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 thumbnailImageSource, @"originalSource",
                                                 thumbnailImageSource, @"thumbnailSource",
                                                 [NSValue valueWithCGSize:dimensions], @"dimensions",
                                                 nil];
                [photoInformation addObject:prunedPhotoInfo];
            }
            
            _photoInformation = photoInformation;
        }
        
    

    
    [self loadThumbnails];
    [self.photoAlbumView reloadData];
    [self.photoScrubberView reloadData];
    
    [self refreshChromeState];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
  [super loadView];

  self.photoAlbumView.dataSource = self;
  self.photoScrubberView.dataSource = self;

  // Dribbble is for mockups and designs, so we don't want to allow the photos to be zoomed
  // in and become blurry.
  self.photoAlbumView.zoomingAboveOriginalSizeIsEnabled = NO;

  // This title will be displayed until we get the results back for the album information.
  self.title = NSLocalizedString(@"Loading...", @"Navigation bar title - Loading a photo album");

  [self loadAlbumInformation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
  _photoInformation = nil;

  [super viewDidUnload];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NIPhotoScrubberViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPhotosInScrubberView:(NIPhotoScrubberView *)photoScrubberView {
  return [_photoInformation count];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage *)photoScrubberView: (NIPhotoScrubberView *)photoScrubberView
              thumbnailAtIndex: (NSInteger)thumbnailIndex {
  NSString* photoIndexKey = [self cacheKeyForPhotoIndex: (int)thumbnailIndex];
    
  UIImage* image = [self.thumbnailImageCache objectWithName:photoIndexKey];
  if (nil == image) {
    NSDictionary* photo = [_photoInformation objectAtIndex:thumbnailIndex];
    
    NSString* thumbnailSource = [photo objectForKey:@"thumbnailSource"];
    [self requestImageFromSource: thumbnailSource
                       photoSize: NIPhotoScrollViewPhotoSizeThumbnail
                      photoIndex: (int)thumbnailIndex];
  }
  
  return image;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NIPhotoAlbumScrollViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPagesInPagingScrollView:(NIPhotoAlbumScrollView *)photoScrollView {
  return [_photoInformation count];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage *)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex: (NSInteger)photoIndex
                        photoSize: (NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading: (BOOL *)isLoading
          originalPhotoDimensions: (CGSize *)originalPhotoDimensions {
  UIImage* image = nil;

  NSString* photoIndexKey = [self cacheKeyForPhotoIndex:(int)photoIndex];

  NSDictionary* photo = [_photoInformation objectAtIndex:photoIndex];

  // Let the photo album view know how large the photo will be once it's fully loaded.
  *originalPhotoDimensions = [[photo objectForKey:@"dimensions"] CGSizeValue];

  image = [self.highQualityImageCache objectWithName:photoIndexKey];
  if (nil != image) {
    *photoSize = NIPhotoScrollViewPhotoSizeOriginal;

  } else {
    NSString* source = [photo objectForKey:@"originalSource"];
    [self requestImageFromSource: source
                       photoSize: NIPhotoScrollViewPhotoSizeOriginal
                      photoIndex: (int)photoIndex];

    *isLoading = YES;

    // Try to return the thumbnail image if we can.
    image = [self.thumbnailImageCache objectWithName:photoIndexKey];
    if (nil != image) {
      *photoSize = NIPhotoScrollViewPhotoSizeThumbnail;

    } else {
      // Load the thumbnail as well.
      NSString* thumbnailSource = [photo objectForKey:@"thumbnailSource"];
      [self requestImageFromSource: thumbnailSource
                         photoSize: NIPhotoScrollViewPhotoSizeThumbnail
                        photoIndex: (int)photoIndex];

    }
  }

  return image;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
     stopLoadingPhotoAtIndex: (NSInteger)photoIndex {
  // TODO: Figure out how to implement this with AFNetworking.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<NIPagingScrollViewPage>)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
  return [self.photoAlbumView pagingScrollView:pagingScrollView pageViewForIndex:pageIndex];
}

- (void)savePhoto
{
    NSLog(@"%d", (int)self.photoAlbumView.centerPageIndex);
    UIImage *image = [self.highQualityImageCache objectWithName:[NSString stringWithFormat:@"%d",(int)self.photoAlbumView.centerPageIndex]];
    
    if (image) {
        [self saveImageToPhotos:image];
    } else {
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        hud.removeFromSuperViewOnHide = YES;
//        [self.navigationController.view addSubview:hud];
//        hud.mode = MBProgressHUDModeText;
//        hud.detailsLabelText = NSLocalizedString(@"下载图片中,请稍后", @"下载图片中,请稍后");
//        [hud show:YES];
//        [hud hide:YES afterDelay:0.8];
        
        
        [self.view makeToast:@"下载图片中，请稍后"];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
	UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
	NSString *msg = nil ;
	if(error != NULL){
		msg = NSLocalizedString(@"保存图片失败", @"保存图片失败") ;
	}else{
		msg = NSLocalizedString(@"保存图片成功", @"保存图片成功") ;
	}
    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    hud.removeFromSuperViewOnHide = YES;
//    [self.navigationController.view addSubview:hud];
//    hud.mode = MBProgressHUDModeText;
//    hud.detailsLabelText = msg;
//    [hud show:YES];
//    [hud hide:YES afterDelay:0.8];
    
     [self.view makeToast:@"下载图片中，请稍后"];
}
@end
