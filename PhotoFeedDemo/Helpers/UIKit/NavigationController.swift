//
//  NavigationController.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 22.12.2020.
//

import UIKit

class NavigationController: UINavigationController {
    var feedAnimator = FeedNavigationAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        feedAnimator.operation = operation
        feedAnimator.navigationController = self
        return feedAnimator
    }
}


final class FeedNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationController.Operation = .none

    weak var storedContext: UIViewControllerContextTransitioning?
    weak var navigationController: NavigationController?

    var storedOriginFrame: CGRect? = nil

    var transitionDuration: TimeInterval =  0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            pushAnimation(using: transitionContext)
        case .pop:
            popAnimation(using: transitionContext)
        default:
            break
        }
    }

    func pushAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let from = transitionContext.viewController(forKey: .from) as? FeedToFeedItemTransitioning,
            let to = transitionContext.viewController(forKey: .to),
            let fromCellFrame = from.fromWindowFrame
        else {
            transitionContext.completeTransition(false)
            return
        }


        storedContext = transitionContext
        transitionContext.containerView.addSubview(to.view)
        storedOriginFrame = fromCellFrame
        to.view.frame = fromCellFrame

        let animator = UIViewPropertyAnimator(duration:transitionDuration, curve: .linear) {
            to.view.frame = transitionContext.finalFrame(for: to)
        }

        animator.addCompletion { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        animator.startAnimation()
    }

    func popAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let toCellFrame = self.storedOriginFrame
        else {
            transitionContext.completeTransition(false)
            return
        }

        storedContext = transitionContext

        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)


        let animator = UIViewPropertyAnimator(duration:transitionDuration, curve: .linear) {
            fromView.frame = toCellFrame
        }

        animator.addCompletion { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        animator.startAnimation()
    }
}

