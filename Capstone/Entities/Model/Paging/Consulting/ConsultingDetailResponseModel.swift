//
//  ConsultingDetailResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxSwift
import RxCocoa
struct ConsultingDetailResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : ConsultingDetailData?
    
}
struct ConsultingDetailData : Codable {
    let counselId : Int?
    let question : String?
    let answer : String?
    let counselType : String?
}
