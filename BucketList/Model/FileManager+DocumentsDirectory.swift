//
//  FileManager+DocumentsDirectory.swift
//  BucketList
//
//  Created by QBUser on 12/07/22.
//

import Foundation

extension FileManager {
    var documentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
}
