// GreetingConsumer.swift
import Foundation

/// Simple config struct to set the base url on our client.
struct Config {
    static let baseUrlPactMock = URL(string: "http://localhost:1234")
    static let baseUrlPactStub = URL(string: "http://localhost:8083")
    static let baseUrlServer = URL(string: "http://localhost:8080")
}

/// The response body.
struct Greeting: Codable {
    let message: String
}

/// HTTP Client
class GreetingServiceClient {
    
    let baseUrl: URL!

    init(baseUrl: URL!) {
        self.baseUrl = baseUrl
    }

    func getGreeting(handler: @escaping (Result<Greeting, Error>) -> Void) {

        let resource = self.baseUrl.appendingPathComponent("hello")

        URLSession.shared.dataTask(with: resource) { (result) in
            switch result {
            case .success(_, let data):
                // Handle Data and Response
                do {
                    let greeting: Greeting = try JSONDecoder().decode(Greeting.self, from: data)
                    handler(.success(greeting))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                // Handle Error
                handler(.failure(error))
            }
        }.resume()

    }
}

/// An extension to `URLSession`, this is not really relevant to pact but makes our client code a little cleaner.
extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}