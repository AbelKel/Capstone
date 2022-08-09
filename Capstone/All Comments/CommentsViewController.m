//
//  CommentsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/8/22.
//
#import "DetailCommentCell.h"
#import "CommentsViewController.h"

@interface CommentsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailComment"];
    Comment *comment = self.comments[indexPath.row];
    cell.comment = comment;
    return cell;
}
@end