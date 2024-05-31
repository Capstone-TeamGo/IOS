//
//  ConsultingPagingResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
struct ConsultingPagingResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : ConsultingPagingData?
}
struct ConsultingPagingData : Codable {
    let currentPage : Int?
    let numberPerPage : Int?
    let totalPage : Int?
    let totalElements : Int?
    let counselContent : [CounselContent]?
}
struct CounselContent : Codable {
    let date : String?
    let counselId : Int?
    let counselType : String?
    let analysisUsed : Bool?
}
