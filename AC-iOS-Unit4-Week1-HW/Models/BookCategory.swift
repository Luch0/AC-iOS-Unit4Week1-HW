//
//  BookCategory.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CategoryResponse: Codable {
    let num_results: Int
    let results: [BookCategory]
}

struct BookCategory: Codable {
    let list_name: String
    let display_name: String
    let list_name_encoded: String
    let oldest_published_date: String
    let newest_published_date: String
    let updated: String
}

struct BookCategoryAPI {
    private init() {}
    static let manager = BookCategoryAPI()
    
    let apiKey = "625d90145c754087a4e16200c1bbdfb6"
    let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key="
    func getBookCategories(completionHandler: @escaping ([BookCategory]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let fullUrl = urlStr + apiKey
        guard let url = URL(string: fullUrl) else {
            errorHandler(AppError.badURL(str: fullUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let categoryResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
                completionHandler(categoryResponse.results)
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
    }
}