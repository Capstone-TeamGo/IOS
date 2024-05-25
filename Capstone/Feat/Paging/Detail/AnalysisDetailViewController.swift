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
    private let analysisDetailViewModel = AnalysisDetailViewModel()
    private let reissueViewModel = ReissueViewModel()
    var model : AnaylsisResponseDtoList
    init(model: AnaylsisResponseDtoList) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let imageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "DetailBack")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let DetailText : UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - UI Layout
private extension AnalysisDetailViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        self.view.addSubview(DetailText)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        DetailText.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(30)
            make.center.equalToSuperview()
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
        self.DetailText.attributedText = attributedText
    }
}
//MARK: - Binding
private extension AnalysisDetailViewController {
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire.bind(onNext: { [weak self] expire in
            guard let self = self else { return }
            if expire == true {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            }else{
                if let analysisId = self.model.analysisId {
                    self.analysisDetailViewModel.detailTrigger.onNext(analysisId)
                    self.analysisDetailViewModel.detailResult.bind(onNext: { [weak self] result in
                        guard let self = self else { return }
                        if let data = result.data {
                            self.setText(data: data)
                        }
                    }).disposed(by: self.disposeBag)
                }
            }
        }).disposed(by: disposeBag)
    }
}
