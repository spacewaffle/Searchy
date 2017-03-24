//
//  WikipediaSearchResult.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 3/28/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
#endif

struct WikipediaSearchResult: CustomDebugStringConvertible {
    let title: String
    let description: String
    let URL: Foundation.URL

    init(title: String, description: String, URL: Foundation.URL) {
        self.title = title
        self.description = description
        self.URL = URL
    }

    // tedious parsing part
    static func parseJSON(_ json: [AnyObject]) throws -> [WikipediaSearchResult] {
        let rootArrayTyped = json.map { $0 as? [AnyObject] }
            .filter { $0 != nil }
            .map { $0! }

        if rootArrayTyped.count != 3 {
            throw WikipediaParseError
        }

        let titleAndDescription = Array(zip(rootArrayTyped[0], rootArrayTyped[1]))
        let titleDescriptionAndUrl: [((AnyObject, AnyObject), AnyObject)] = Array(zip(titleAndDescription, rootArrayTyped[2]))
        
        let searchResults: [WikipediaSearchResult] = try titleDescriptionAndUrl.map ( { result -> WikipediaSearchResult in
            let (first, url) = result
            let (title, description) = first

            guard let titleString = title as? String,
                  let descriptionString = description as? String,
                  let urlString = url as? String,
                  let URL = Foundation.URL(string: urlString) else {
                throw WikipediaParseError
            }

            return WikipediaSearchResult(title: titleString, description: descriptionString, URL: URL)
        })

        return searchResults
    }
    
    static func toJson(_ searchResults: [WikipediaSearchResult]) -> Data {
        let dict: [[String:String]] = searchResults.map({ (result: WikipediaSearchResult) -> [String:String] in
            ["title": result.title, "description": result.description, "URL": result.URL.absoluteString]
        })
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        // here "jsonData" is the dictionary encoded in JSON data

        return jsonData
    }
    
    static func toSearchResult(_ data: Data) -> [WikipediaSearchResult] {
        let json: [[String: String]] = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:String]]
        
        return try! json.map({ (data: [String: String]) -> WikipediaSearchResult in
            guard let title = data["title"],
                  let description = data["description"],
                  let urlstring = data["URL"],
                  let URL = Foundation.URL(string: urlstring)  else{
                throw WikipediaParseError
            }
            let result = WikipediaSearchResult(title: title, description: description, URL: URL)
            return result
        })
    }
    
    static func save(_ result: [WikipediaSearchResult]) -> Void {
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let json = WikipediaSearchResult.toJson(result)
        try! json.write(to: docsurl.appendingPathComponent("history.json"), options: [])
        
    }
    
    static func load() -> [WikipediaSearchResult] {
        
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let pathUrl = docsurl.appendingPathComponent("history.json")
        
        if( !fm.fileExists(atPath: pathUrl.path) ){
            let json = WikipediaSearchResult.toJson([])
            try! json.write(to: pathUrl, options: [])
        }
        
        guard let data = try? Data(contentsOf: pathUrl) else{
            fatalError("failed to load data from path url \(pathUrl)")
        }
        let result = WikipediaSearchResult.toSearchResult(data)

        return result
    }
    
    
}

extension WikipediaSearchResult {
    var debugDescription: String {
        return "[\(title)](\(URL))"
    }
}
