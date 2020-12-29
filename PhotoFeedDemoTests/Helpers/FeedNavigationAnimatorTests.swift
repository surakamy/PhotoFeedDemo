//
//  FeedNavigationAnimatorTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 24.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedNavigationAnimatorTests: XCTestCase {

    func test_navigationController_hasADelegate() throws {
        XCTAssertNotNil(makeSUT().delegate)
    }

    func test_navigationController_hasAnAnimator() throws {
        let sut = makeSUT()

        let animator = simulateAskForAnimator(sut)

        XCTAssertNotNil(animator)
        XCTAssertNotNil(sut.feedAnimator)
        XCTAssertTrue(sut.feedAnimator === animator)
    }

    func test_navigationController_animatorHasProperAnimationOpertion() throws {
        let sut = makeSUT()

        XCTAssertEqual(sut.feedAnimator.operation, UINavigationController.Operation.none)

        simulateAskForAnimator(sut)

        XCTAssertEqual(sut.feedAnimator.operation, UINavigationController.Operation.push)
    }


    private func makeSUT() -> NavigationController {
        let sut = NavigationController()
        sut.loadViewIfNeeded()
        return sut
    }

    @discardableResult
    private func simulateAskForAnimator(_ nc: UINavigationController, _ operaton: UINavigationController.Operation = .push) -> UIViewControllerAnimatedTransitioning? {
        nc.delegate?.navigationController?(nc, animationControllerFor: operaton, from: UIViewController(), to: UIViewController())
    }

}

private final class FakeUIViewControllerContextTransitioning: NSObject, UIViewControllerContextTransitioning {
    override init() {
        self.containerView = UIView(frame: .zero)
        self.isAnimated = false
        self.isInteractive = false
        self.transitionWasCancelled = false
        self.presentationStyle = .custom
        self.targetTransform = .identity
        super.init()
    }


    var containerView: UIView

    var isAnimated: Bool

    var isInteractive: Bool

    var transitionWasCancelled: Bool

    var presentationStyle: UIModalPresentationStyle

    var targetTransform: CGAffineTransform

    func updateInteractiveTransition(_ percentComplete: CGFloat) {

    }

    func finishInteractiveTransition() {

    }

    func cancelInteractiveTransition() {

    }

    func pauseInteractiveTransition() {

    }

    func completeTransition(_ didComplete: Bool) {
    }

    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        nil
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        nil
    }

    func initialFrame(for vc: UIViewController) -> CGRect {
        .zero
    }

    func finalFrame(for vc: UIViewController) -> CGRect {
        .zero
    }

}
