//
//  HelperExtension.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/26.
//

import Foundation

func getFileDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}
