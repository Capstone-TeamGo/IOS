//
//  ResultViewController.swift
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

final class ResultViewController : UIViewController {
    private let disposeBag = DisposeBag()
    //MARK: - UI Components
    var analysisId : String
    var feelingState : Double
    init(analysisId: String, feelingState : Double) {
        self.analysisId = analysisId
        self.feelingState = feelingState
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "분석 완료!"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let decLabel : UITextView = {
        let label = UITextView()
        label.text = "심리분석 결과에 맞는 상담사가 생성되었습니다."
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private lazy var chatBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle(" 상담 받아보기 ➜", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setImage(UIImage(named: "Chat"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(chatBtnTapped), for: .touchUpInside)
        return btn
    }()
    //현재 우울점수
    private var depressedLabel : UILabel = {
        let label = UILabel()
        label.text = nil
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Result")
        view.clipsToBounds = true
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
//MARK: - UI Layout
private extension ResultViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.TypingAnimation(finalScore: self.feelingState)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(decLabel)
        self.view.addSubview(chatBtn)
        self.view.addSubview(depressedLabel)
        self.view.addSubview(image)
        
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
        chatBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(decLabel.snp.bottom).offset(0)
            make.height.equalTo(30)
        }
        depressedLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(chatBtn.snp.bottom).offset(20)
        }
        image.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
            make.top.equalTo(depressedLabel.snp.bottom).offset(100)
            make.height.equalToSuperview().dividedBy(3)
        }
    }
    private func TypingAnimation(finalScore: Double) {
        let duration: Double = 2.0 // 애니메이션 지속 시간 (초)
        let increment: Double = 0.1 // 점수 증가 단위
        let interval: Double = duration / (finalScore / increment) // 애니메이션 주기
        var currentScore: Double = 0.0 // 초기 점수
        
        let fullText: (Double) -> String = { score in
            return "심리분석 결과 우울 점수 : \(String(format: "%.1f", score))점"
        }
        
        Observable<Int>
            .interval(.milliseconds(Int(interval * 1000)), scheduler: MainScheduler.instance)
            .take(Int(finalScore / increment) + 1) // 최종 점수까지 증가
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                currentScore += increment
                if currentScore > finalScore {
                    currentScore = finalScore
                }
                self.depressedLabel.text = fullText(currentScore)
            }).disposed(by: disposeBag)
    }
    
    @objc private func chatBtnTapped() {
        self.navigationController?.pushViewController(ConsultingViewController(analysisId: analysisId), animated: true)
    }
}
