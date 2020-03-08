import XCTest
import PactConsumerSwift
@testable import mobile

final class ContractTests: XCTestCase {

    var greetingMockService: MockService?
    var greetingServiceClient: GreetingServiceClient?

    override func setUp() {
        super.setUp()

        greetingMockService = MockService(provider: "Greeting Provider", consumer: "Greeting Service Client")
        greetingServiceClient = GreetingServiceClient(baseUrl: Config.baseUrlPactMock)
    }

    func testGreetingResponse() {
       // Expected.
        greetingMockService!
            .given("A greeting endpoint exists")
            .uponReceiving("A request for a greeting")
            .withRequest(method: .GET, path: "/hello")
            .willRespondWith(
                status: 200,
                headers: [ "Content-Type": "application/json"],
                body: [ "message": Matcher.somethingLike("Mars!") ]
            )

        // Run the test
        greetingMockService!.run(timeout: 5) { (testComplete) -> Void in
            self.greetingServiceClient!.getGreeting { result in
                switch result {
                case .success(let greeting): 
                    XCTAssertEqual(greeting.message, "Mars!")
                    testComplete()
                case .failure(let error): 
                    XCTFail(error.localizedDescription)
                    testComplete()
                }
            }
        }
    }
}