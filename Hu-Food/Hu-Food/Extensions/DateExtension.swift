//
//  DateExtension.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 6/5/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

extension Date {
     func getCurrentTime() -> String? {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        return formatter.string(from: currentDateTime)
    }
}
