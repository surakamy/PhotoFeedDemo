//
//  WeakRef.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 22.12.2020.
//

import Foundation

public final class WeakRef<T: AnyObject> {

    private(set) public weak var object: T?

    public init(_ object: T) {
        self.object = object
    }
}


// I need a second WeakRef to switch between two conditional conformances for SwitUI vs UIKit. The language does not support overlaping confomances. It can be solved by spitting each implementation in a separate module. But it is out of the scope for this project.
public final class Weak2Ref<T: AnyObject> {

    private(set) public weak var object: T?

    public init(_ object: T) {
        self.object = object
    }
}
