//
//  StringExt.swift
//  BBQuotes
//
//  Created by Mario Duarte on 02/02/26.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpaces() -> String {
        return self.removeSpaces().lowercased()
    }
}
