//
//  Comparable+Extensions.swift
//  PlayAround
//
//  Created by Szymon Swietek on 25/08/2022.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
