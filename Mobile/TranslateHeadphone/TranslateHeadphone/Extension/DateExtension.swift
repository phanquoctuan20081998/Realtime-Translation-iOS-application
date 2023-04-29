//
//  DateExtension.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/26.
//

import Foundation

extension Date
{
    func toString(dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
