//
//  AnalysisDetailViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AnalysisDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var model : AnaylsisResponseDtoList
    init(model: AnaylsisResponseDtoList) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
