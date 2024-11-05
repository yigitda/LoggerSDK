
import XCTest
@testable import LoggingSDK

final class LoggingSDKTests: XCTestCase {
    func testLogLevelComparison() {
        XCTAssertTrue(LogLevel.debug < LogLevel.info)
        XCTAssertFalse(LogLevel.error < LogLevel.warning)
    }
}

