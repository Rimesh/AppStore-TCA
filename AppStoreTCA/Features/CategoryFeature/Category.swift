//
//  Category.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import SwiftUI

enum Category: String, CaseIterable {
    case finance, music, social, shopping, photo, productivity, games, puzzle, utilities, travel

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

extension Category: Identifiable {
    var id: String { rawValue }
}

extension Category: Equatable {}
