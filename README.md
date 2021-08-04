# PostsDemo

Take home project

## How to launch

No special steps needed. Open the `PostDemo.xcodeproj` file, wait until SwiftPM dependencies are resolved, and press "Launch". If you want to test on device for better SwiftUI performance, add Development Team in Signing & change bundle identifier.

## Dependencies:
 - [SwiftUIRefresh](https://github.com/siteline/SwiftUIRefresh) for the native pull-to-refresh, made by my ex. manager & mentor [Loïs](https://github.com/ldiqual)
 - [NukeUI](https://github.com/kean/NukeUI) for remote image loading. I decided not to use `AsyncImage` because it would require the use of beta software (not good). Also opted in to use a third-party solution instead of [my own](https://github.com/dreymonde/Avenues) since it's better suited for SwiftUI.

## Approx. time spent:
 - ~2 hours on API, Models & API unit testing
 - ~1 hour on Main screen
 - ~1 hour on Single post details screen
 - ~2 hours on database
 - ~2 hours on pull-to-refresh
 - ~0.5 hours on error message

## Enabled debug features

To disable debug features, change build configuration to *Release*

 - Every network request has a 2-second delay to better showcase the work of caching / DB layer
 - Navigation bar title displays the current source of data (Memory / Cache / Server)
