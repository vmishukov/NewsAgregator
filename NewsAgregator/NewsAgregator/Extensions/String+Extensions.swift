//
//  String+Extensions.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 24.04.2024.
//

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    NSLocalizedString(string, comment: "")
}
