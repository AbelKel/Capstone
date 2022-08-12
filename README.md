Find My College Project - README Template
===

# Find My College

## Link to Demo Videos 
https://drive.google.com/drive/folders/11nW_6yqP6qwUC8jPuFeGK7R7hAiMmL2j?usp=sharing

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description

One of the reasons I found this project appealing is that the college application process can often be complicated and finding a good fit college can be challenging. The app aims to help high school juniors and seniors easily find a good fit college. I aim to use CollegeAI API, Google Maps, and databases such as JSON files. One of the core features of the project is the student to college matching process. This feature aims to minimize the number of hours students spend looking for a college that fits their personality and academic needs or aspirations.

Find My College is a college review and matching app for students applying to colleges. Users who sign up on the app have the ability to like, comment, match with colleges. Additionally, they will be able to get directions to a college, go to websites, read news about the colleges, and see other users that have similar likes to them.

In the first week of the start of the project, I plan on implementing the sign up page/ login with Facebook page, the opening survey, and integration of the APIs and databases.

### App Evaluation
- **Category:** Social/Communication
- **Mobile:** It is a mobile app that students can use to find a good fit college. They can use it to search, view details, and read about colleges.
- **Story:** The app is aimed at making the college search eaiser for students by narrowing down the list of colleges they have to look at. 
- **Market:** Students applying to college 
- **Habit:**  One time/Seasonal Use. The usual college application season is from August until the end of January. This is the time that the app expects a large number of users.
- **Scope:** It is aimed at students that are high school seniors that are applying to college. However, anyone applying to college can use the app.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
 * User can login using Facebook account. FB logged in users will be able to view and search for colleges. **[Completed]**
 * User can search for a college **[Completed]**
 * User can like/save a college **[Completed]**
 * User can comment under a specific college **[Completed]**
 * Filter college by location **[Completed]**
 * Fading in cell animation for scrolling through the home screen **[Completed]**
 * Users can double tap on a college image in details view to read a londer description of the college **[Completed]**
 * User can view colleges based on academic rigor **[Completed]**
 * User can see the ranks of colleges in top 10, top 20, etc using segmented controlls from home view (from segment 1 upto 10 each segment containing 20 colleges (200 in total)) **[Completed]**
 * User can fill out survey of college preferences to match with colleges. The colleges that the user is matched with are displayed in the account view controller or profile page **[Completed]**
 * User's input in the search bar is autocorrected and autocompleted to make the process of searching for a college easier. The autocorrect method uses coordintes of the keys on the keyboard to calculate distance and find the correct word to autocomplete and autocorrect the user's input in the search bar **[Completed]**
 * Making Asynchronous group API calls using Grand Central Dispatch(GCD) to receive colleges from the API based on the users input in the survey. This helps with having a faster matching process by allowing the API to run on different background threads and return to the main thread later on to update the UI **[Completed]**
 
**Optional Nice-to-have Stories**

* Find links to different colleges’ websites **[Completed]**
* Users can add friends who have simlar liked colleges to their liked colleges **[Completed]**
* Translation into 10 different languages. The app automatically refreshes the language as the user is chaning views. There is no need to restart the application after changing the language **[Completed]**
* User can upvote or downvote a comment from the comment section **[Completed]**
* User can follow a specific college for news or any updates (News API)/Recommended News **[Completed]**
* Get directions to a college **[Completed]**


### 2. Screen Archetypes

* Screen Archetypes
  * Login screen
  * User can login with their Facebook account
* Stream
  * User can view a feed of photos for a specific college
  * User can press the like button under a college name to like it
* Creation
   * User can make a comment 
* Search
   * Users can search for a college using a specific keyword or phrase


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home tab
* Search tab
* Favourites & likes tab 
* News tab 
* Profile tab

**Flow Navigation** (Screen to Screen)

* Home view
   * Details view
* Search view
  * Details view 
* Favourites and likes 
   * Details view 
* News view 
  * News details view 
* Profile view 
  * Settings 
  * About 

## Wireframes
![IMG_0020](https://user-images.githubusercontent.com/96321082/176711245-ef9920ea-266f-45b0-bc63-cff640cc7ee6.jpg)

![IMG_0022](https://user-images.githubusercontent.com/96321082/176711317-fd261023-f6e8-4144-a8ac-acce6737b299.jpg)

##Home Screen with rigor button selected
![IMG_0525](https://user-images.githubusercontent.com/96321082/184261518-aa01855f-4996-4a12-a843-488393788044.PNG)
##Home Screen with location button selected
![IMG_0538](https://user-images.githubusercontent.com/96321082/184261618-c427be9a-933d-4c02-9e8c-25810175e215.PNG)
##Likes screen
![IMG_0526](https://user-images.githubusercontent.com/96321082/184261644-daf5c378-5bf7-47dc-8b78-a1aed7a01405.PNG)
##News Section
![IMG_0527](https://user-images.githubusercontent.com/96321082/184261675-1f71c90f-3d45-414b-b156-d8dfb591b50f.PNG)
##Profile Section 
![IMG_0528](https://user-images.githubusercontent.com/96321082/184261691-7eb6cff8-b199-447f-bfd2-f19472565c61.PNG)
##Settings section
![IMG_0529](https://user-images.githubusercontent.com/96321082/184261724-18726a5d-f3bb-44c1-b1fd-b5e0e6e661bd.PNG)
##Translation 
![IMG_0530](https://user-images.githubusercontent.com/96321082/184261742-75aa2e3c-dbfd-42d7-aeb5-4d0bc5fcbe88.PNG)
##About page 
![IMG_0531](https://user-images.githubusercontent.com/96321082/184261754-febb8e46-ff18-4395-8260-c590740a17f1.PNG)
##Suggested Friends
![IMG_0532](https://user-images.githubusercontent.com/96321082/184261772-dab671e5-48d2-4201-9200-e183d980c997.PNG)
##News Details View 
![IMG_0533](https://user-images.githubusercontent.com/96321082/184261799-e11f9d64-a892-425a-aecb-8ac1effbfe60.PNG)
##College details view
![IMG_0534](https://user-images.githubusercontent.com/96321082/184261827-93843e65-5e6f-42cc-80df-f9fa0f796d30.PNG)
##Redirected to news from a college 
![IMG_0535](https://user-images.githubusercontent.com/96321082/184261866-732f3478-a9ca-4c0d-9946-dca339af469d.PNG)
##Comment upvotes and downvotes 
![IMG_0536](https://user-images.githubusercontent.com/96321082/184261896-2367085a-5fe2-43f9-a084-a43204155c32.PNG)
##Maps from colleges detail view
![IMG_0537](https://user-images.githubusercontent.com/96321082/184261929-77b592ee-5ac9-4a9e-a1e2-7138fb45f29b.PNG)
##Suggested Friends
![IMG_0540](https://user-images.githubusercontent.com/96321082/184262037-ccc05817-791a-4768-b73c-105a6290cede.PNG)
![IMG_0541](https://user-images.githubusercontent.com/96321082/184262039-2b9bffcc-8e10-4aae-8bfb-4fed4cbdda5c.PNG)

## Week 1: 
  * Sign up page that that include a field for a username, password, age, high scool name 
  * Implementing login page afterwards  
  * API testing 
* How I intend to use the APIs in the first week 
  * Filtering colleges depending on students’ answers in the initial survey 
  * Create a details page for the matched colleges 
  * Add a settings page for the user to adjust location, answers to their initial survey
## Week 2: 
* 5 question survey to match users with colleges 
* Create a home page with filters such as: 
  * Academic rigor 
  * Proximity to current location 
* Search for a college using a keyword
* Like a college 
* Commenting under a specific college
* Ambiguous Problem: Making Async API calls 
## Week 3:
* Ambiguous Problem: Autocomplete and Autocorrect 
* Adding the external library DZNEmptyDataSet for visual polish
* Double tap on a college's image in details view to read a longer description 
* Implement fading in animaiton for cells loading in the home screen
* A tab/section for the user’s liked colleges 
* Being able to go through different colleges using segment control in the home screen
## Week 4: 
* Go to a college's website 
* User follow a specific college for news or any updates/relevant news and updates based on liked colleges
* Find links to different colleges’ websites
* User can search for a college using a keyword in addition to searching by name
## Week 5: 
* Users can change the language to 10 different languages
* Working on UI 
* Get directions to a college using google maps 
* User can add friends that have similar liked colleges to theirs. Basically the suggested friends section of the app. After adding/following the users, they can see the user's matched colleges.
## Week 6: 
* Upvoting and downvoting a comment made by users
* Fixed logging out of facebook account within the app. Users can now login and view colleges with their facebook account.
* Error handilng for when translation packages are not downloaded successfully
* Code clean up
## Week 7: 
* Presentations


## Schema 
##Relations between comments, users, matches, and likes
![CamScanner 07-25-2022 09 32n_1 3](https://user-images.githubusercontent.com/96321082/184262059-e585b8aa-9dd0-4af5-bc19-5830ba2be09b.jpg)
### Models

### View Data Model
#### College
   
   | Property      | Type        | Description |
   | ------------- | ----------- | ------------|
   | name  | String      | name of the college |
   | comments      | Dictionary  | comments made by the user under a college|  
   | image         | String      | link to the college's photo| 
   | details       | String      | contains a short description about the college|
   | website       | String      | link to the college's website |
   | longtuide     | String      | longitudnal location of the college |
   | latitude      | String      | latitudinal location of the college |
   | rigor score   | Double      | the score give to the college by the API|
   | distance      | Double      | the college's distance from the user|
 
#### CollegeNews 

    | Property       | Type     | Description |
    | -------------  | -------- | ------------|
    | title          | String   | title of the news article |
    | newsDescription| String   | description of the news |
    | imageUrl       | String   | url to the image presented on the cover of the artice |
    | url            | String   | url to the news article |
    | content        | String   | a longer description of the news article |
    | articleAuthorName | String | name of the author of the article |
    | publicationDate | String | date the artilce was published on |
    
### Data Model (Parse)
#### Parse User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | username      | String   | username chosen by user during signup |
   | image         | File     | image that user uploads for profile picture|
   | email         | String   | email used by the user during signup |
   | likes         | Relation(college)| all colleges that a user has liked |
   | mathces       | Relation(college)|all colleges that a user has been matched with |
   | newLanguage    | String      | user's picked language |
   | age            | String    | is the age of the user that is recorded when the user signs up |
   | high school    | String   | it is the name of the user's high school |
   
#### Parse College Object (Stored on parse for the like view)

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | author        | pointer  | it points to the user that uploaded the college to parse |
   | name          | String   | name of the college |
   | city          | String   | city where the college college is based |
   | website       | String   | website link of the college|
   | details       | String   | contains a short description about the college |
   | longDetails   | String   | a long description of the college |
   | longtuide     | double   | longitudinal location of the college |
   | latitude      | double   | latitudinal location of the college |
   | rigor score   | Double      | the score give to the college by the API |
   | distance      | Double      | the college's distance from the user |
   
###Comments

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | comment       | String   | comment made by the user| 
   | author        | Pointer  | points to the user who made the comment|
   | college       | String   | name of the college|
   | profile image | file     | profile image of the user|
   | username      | string   | username displayed in comment cell|
   | votes        | number/integer| is the comments total upvotes + downvotes|
   | downvotes     | array | contains all the username of all the user's that downvoted the comment|
   | upvotes       | array | contains all the username of all the user's that upvoted the comment|
  
### Networking
* Login:
  * making use of parse for the login screen
* Homescreen: 
  * (Read/Get) for all the colleges that match the users inputs 
  * (Read/Get) Like a college
  * (Create/Post) a comment about a college
* Search: 
  * (Read/Get) a college based on a key word
* News & updates: 
  * (Read/Get) see news about a liked college 

* Login requesst through parse: 

(void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
        }
    }];
}

* Sign up through parse: 
(void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
        }
    }];
 }
* Getting information for a specific college **endpoint** -  /v1/api/college/info
* Autocomplete for college search **endpoint** - /v1/api/autocomplete/colleges
* Parameter for getting information such as in state tuition, and student to faculty ratio.



