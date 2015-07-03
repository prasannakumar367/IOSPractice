//
//  RemoteImagesViewController.h
//  AsyncImageDemo
//
//  Created by Nick Lockwood on 17/10/2011.
//  Copyright (c) 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesViewController.h"


@interface RemoteImagesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) UITableView *myTable;
@end
