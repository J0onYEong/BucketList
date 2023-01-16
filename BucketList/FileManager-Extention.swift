//
//  FileManager-Extention.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/10.
//

import Foundation

extension FileManager {
    func decodingStr(file: String) -> String {
        let baseUrl = Self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = baseUrl.appendingPathComponent(file)
        
        guard let str = try? String(contentsOf: fileUrl) else {
            fatalError("decoding error")
        }
        
        return str
    }
    
    func decodingJSON<T: Decodable>(file: String) -> T {
        let baseUrl = Self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = baseUrl.appendingPathComponent(file)
        
        guard let rawData = try? Data(contentsOf: fileUrl) else {
            fatalError("url error in \\FileManager.decodeJSON")
        }
        
        guard let resource = try? JSONDecoder().decode(T.self, from: rawData) else {
            fatalError("decoding error in \\FileManager.decodeJSON")
        }
        
        return resource
    }
}

