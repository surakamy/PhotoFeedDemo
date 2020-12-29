//
//  PicsumFeedLoader.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import Foundation

public enum RemoteFeedError: Error {
    case decodableFailed
    case connectivity
}

public protocol RemoteFeedLoader {
    typealias Result = Swift.Result<[JSONImage], RemoteFeedError>

    @discardableResult
    func load(page: Int, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

public struct JSONImage: Decodable, Equatable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String

    public init(id: String, author: String, width: Int, height: Int, url: String, download_url: String) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.download_url = download_url
    }
}


public struct PicsumFeedLoader: RemoteFeedLoader {

    public typealias Result = RemoteFeedLoader.Result

    private var client: HTTPClient
    private var base: String = "https://picsum.photos/v2"

    public init(client: HTTPClient) {
        self.client = client
    }

    @discardableResult
    public func load(page: Int, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let request = URLRequest(url: PicsumFeedLoader.endpoint(page: page))
        return client.dispatch(request) {
            completion(map(response: $0))
        }
    }

    private func map(response: HTTPClient.Response) -> Result {
        switch response {

        case let .success(received):
            if received.http.statusCode == 200 {
                do {
                    let images = try JSONDecoder().decode([JSONImage].self, from: received.data)
                    return Result.success(images)
                } catch {
                    return Result.failure(RemoteFeedError.decodableFailed)
                }

            }
            return Result.failure(RemoteFeedError.connectivity)

        case .failure:
            return Result.failure(RemoteFeedError.connectivity)
        }
    }

    static func endpoint(page: Int) -> URL {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "picsum.photos"
        components.path = "/v2/list"
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "21")
        ]

        return components.url!
    }
}
