//
//  APIServices.swift
//  ContactsApp
//
//  Created by Subhadeep Pal on 29/08/19.
//

import Foundation


protocol API {
    func get<T : Decodable>(queryParam: [String:String]?, appendPath: String?, completion: @escaping (_ isSuccess: Bool, _ response: T?)->Void)
}

extension API {
    func get<T : Decodable>(queryParam: [String:String]?, appendPath: String?, completion: @escaping (_ isSuccess: Bool, _ response: T?)->Void) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let path = "https://my-json-server.typicode.com/guljar-rivi/server/db"
        
        guard var urlComponent = URLComponents(string: path) else { return }
        if let queryParams = queryParam {
            var params = [URLQueryItem]()
            for key in queryParams.keys {
                params.append(URLQueryItem(name: key, value: queryParams[key]))
            }
            urlComponent.queryItems = params
        }
        
        guard let url = urlComponent.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        let dataTask = session.dataTask(with: request) {
            (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  let receivedData = data else {
                    print("error: not a valid http response")
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(BaseResponse<T>.self, from: receivedData)
                    DispatchQueue.main.async {
                        completion(true, response.data)
                    }
                } catch {
                    print("error parsing JSON")
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
            default:
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        dataTask.resume()
    }
}
