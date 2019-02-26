# mark
![mark banner](https://firebasestorage.googleapis.com/v0/b/shah-cloud-services.appspot.com/o/29933ad7-a4bb-a18c-7eff-813a6d044790%3C%3D%3D%3Ebanner.png?alt=media&token=c01a4e90-55cf-439b-b18e-047228fe39a7)

## Inspiration
We've all gone hiking and seen geotagging. We've all seen PokemonGo come and leave, disrupting our lives in ways we didn't see coming. We believe that AR's purpose is to merge reality with the digital world, and we feel that creativity is essential to utilizing AR in the best way possible. That's why we decided to create mARk, an app where you can make AR Art Pieces (or ARt as we like to call it) and share them with the world.

## What it does
**mark** allows users to experience art pieces based on their current location. The app loads different marks based on the users location, and lets users see the unique pieces in their area. Through simple motions, the users are able to place spherical nodes anywhere in the world, and send these nodes to be shared with the world forever.
![Mark Demo](https://media.giphy.com/media/oyPNO01tA4Nz49khml/giphy.gif)

## How it's built
Built entirely with Apple's AR Kit and Google's Firebase, this project utilizes ARKit with SceneKit to render the environment. Marks are sent from our application to the database with the press of a button.

![View of code](https://res.cloudinary.com/devpost/image/fetch/s--TwvhTiPt--/c_limit,f_auto,fl_lossy,q_auto:eco,w_900/https://firebasestorage.googleapis.com/v0/b/shah-cloud-services.appspot.com/o/c2fe814d-849c-0383-a6b0-a7363c9856b0%253C%253D%253D%253EScreen%2520Shot%25202019-02-17%2520at%25209.08.25%2520AM.png%3Falt%3Dmedia%26token%3D583a89ee-1901-49cc-9f2e-eaf196eb00cf)
_We used Swift, AR Kit, and Google's Firebase_

## Challenges we ran into
Originally at the start of the hackathon, our team was set on creating an AR app using the Unity platform. We attempted to use technologies on Unity such as Vuforia and Mapbox in order to create an AR camera and to keep track of location. However, after 15 hours of hard work and setting up almost every component of the project including database set up and UI, we failed to make progress towards to the core idea of our project - the ability to stick marks to a geographic location. As a result, we scrapped what we had done on Unity and decided to just use Swift to perform what we needed instead. 

After making the decision to switch to Swift, we encountered many other challenges as well. One main issue was figuring out how we wanted to store our data. In our application, marks were sets of 3D colored spheres which were too large to store into a database. Therefore, we had to spend a long time making design decisions, because we wanted to keep efficiency and scalability in mind to make it easy to scale the product. For example, some troubling decisions included deciding what properties to store for each mark the user creates and within each mark, how the structure of the data should look.

Another big challenge was that the hackathon room itself had no GPS signal. This made testing difficult, since one of the main features we wanted to implement was how a user could only see a mark if the mark is near them. In addition to frequently going outside of the main room to perform tests, we also had to figure out a way such that marks are presented locally so that it is demoable.

![Unity](https://i.imgur.com/3H78K5m.png)
_Unity gave us a hard time before we had to switch to Swift_

## Accomplishments that we're proud of
We're proud of the fact that despite the number of difficulties that we ran into, we didn't give up. We realized that the idea was borderline impossible for us to finish in time with Unity by Saturday evening. Despite the limited time remaining, instead of calling it quits, we completely switched technologies and started on a new application. Two hours later, Ronak managed to put together a prototype despite having no previous experience with AR Kit. We all hopped onto the application and continued from there.

## What we learned
We all learned new technologies. Most of us hadn't worked with augmented reality prior to this hackathon. For those that did, we still treaded with new ground as we went through and implemented augmented reality with three different technologies. Even though we failed with Unity, we all learned quite a lot in order to get a basic application running. Once we switched over to using Xcode, most of us also learned to use Swift for the first time.

We also learned the importance of hacking until the very end. We ran through countless errors with Unity and design problems with Swift. It didn't change the fact that we kept pushing through the process and continued to code.

## What's next for mark
We plan to submit to the app store, fingers crossed it'll be approved within the week.

We also have a plan to monetize the app, modeled heavily after Snapchat's Model. By default, all graffiti will only be shared with your friends (which can be manually added through the app). However, companies can sponsor in app landmarks to appear in certain locations, where we can thus charge them based on time. They can import any sort of 3D STL file to give them more options.

Additionally, any user using the app can share their graffiti with the whole world (for that location) for the following prices

$0.99 -> Public, Accessible for a Week
$1.99 -> Public, Accessible for a Month
$9.99 -> Public, Accessible for a Year

We're excited by this product, and are interested to see where it goes!
