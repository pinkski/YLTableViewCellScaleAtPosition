//
//  ViewController.m
//  YLTableViewCellScaleAtPosition
//
//  Created by 张晓岚 on 15/11/5.
//  Copyright (c) 2015年 ThinkMobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (assign, nonatomic) CGRect selectionRect;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) UITableViewCell *selectedCell;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [self.myTableView setZoomScale:3 animated:YES];
//    [self.myTableView zoomToRect:CGRectMake(0, 100, 200, 50) animated:YES];
    
    _selectionRect = CGRectMake(0, 100, 320, 40);
    UIView *selectionView = [[UIView alloc] initWithFrame:_selectionRect];
    selectionView.backgroundColor = [UIColor blueColor];
    selectionView.alpha = 0.3;
    [self.view addSubview:selectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)scaleSelectRect {
    //
    CGRect selectionRectConverted = [self.view convertRect:_selectionRect toView:_contentTableView];
    NSArray *indexPathArray = [_contentTableView indexPathsForRowsInRect:selectionRectConverted];
    
    CGFloat intersectionHeight = 0.0;
    
    for (NSIndexPath *index in indexPathArray) {
        //looping through the closest cells to get the closest one
        UITableViewCell *cell = [_contentTableView cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
        
        if (intersectedRect.size.height>=intersectionHeight) {
            _selectedIndexPath = index;
            _selectedCell = cell;
            intersectionHeight = intersectedRect.size.height;
        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    _selectedCell.textLabel.font = [UIFont systemFontOfSize:30];
    _selectedCell.textLabel.textColor = [UIColor redColor];
    [UIView commitAnimations];
    
    

    
    NSArray *visibleIndexPathArray = [_contentTableView indexPathsForVisibleRows];
    for (NSIndexPath *index in visibleIndexPathArray) {
        //
        if (index != _selectedIndexPath) {
            UITableViewCell *cell = [_contentTableView cellForRowAtIndexPath:index];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
//    NSLog(@"select.row:%lu", (long)_selectedIndexPath.row);
   
    
    
//    if (_selectedIndexPath!=nil) {
//        //As soon as we elected an indexpath we just have to scroll to it
//        [_contentTableView scrollToRowAtIndexPath:_selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        [_contentTableView reloadData];
//    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", (long)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
//        [self scaleSelectRect];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scaleSelectRect];
}

@end
