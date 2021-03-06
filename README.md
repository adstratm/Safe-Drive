Created at HackISU 2/24/2017 - 2/26/2017

YouTube video showing the app in action: https://www.youtube.com/watch?v=yy8y49q2h90

Inspiration

Team member Minghao Shan was inspired to create an application to discourage phone use while driving upon learning of the devastating loss of life from unsafe driving habits. The other team members saw this as an opportunity to create a first iOS application using the development tools provided by Apple.

What it does

Safe Drive runs passively in the background on iOS devices running 10.0 or later. Every six seconds or whenever new location data is received, Safe Drive determines the user's speed and checks if the phone is unlocked. If the user is traveling faster than a typical pedestrian or cyclist and is using the device, a local notification is sent to encourage the user to cease use of the phone. Notifications are sent repeatedly to persuade the user to adopt safer driving habits. When the phone becomes locked, or the user's speed decreases below the threshold, notifications stop.

How we built it

Safe Drive is built using Swift 3 and was developed in Xcode 8.

Challenges we ran into

The greatest challenge of this project was managing a callback function on a listener add call. We wanted to manipulate a shared boolean value with two listeners, one for the phone becoming locked and another for the phone's lock status changing. This behavior is not specifically allowed, so a workaround involving casting self to a void pointer and then returning it to its original state after the callback function has finished execution. Some smaller issues we faced included the growing expanse between our original idea of the implementation and the working version, and also changing syntax rules for Swift.

Accomplishments that we're proud of

The application runs without serious errors, correctly gathers information about a user's speed, uses this information to determine if a notification should be sent, and remains flexible enough to add further functionalities. This was the first iOS application experience for three of our group members, and was the first experience with Apple ecosystem hardware for two of our members. Despite this, we were able to create a working application with a basic GUI.

What we learned

Documentation is extremely important in the development process. Collaboration can be a powerful tool in the development process. Three team members were not familiar with Git and Github prior to the hackathon. We all gained an appreciation for helpful online commenters.

What's next for Safe Drive

We would like to add Motion Kit functionality to allow users to travel by means other than automobile without receiving any notifications. This addition would also reduce the need to rely as heavily on GPS, and could thus save device battery life. Adding more cacophonic sounds to the notifications could further motivate users to cease use while driving. We would also consider adding password protection and scheduling features to the application to allow parental or institutional control of the application's use.
