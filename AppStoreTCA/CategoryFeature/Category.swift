//
//  Category.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case games, finance, music, social, shopping, photo, productivity, puzzle, utilities, travel

    var id: String { rawValue }

    var gradientColor: Color {
        switch self {
        case .games, .photo: Color("categoryBlue")
        case .finance, .productivity: Color("categoryGreen")
        case .music, .puzzle: Color("categoryPink")
        case .social, .utilities: Color("categoryPurple")
        case .shopping, .travel: Color("categoryYellow")
        }
    }
}
