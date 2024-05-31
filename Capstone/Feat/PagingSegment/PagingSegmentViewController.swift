//
//  PagingSegmentViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

final class PagingSegmentViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let analysisPagingVC = AnalysisPagingViewController()
    private let consultingPagingVC = ConsultingPagingViewController()
    
    //MARK: - UI Components
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["분석 기록", "상담 기록"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.tintColor = .systemGreen
        return control
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupBinding()
    }
}
//MARK: - UI Layout
private extension PagingSegmentViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        
        self.view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        addChild(analysisPagingVC)
        view.addSubview(analysisPagingVC.view)
        analysisPagingVC.view.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        analysisPagingVC.didMove(toParent: self)
        
        addChild(consultingPagingVC)
        view.addSubview(consultingPagingVC.view)
        consultingPagingVC.view.snp.makeConstraints { make in
            make.edges.equalTo(analysisPagingVC.view)
        }
        consultingPagingVC.didMove(toParent: self)
        
        analysisPagingVC.view.isHidden = false
        consultingPagingVC.view.isHidden = true
    }
}
//MARK: - Binding
private extension PagingSegmentViewController {
    private func setupBinding() {
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.analysisPagingVC.view.isHidden = index != 0
                self.consultingPagingVC.view.isHidden = index == 0
            })
            .disposed(by: disposeBag)
    }
}
