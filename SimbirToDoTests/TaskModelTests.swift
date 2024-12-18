
import XCTest
@testable import SimbirToDo

final class SimbirToDoTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testTaskSimilary() throws {
        
        let startDate = Date()
        let id = UUID()
        
        //Просто одинаковые задания
        let task1 = TaskInfo(id: id, name: "task1", taskDescription: "description", dateInterval: DateInterval(start: startDate, duration: 0), color: .green)
        let task2 = TaskInfo(id: id, name: "task1", taskDescription: "description", dateInterval: DateInterval(start: startDate, duration: 0), color: .green)
        XCTAssertTrue(task1.isSimilaryTo(task2))
        
        //задания с отличной инф-ей
        let task3 = TaskInfo(name: "task1", taskDescription: "", dateInterval: DateInterval(start: startDate, duration: 0), color: .green)
        XCTAssertFalse(task1.isSimilaryTo(task3))
        
        //одинаковая информация, но разные айди
        let task4 = TaskInfo(id: UUID(), name: "task1", taskDescription: "description", dateInterval: DateInterval(start: startDate, duration: 0), color: .green)
        XCTAssertTrue(task1.isSimilaryTo(task4))
        
    }
    
}
