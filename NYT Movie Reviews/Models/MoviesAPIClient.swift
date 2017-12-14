//
//  MoviesAPIClient.swift
//  NYT Movie Reviews
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

struct MovieAPIClient {
    private init() {}
    static let manager = MovieAPIClient()
    func getMovies(from str: String,
                   completionHandler: @escaping ([Movie]) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        let APIKey = "9f39668c8c0d4aadbd3e97a30c45e5c7"
        let urlStr = str + APIKey
        guard let authenticatedRequest = buildAuthRequest(from: urlStr, httpVerb: .GET) else { errorHandler(AppError.badURL); return }
        let parseDataIntoImageArr = {(data: Data) in
            do {
                let onlineImages = try JSONDecoder().decode(AllInfo.self, from: data)
                completionHandler(onlineImages.results)
            }
            catch let error {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: authenticatedRequest, completionHandler: parseDataIntoImageArr, errorHandler: errorHandler)
    }
    
//    func post(favorite: Favorite, errorHandler: @escaping (Error) -> Void) {
//        let urlStr = "https://api.fieldbook.com/v1/5a25f6ad306a170300b666d4/images"
//        guard var authPostRequest = buildAuthRequest(from: urlStr, httpVerb: .POST) else {errorHandler(AppError.badURL); return }
//        do {
//            let encodedFavorite = try JSONEncoder().encode(favorite)
//            authPostRequest.httpBody = encodedFavorite
//            NetworkHelper.manager.performDataTask(with: authPostRequest,
//                                                  completionHandler: {_ in print("Made a post request")},
//                                                  errorHandler: errorHandler)
//        }
//        catch {
//            errorHandler(AppError.couldNotParseJSON(rawError: error))
//        }
//    }
    
    private func buildAuthRequest(from urlStr: String, httpVerb: HTTPVerb) -> URLRequest? {
        guard let url = URL(string: urlStr) else { return nil }
        var request = URLRequest(url: url)
        let userName = "key-5"
        let password = "I2vNXkTKcUY4WUq2MgAk"
        let authStr = buildAuthStr(userName: userName, password: password)
        if httpVerb == .POST {
            request.addValue(authStr, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    private func buildAuthStr(userName: String, password: String) -> String {
        let nameAndPassStr = "\(userName):\(password)"
        let nameAndPassData = nameAndPassStr.data(using: .utf8)!
        let authBase64Str = nameAndPassData.base64EncodedString()
        let authStr = "Basic \(authBase64Str)"
        return authStr
    }
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL)
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {
                errorHandler(AppError.notAnImage)
                return
            }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: urlRequest,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
