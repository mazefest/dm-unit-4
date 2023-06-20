//
//  NetworkController.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/17/23.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case error(String)
    
    var description: String {
        switch self {
        case .error(let description):
            return description
        }
    }
    
}

class NetworkController {
    static var shared = NetworkController()
    let baseURL: URL? = URL(string: "https://api.yelp.com/v3")
    
    func fetchBusiness(type: String, completion: @escaping (Result<YelpData, NetworkError>) -> ()) {
        guard var url = baseURL else {
            completion(.failure(.error("url err")))
            return
        }

        url.appendPathComponent("businesses")
        url.appendPathComponent("search")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        components?.queryItems = [
            URLQueryItem(name: "term", value: type),
            URLQueryItem(name: "location", value: "1550 Digital Dr #400, Lehi, UT 84043"),
            URLQueryItem(name: "limit", value: "10")
        ]

        guard let builtURL = components?.url else {
            completion(.failure(.error("Failure building URL")))
            return
        }

        var request = URLRequest(url: builtURL)

        request.allHTTPHeaderFields = Constants.headers

        print("[NetworkManager] - \(#function) builtURL: \(builtURL.description)")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(.error(error.localizedDescription)))
                return
            }

            guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                completion(.failure(.error(">>>>\(response.debugDescription) response:")))
                return
            }

            guard let data = data else {
                print("error: \(String(describing: error)): \(error?.localizedDescription ?? "")")
                completion(.failure(.error("Invalud Data")))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(YelpData.self, from: data)
                completion(.success(decodedData))
                return
            } catch {
                completion(.failure(.error("failure decoding")))
                return
            }
        }
        .resume()
    }
}
