//
//  DetailCommentCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/8/22.
//
#import "ParseCollege.h"
#import "DetailCommentCell.h"

@implementation DetailCommentCell {
    NSMutableArray<NSString *> *upvotes;
    NSMutableArray<NSString *> *downvotes;
    NSString *commentObjectId;
    PFUser *currentUser;
    Comment *commentFromParse;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setComment:(Comment *)comment {
    self.usernameLabel.text = comment.usernameForDisplaying;
    self.userCommentLabel.text = comment.comment;
    self.counterLabel.text = [[NSString alloc] initWithFormat:@"%d", comment.vote];
    self.userProfileImageView.file = comment.image;
    [self.userProfileImageView loadInBackground];
    self->currentUser = [PFUser currentUser];
    self->commentObjectId = comment.objectId;
    [self setImageBoarderSize];
    [self voteStatusChecker];
    [self getTheCommentFromParse];
}

- (void)getTheCommentFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"objectId" equalTo:self->commentObjectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self->commentFromParse = [comments objectAtIndex:0];
            self->upvotes = self->commentFromParse[@"upvoted"];
            self->downvotes = self->commentFromParse[@"downvotedUsers"];
            [self voteStatusChecker];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapUpvote:(id)sender {
    [self updateVoteInParse:self->commentFromParse forValue:true];
}

- (IBAction)didTapDownVote:(id)sender {
    [self updateVoteInParse:self->commentFromParse forValue:false];
}

- (void)updateVoteInParse:(Comment *)collegeFromParse forValue:(BOOL)upvote {
    if (upvote == true) {
        [self.downvoteHeartButton setImage:[UIImage imageNamed:@"arrow.down.heart.png"]forState:UIControlStateNormal];
        [self.upvoteHeartButton setImage:[UIImage imageNamed:@"arrow.up.heart.fill.png"]forState:UIControlStateNormal];
        [self->upvotes addObject:self->currentUser.username];
        self->commentFromParse[@"upvoted"] = [NSArray arrayWithArray:self->upvotes];
        if ([self->downvotes containsObject:self->currentUser.username]) {
            [self->downvotes removeObject:self->currentUser.username];
            self->commentFromParse[@"downvotedUsers"] = [NSArray arrayWithArray:self->downvotes];
        }
        self->commentFromParse.vote++;
    } else {
        [self.upvoteHeartButton setImage:[UIImage imageNamed:@"arrow.up.heart.png"] forState:UIControlStateNormal];
        [self.downvoteHeartButton setImage:[UIImage imageNamed:@"arrow.down.heart.fill.png"] forState:UIControlStateNormal];
        [self->downvotes addObject:self->currentUser.username];
        self->commentFromParse[@"downvotedUsers"] = [NSArray arrayWithArray:self->downvotes];
        if ([self->upvotes containsObject:self->currentUser.username]) {
            [self->upvotes removeObject:self->currentUser.username];
            self->commentFromParse[@"upvoted"] = [NSArray arrayWithArray:self->upvotes];
        }
        self->commentFromParse.vote--;
    }
    [self->commentFromParse saveInBackground];
    [self counterUpdateForLabel];
}

- (void)counterUpdateForLabel {
    self.counterLabel.text = [[NSString alloc] initWithFormat:@"%d", self->commentFromParse.vote];
}

- (void)voteStatusChecker {
    if ([self->upvotes containsObject:self->currentUser.username]) {
        [self.upvoteHeartButton setImage:[UIImage imageNamed:@"arrow.up.heart.fill.png"] forState:UIControlStateNormal];
    } else if ([self->downvotes containsObject:self->currentUser.username]) {
        [self.downvoteHeartButton setImage:[UIImage imageNamed:@"arrow.down.heart.fill.png"] forState:UIControlStateNormal];
    }
}

- (void)setImageBoarderSize {
    double radius = 1.995;
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height/radius;
    self.userProfileImageView.layer.masksToBounds = YES;
    self.userProfileImageView.layer.borderWidth = 0;
}
@end
