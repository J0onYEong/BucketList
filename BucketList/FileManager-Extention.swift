//
//  FileManager-Extention.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/10.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

