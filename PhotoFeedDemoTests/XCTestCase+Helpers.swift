//
//  XCTestCase+Helpers.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 22.12.2020.
//

import XCTest

extension XCTestCase {
    func assertNoMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
      addTeardownBlock { [weak instance] in
        XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
      }
    }
}

