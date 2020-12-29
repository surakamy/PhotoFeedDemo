//
//  LayoutsTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 27.12.2020.
//

import XCTest
import PhotoFeedDemo

class LayoutsTests: XCTestCase {
    func test_foldsAt4With1Element() throws {
        let result = fold([1], at: 4, max: 4)
        XCTAssertEqual(result, [[1]])
    }

    func test_foldAt4With2Elements() throws {
        let result = fold([1, 2], at: 4, max: 4)
        XCTAssertEqual(result, [[1], [2]])
    }

    func test_foldAt4With3Elements() throws {
        let result = fold([1, 2, 3], at: 4, max: 4)
        XCTAssertEqual(result, [[1], [2], [3]])
    }

    func test_foldAt4With4Elements() throws {
        let result = fold([1, 2, 3, 4], at: 4, max: 4)
        XCTAssertEqual(result, [[1], [2], [3], [4]])
    }

    func test_foldAt4With5Elements() throws {
        let result = fold([1, 2, 3, 4, 5], at: 4, max: 4)
        XCTAssertEqual(result, [[1], [2], [3], [4, 5]])
    }

    func test_foldAt4With7Elements() throws {
        let result = fold([1, 2, 3, 4, 5, 6, 7], at: 4, max: 4)
        XCTAssertEqual(result, [[1], [2], [3], [4, 5, 6, 7]])
    }

    func test_foldAt4With8Elements() throws {
        let result = fold([1, 2, 3, 4, 5, 6, 7, 8], at: 4, max: 4)
        XCTAssertEqual(result, [[1], [2], [3], [4, 5, 6, 7], [8]])
    }

    func test_foldAt4With15Elements() throws {
        let result = fold([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], at: 4, max: 4)
        XCTAssertEqual(result, [[1], [2], [3], [4, 5, 6, 7], [8], [9], [10], [11, 12, 13, 14], [15]])
    }

    func test_foldAt2_with4Elements() throws {
        let result = fold([1, 2, 3, 4], at: 2, max: 2)
        XCTAssertEqual(result, [[1], [2, 3], [4]])
    }
}
