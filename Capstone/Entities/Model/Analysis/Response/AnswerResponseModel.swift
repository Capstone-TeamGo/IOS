//
//  AnswerResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/15.
//

import Foundation
struct AnswerResponseModel {
    let code : Int?
    let state : String?
    let message : String?
    let data : AnswerID?
}
struct AnswerID {
    let answerId : Int
}
