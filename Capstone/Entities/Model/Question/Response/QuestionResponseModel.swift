//
//  QuestionResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/19.
//

import Foundation

struct QuestionResponseModel : Codable {
    let code : Int
    let state : String
    let message : String?
    let data : QuestionData?
}
struct QuestionData : Codable {
    let analysisId : Int?
    let questionTexts : [String]?
    let accessUrls : [String]?
    let questions : [Int]?
}
