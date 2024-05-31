//
//  ConsultingViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ConsultingViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let reissueViewModel = ReissueViewModel()
    private let consultingViewModel = ConsultingViewModel()
    
    //MARK: - UI Components
    //질문 -> 답변 텍스트
    private let totalText : UITextView = {
        let view = UITextView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isUserInteractionEnabled = false
        view.isEditable = false
        return view
    }()
    //카테고리
    private let category : UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .gray
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fill
        view.clipsToBounds = true
        return view
    }()
    //질문버튼
    private let questionBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        return btn
    }()
    //상담버튼
    private let answerBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.setImage(UIImage(systemName: "bubble.left.and.bubble.right.fill"), for: .normal)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setupHideKeyboardOnTap()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - UI Layout
private extension ConsultingViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.clipsToBounds = true
        
        self.view.addSubview(category)
        self.view.addSubview(totalText)
        self.view.addSubview(questionBtn)
        self.view.addSubview(answerBtn)
        
        category.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
        }
        totalText.snp.makeConstraints { make in
            make.top.equalTo(category.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 9)
            make.leading.trailing.equalToSuperview()
        }
        questionBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 5)
        }
        answerBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(questionBtn.snp.bottom).offset(10)
        }
    }
    private func setText(data : AnalysisDetailData) {
        let attributedText = NSMutableAttributedString()
        let largeTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        let mediumTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.darkGray
        ]
        
        //질문, 답변
        for index in 0...3 {
            if let questionContent = data.questionContent,
               let answerContent = data.answerContent{
                let QuestionText = NSAttributedString(string: "\n\n\(questionContent[index] ?? "질문")\n\n", attributes: largeTextAttributes)
                let AnswerText = NSAttributedString(string: "\n\n\(answerContent[index] ?? "답변")\n\n", attributes: mediumTextAttributes)
                
                attributedText.append(QuestionText)
                attributedText.append(AnswerText)
            }
        }
        self.totalText.attributedText = attributedText
    }
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
//MARK: - Binding
private extension ConsultingViewController {
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire.bind { expire in
            if expire == true {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            }else{
                self.questionBtn.rx.tap.bind { _ in
                    DispatchQueue.main.async {
                        self.totalText.text = nil
                        self.totalText.isEditable = true
                        self.totalText.isUserInteractionEnabled = true
                        self.totalText.becomeFirstResponder()
                    }
                }.disposed(by: self.disposeBag)
                self.answerBtn.rx.tap.bind { _ in
                    DispatchQueue.main.async {
                        self.totalText.isEditable = false
                        self.totalText.isUserInteractionEnabled = false
                    }
                }.disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
}
