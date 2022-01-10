//
//  Card.swift
//  Set
//
//  Created by Sebastian Pfeufer on 28/02/2021.
//

import Foundation

struct Card {
    
    let feature1: Variant
    let feature2: Variant
    let feature3: Variant
    let feature4: Variant
    
    enum Variant: Int {
        case v1 = 1
        case v2 = 2
        case v3 = 3
    }
    
    private(set) var identifier: Int
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(feature1: Variant, feature2: Variant, feature3: Variant, feature4: Variant) {
        self.feature1 = feature1
        self.feature2 = feature2
        self.feature3 = feature3
        self.feature4 = feature4
        self.identifier = Card.getUniqueIdentifier()
    }
}

extension Card: Equatable {
    
}
