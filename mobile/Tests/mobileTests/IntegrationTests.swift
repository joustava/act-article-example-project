import XCTest
@testable import mobile

final class IntegrationTests: XCTestCase {

    var greetingServiceClient: GreetingServiceClient?

    override func setUp() {
        super.setUp()

        greetingServiceClient = GreetingServiceClient(baseUrl: Config.baseUrlPactStub)
    }

    func testExampleIntegration() {
        let expectation = self.expectation(description: "greeting client receives response")

        self.greetingServiceClient!.getGreeting { result in
            switch result {
            case .success(let greeting): 
                print(greeting)
                
                XCTAssertEqual(greeting.message, "Mars!")
                expectation.fulfill()
            case .failure(let error): 
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
