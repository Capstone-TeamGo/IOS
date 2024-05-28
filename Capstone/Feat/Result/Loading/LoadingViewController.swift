//
//  LoadingViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/28.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import UIKit

final class LoadingViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let loadingViewModel = LoadingViewModel()
    private let reissueViewModel = ReissueViewModel()
    var question : QuestionResponseModel
    init(question: QuestionResponseModel) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "저장 완료!"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let decLabel : UITextView = {
        let label = UITextView()
        label.text = "답변을 토대로 심리 분석중입니다.\n분석이 완료되면 자동으로 페이지가 넘어갑니다."
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let image : AnimatedImageView = {
        let view = AnimatedImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    //진행바
    private let progress : UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.tintColor = .systemGreen
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
}
//MARK: - UI Layout
private extension LoadingViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.view.clipsToBounds = true
        self.view.addSubview(titleLabel)
        self.view.addSubview(decLabel)
        self.view.addSubview(image)
        self.view.addSubview(progress)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(self.view.frame.height / 10)
        }
        decLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        image.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(0)
            make.top.equalTo(decLabel.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(30)
            make.height.equalToSuperview().dividedBy(3)
            make.center.equalToSuperview()
        }
        progress.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(20)
            make.top.equalTo(image.snp.bottom).offset(50)
        }
        
        if let gifUrl = Bundle.main.url(forResource: "confetti", withExtension: "gif") {
            image.kf.setImage(with: gifUrl)
        }
    }
}
//MARK: - Binding
private extension LoadingViewController {
    private func updateProgress() {
        guard self.progress.progress < 1.0 else { return }
        self.progress.progress += 0.01
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.updateProgress()
        }
    }
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire
            .take(1)
            .bind(onNext: { expire in
            if expire == true {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            } else {
                if let analysisId = self.question.data?.analysisId {
                    self.loadingViewModel.sentimentAnalysisTrigger.onNext(analysisId)
                    self.updateProgress()
                    Observable<Int>.interval(.milliseconds(5000), scheduler: MainScheduler.instance)
                        .take(until: self.loadingViewModel.sentimentAnalysisResult.filter { $0.code == 200 })
                        .subscribe(onNext: { [weak self] _ in
                            guard let self = self else { return }
                            print("서버로 전송")
                            self.loadingViewModel.sentimentAnalysisTrigger.onNext(analysisId)
                        })
                        .disposed(by: self.disposeBag)
                    self.loadingViewModel.sentimentAnalysisResult
                        .filter { $0.code == 200 }
                        .take(1) 
                        .subscribe(onNext: { [weak self] result in
                            guard let self = self else { return }
                            DispatchQueue.main.async {
                                // 프로그레스 바를 1.0으로 설정
                                if self.progress.progress != 1.0 {
                                    self.progress.progress = 1.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        let resultVC = ResultViewController()
                                        self.navigationController?.pushViewController(resultVC, animated: true)
                                    }
                                }else {
                                    let resultVC = ResultViewController()
                                    self.navigationController?.pushViewController(resultVC, animated: true)
                                }
                            }
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }).disposed(by: disposeBag)
    }
}
