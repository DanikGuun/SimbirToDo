
import XCTest
@testable import SimbirToDo

final class ComparableExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testClamp() throws {
        
        let num = 10
        XCTAssertEqual(num.clamp(to: 0...3), 3)
        XCTAssertEqual(num.clamp(to: 15...20), 15)
        XCTAssertEqual(num.clamp(to: 5...15), 10)
        XCTAssertEqual(num.clamp(to: 10...10), 10)
        
    }

}
