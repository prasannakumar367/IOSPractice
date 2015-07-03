//
//  RemoteImagesViewController.m
//  AsyncImageDemo
//
//  Created by Nick Lockwood on 17/10/2011.
//  Copyright (c) 2011 Charcoal Design. All rights reserved.
//

#import "RemoteImagesViewController.h"
#import "ImageViewController.h"
#import "AsyncImageView.h"

@implementation RemoteImagesViewController
@synthesize imageURLs;
@synthesize myTable;



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTable=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    
    
    //get image URLs
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Images" ofType:@"plist"];
    NSDictionary *imagePaths = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //remote image URLs
    NSMutableArray *URLs = [NSMutableArray array];
    for (NSString *path in imagePaths[@"Remote"])
    {
        NSURL *URL = [NSURL URLWithString:path];
        if (URL)
        {
            [URLs addObject:URL];
        }
        else
        {
            NSLog(@"'%@' is not a valid URL", path);
        }
    }
    self.imageURLs = URLs;
    
    
   
  
    
}
- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section
{
    return (NSInteger)[self.imageURLs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        //create new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //common settings
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        cell.imageView.clipsToBounds = YES;
    }
    else
    {
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imageView];
    }
    
    //set placeholder image or cell won't update when image is loaded
    cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    
    //load the image
    cell.imageView.imageURL = self.imageURLs[(NSUInteger)indexPath.row];
    
    //display image path
    cell.textLabel.text = [[(NSURL *)self.imageURLs[(NSUInteger)indexPath.row] path] lastPathComponent];
    
    return cell;
}

- (void)tableView:(__unused UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ImageViewController *viewController = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    [viewController view]; // load view
    viewController.imageView.imageURL = self.imageURLs[(NSUInteger)indexPath.row];
    viewController.title = [[(NSURL *)self.imageURLs[(NSUInteger)indexPath.row] path] lastPathComponent];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
