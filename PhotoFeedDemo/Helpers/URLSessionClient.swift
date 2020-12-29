//
//  URLSessionClient.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import Foundation

public enum HTTPClientError: Error {
    case connectivity
}


public protocol HTTPClientTask {
    func resume()
    func cancel()
}

public protocol HTTPClient: class {
    typealias Response = Result<(data: Data, http: HTTPURLResponse), Error>

    @discardableResult
    func dispatch(_ request: URLRequest, then handler: @escaping (Response) -> Void) -> HTTPClientTask
}

extension URLSessionDataTask: HTTPClientTask {}

public protocol ClientSession {
    func data(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPClientTask
}

extension URLSession: ClientSession {
    public func data(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPClientTask {
        dataTask(with: request, completionHandler: completionHandler)
    }
}

public final class URLSessionClient: HTTPClient {

    private struct UnexpectedResponse: Error { }

    let session: ClientSession

    public init(session: ClientSession) {
        self.session = session
    }


    @discardableResult
    public func dispatch(_ request: URLRequest, then handler: @escaping (Response) -> Void) -> HTTPClientTask {
        let task = session.data(with: request) {
            (data, response, error)  in

            handler(Response {
                if let error = error {
                  throw error
                }
                if let data = data, let response = response as? HTTPURLResponse {
                  return (data, response)
                }
                throw UnexpectedResponse()
            })
        }
        task.resume()

        return task
    }
}
