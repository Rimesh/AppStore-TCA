//
//  CategoryFeature.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CategoryFeature {
    @ObservableState
    struct State: Equatable {
        let categories: [Category] = Category.allCases
    }

    enum Action {
        case categoryButtonTapped(Category)
        case delegate(Delegate)

        @CasePathable
        enum Delegate {
            case selectCategory(Category)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case let .categoryButtonTapped(category):
                return .run { send in
                    await send(.delegate(.selectCategory(category)))
                }
            case .delegate:
                return .none
            }
        }
    }
}
