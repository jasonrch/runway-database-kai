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

    /* This is what is called the weakify/strongify pattern. Blocks maintain strong references to any captured objects, including self, so you can end up with a strong reference cycle, if you are not careful. To avoid strong reference cycles I needed to use weak references. By capturing the weak reference to self, the block won’t maintain a strong relationship to the object. If the pointer is nil, however, then  the methods inside the block won’t get called and so the block won't do what it is supposed to. Creating a strong self in the block will retain 'self' if WeakSelf = self, enabling me to plug in data or execute code or update the UI in the current view controller. This is a great way to avoid retain cycles
     */
    
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
