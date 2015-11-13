//
//  DesignerTableViewController.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/9/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import "DesignerTableViewController.h"
#import "ViewController.h"

@interface DesignerTableViewController ()

@end

@implementation DesignerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    
    __weak typeof(self) weakSelf = self;
    [[RTRDataWrapper sharedDressManager] fetchmeDesignersAndAccessories:^(NSArray *designerArray, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;

        if (!error) {
            strongSelf.designerLists = designerArray;
            [strongSelf.tableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.designerLists.count > 0 ? self.designerLists.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DesignerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell prepareForReuse];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.designerLists objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    if ([segue.identifier isEqualToString:@"DressSegue"]) {
        
        ViewController *destViewController = (ViewController *) segue.destinationViewController;
        NSIndexPath *designerIndexPath = [self.tableView indexPathForSelectedRow];
        destViewController.designerName = self.designerLists[designerIndexPath.row];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
