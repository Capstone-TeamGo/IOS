//
//  ConsultingViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxSwift
import RxCocoa

final class ConsultingViewModel {
    private let disposeBag = DisposeBag()
    private var counselNetwork : CounselNetwork
    
    //심리상담
    let counselTrigger = PublishSubject<[String]>()
    let counselResult : PublishSubject<CounselResponseModel> = PublishSubject()
    
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        counselNetwork = provider.counselNetwork()
        
        counselTrigger.subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            let params : [String:Any] = [
                "analysisId" : data[0],
                "counselType" : data[1],
                "question" : data[2]
            ]
            self.counselNetwork.counselNetwork(path: CounselURL, params: params)
                .subscribe(onNext: {[weak self] result in
                    guard let self = self else { return }
                    self.counselResult.onNext(result)
                }).disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
}
