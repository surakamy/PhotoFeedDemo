//
//  MainQueueDispatchDecorator.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 18.12.2020.
//

import Foundation

public final class MainQueueDispatchDecorator<T> {

  private(set) public var decoratee: T

  public init(decoratee: T) {
    self.decoratee = decoratee
  }

  public func dispatchOnMain(completion: @escaping () -> Void) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async(execute: completion)
    }

    completion()
  }
}
