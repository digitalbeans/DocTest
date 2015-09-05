# DocTest

DocTest is a sample for creating an UIDocument subclass and syncing those documents with iCloud.
If you have it running on two devices and you create or edit a document on one device, and you have the main
table view visible on the second device, the new document or the changes will appear on the first device. 
If you are editing the same document on multiple devices, changes on one device will automatically update on 
other devices.
The document uses UIKeyedArchiver to store the data.
