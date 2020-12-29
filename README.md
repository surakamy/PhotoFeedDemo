# PhotoFeedDemo

The general architecture of the app is shown on the diagram and it consists of Network layer, Presentation layer and two concrete UI implementations (UIKit or SwiftUI).

![App layers](https://github.com/surakamy/PhotoFeedDemo/blob/main/Documents/App-Layers.svg)

- UseCase is assembled in Factories which integrate Network layer and concrete UI implementation with help of Composers.
- UseCases follow View -> Interactor -> Presenter unidirectional flow.
- Each screen (View or UIViewController) is separated from others and for navigation are used closures.

An example of how structured and behaves UseCase
![UseCase Example](https://github.com/surakamy/PhotoFeedDemo/blob/main/Documents/FeedUseCase.svg)


### Credits
API for the feed provided by [picsum.photos](https://picsum.photos)
