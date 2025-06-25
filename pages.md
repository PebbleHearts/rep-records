Log Screen
  * lists the executed exercises for each selected date
  * shows execute a routine button if empty
  * Add random exercises at the bottom

Exercises Screen
  - Exercises Tab
    * Exercises group list
    * group add button
    * group add bottom sheet
    * add exercise to routine in each routine card
    * group add bottom sheet
  - Routines Tab
    * routines list
    * add button
    * add bottom sheet
    * add exercise to routine in each routine card

Settings Page
  * Theme toggling





Exercises Screen
* It can have two buttons
  - Manage Exercises
  - Manage Routines
* But placing only these buttons in a single page makes the page very blank










how to handle the upsync
- everytime we update or create an entry we will mark the 'synced' field to false.
- Then when the upsync happens we will get all the records which have the value of 'synced' field with false.
- we will be using upsert instead of insert so that the update happens for existing fields.

- we need an id inside the app which is unique. every time before the upsync we need to ask for the upsync id. if the upsync is same, we can just continue the upsync id, but if the upsync id is different. the issue that may be caused is the id that we follow (int). instead if we use a uuiv4 then we can avoid that issue.

how to handle the downsync
if we are using the uuidv4 id then we have no issue in setting the data from server to the client.



flutter version - 
Flutter 3.29.2 • channel stable •
https://github.com/flutter/flutter.git
Framework • revision c236373904 (3 months ago) • 2025-03-13
16:17:06 -0400
Engine • revision 18b71d647a
Tools • Dart 3.7.2 • DevTools 2.42.3