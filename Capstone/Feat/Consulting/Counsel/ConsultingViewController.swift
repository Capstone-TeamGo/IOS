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
import NVActivityIndicatorView

final class ConsultingViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let reissueViewModel = ReissueViewModel()
    private let consultingViewModel = ConsultingViewModel()
    private var selectedCategory : String = ""
    private var pencilBool : Bool = false
    var analysisId : String
    init(analysisId: String) {
        self.analysisId = analysisId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    //질문 -> 답변 텍스트
    private let totalText : UITextView = {
        let view = UITextView()
        view.backgroundColor = .white
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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
        view.backgroundColor = .white
        view.axis = .horizontal
        view.spacing = 10
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
    //로딩 창
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat)
        view.color = .lightGray
        view.backgroundColor = .clear
        return view
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
        
        self.setCategory()
        self.view.addSubview(category)
        self.view.addSubview(totalText)
        self.view.addSubview(questionBtn)
        self.view.addSubview(answerBtn)
        self.view.addSubview(loadingIndicator)
        
        category.snp.makeConstraints { make in
            make.width.equalTo(60 * 5 + 10 * 4)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
        }
        totalText.snp.makeConstraints { make in
            make.top.equalTo(category.snp.bottom).offset(50)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 9)
            make.leading.trailing.equalToSuperview().inset(20)
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
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    private func setText(data : CounselResponseData) {
        let attributedText = NSMutableAttributedString()
        let largeTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.systemGreen
        ]
        let mediumTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.darkGray
        ]
        
        //질문, 답변
        if let answerContent = data.counselResult,
           let questionContent = self.totalText.text{
            let Qmark = NSAttributedString(string: "Q. ", attributes: largeTextAttributes)
            let QuestionText = NSAttributedString(string: "\n\n\(questionContent)\n\n", attributes: mediumTextAttributes)
            let Amark = NSAttributedString(string: "A. ", attributes: largeTextAttributes)
            let AnswerText = NSAttributedString(string: "\n\n\(answerContent)\n\n", attributes: mediumTextAttributes)
            
            attributedText.append(Qmark)
            attributedText.append(QuestionText)
            attributedText.append(Amark)
            attributedText.append(AnswerText)
        }
        self.totalText.attributedText = attributedText
    }
    private func setCategory() {
        let categories : [String] = ["연애", "취업진로", "정신건강", "대인관계", "가족"]
        for c in categories {
            let btn = UIButton()
            btn.backgroundColor = .BackgroundColor
            btn.setTitle(c, for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.layer.cornerRadius = 15
            btn.layer.masksToBounds = true
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            btn.snp.makeConstraints { make in
                make.width.equalTo(60)
                make.height.equalTo(40)
            }
            //버튼 액션
            btn.rx.tap.bind{ _ in
                btn.backgroundColor = .systemGreen
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
                // 클릭한 버튼 이외의 다른 버튼 색상 원래대로 변경
                for subview in self.category.arrangedSubviews {
                    if let otherButton = subview as? UIButton, otherButton != btn {
                        otherButton.backgroundColor = .BackgroundColor
                        otherButton.setTitleColor(.black, for: .normal)
                        otherButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                    }
                }
                guard let selectedText = btn.titleLabel?.text else { return }
                self.selectedCategory = selectedText
            }.disposed(by: disposeBag)
            
            self.category.addArrangedSubview(btn)
        }
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
                        self.totalText.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                        self.totalText.textColor = .black
                        self.totalText.becomeFirstResponder()
                        self.pencilBool = true
                    }
                }.disposed(by: self.disposeBag)
                self.answerBtn.rx.tap.bind { _ in
                    DispatchQueue.main.async {
                        self.totalText.isEditable = false
                        self.totalText.isUserInteractionEnabled = false
                        self.loadingIndicator.startAnimating()
                        //서버로 전송
                        if self.pencilBool == true {
                            if let question = self.totalText.text {
                                self.consultingViewModel.counselTrigger.onNext(["\(self.analysisId )","\(self.selectedCategory)","\(question)"])
                                self.pencilBool = false
                            }else{
                                self.showsAlert(message: "잠시 후 다시 시도해보세요!")
                                self.loadingIndicator.stopAnimating()
                            }
                        }else{
                            self.showsAlert(message: "새로운 고민을 작성해주세요!")
                            self.loadingIndicator.stopAnimating()
                        }
                    }
                }.disposed(by: self.disposeBag)
                self.consultingViewModel.counselResult.bind(onNext: {[weak self] result in
                    guard let self = self else { return }
                    self.loadingIndicator.stopAnimating()
                    if result.code == 201 {
                        if let data = result.data {
                            self.setText(data: data)
                        }
                    }
                })
                .disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
    private func showsAlert(message : String) {
        let Alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "확인", style: .default)
        Alert.addAction(Ok)
        self.present(Alert, animated: true)
    }
}
