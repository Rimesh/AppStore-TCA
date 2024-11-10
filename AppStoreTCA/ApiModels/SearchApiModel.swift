//
//  SearchApiModel.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//

import Foundation

struct SearchApiModel: Decodable {
    let resultCount: Int
    let results: [AppApiModel]
}
