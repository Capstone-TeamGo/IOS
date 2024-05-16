//
//  AnswerResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/15.
//

import Foundation
struct AnswerResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let errorCode: Int?
    let details : [String]?
    let data : AnswerID?
}
struct AnswerID : Codable {
    let answerId : Int
}
