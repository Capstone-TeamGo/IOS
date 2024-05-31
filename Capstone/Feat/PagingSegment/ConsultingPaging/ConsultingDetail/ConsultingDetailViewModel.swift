//
//  ConsultingDetailViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxCocoa
import RxSwift

final class ConsultingDetailViewModel {
    private let disposeBag = DisposeBag()
    private var consultingDetailNetwork : ConsultingDetailNetwork
    
    //상세 조회하기
    let detailTrigger = PublishSubject<Int>()
    let detailResult : PublishSubject<ConsultingDetailResponseModel> = PublishSubject()
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        consultingDetailNetwork = provider.getDetailCounsel()
        
        detailTrigger.flatMapLatest { id in
            return self.consultingDetailNetwork.consultingDetailNetwork(path: "\(CounselDetailURL)\(id)")
        }
        .bind(to: detailResult)
        .disposed(by: disposeBag)
    }
}

