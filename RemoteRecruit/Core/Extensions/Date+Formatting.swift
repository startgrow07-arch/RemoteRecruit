//
//  Date+Formatting.swift
//  RemoteRecruit
//
//  Created by Chittranjan on 06/06/26.
//

import Foundation

extension Date {
    var jobPostedText: String {
        formatted(.dateTime.month(.abbreviated).day().year())
    }
}
