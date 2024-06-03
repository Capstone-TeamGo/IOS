//
//  Double + Extension.swift
//  Capstone
//
//  Created by 정성윤 on 2024/06/01.
//

import Foundation
extension Double {
    var isValidInt: Bool {
        return self.isFinite && !self.isNaN
    }
}

extension SentimentAnalysisData {
    var safeFeelingState: Int? {
        guard let feelingState = feelingState, feelingState.isValidInt else {
            return nil
        }
        return Int(feelingState)
    }
}
