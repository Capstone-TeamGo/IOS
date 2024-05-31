//
//  AnalysisDetailResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import Foundation

struct AnalysisDetailResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : AnalysisDetailData?
}
struct AnalysisDetailData : Codable {
    let analysisId : Int?
    let time : String?
    let feelingState : Double?
    let questionIds : [Int]?
    let questionContent : [String?]?
    let questionContentVoiceUrls : [String]?
    let answerContent : [String?]?
}
