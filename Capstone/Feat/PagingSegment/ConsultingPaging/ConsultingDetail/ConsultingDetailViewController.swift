//
//  ConsultingDetailViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ConsultingDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let consultingDetailViewModel = ConsultingDetailViewModel()
    private let reissueViewModel = ReissueViewModel()
    var model : CounselContent
    init(model: CounselContent) {
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
private extension ConsultingDetailViewController {
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
    private func setText(data : ConsultingDetailData) {
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
        if let answerContent = data.answer,
           let questionContent = data.question{
            let Qmark = NSAttributedString(string: "\n\nQ. ", attributes: largeTextAttributes)
            let QuestionText = NSAttributedString(string: "\n\n\(questionContent)\n\n", attributes: mediumTextAttributes)
            let Amark = NSAttributedString(string: "A. ", attributes: largeTextAttributes)
            let AnswerText = NSAttributedString(string: "\n\n\(answerContent)\n\n", attributes: mediumTextAttributes)
            
            attributedText.append(Qmark)
            attributedText.append(QuestionText)
            attributedText.append(Amark)
            attributedText.append(AnswerText)
        }
        self.DetailText.attributedText = attributedText
        self.showImage(url: "")
    }
}
//MARK: - Binding
private extension ConsultingDetailViewController {
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire
            .take(1)
            .bind(onNext: { [weak self] expire in
            guard let self = self else { return }
            if expire == true {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            }else{
                if let counselId = self.model.counselId {
                    self.consultingDetailViewModel.detailTrigger.onNext(counselId)
                    self.consultingDetailViewModel.detailResult.bind(onNext: { [weak self] result in
                        guard let self = self else { return }
                        if let data = result.data {
                            self.setText(data: data)
                        }
                    }).disposed(by: self.disposeBag)
                }
            }
        }).disposed(by: disposeBag)
    }
    private func showImage(url : String) {
        let pictureVC = PictureViewController(imageURL: url, descriptionText: "과거 추천했던 그림입니다!🖼️")
        pictureVC.modalTransitionStyle = .flipHorizontal
        self.present(pictureVC, animated: true)
    }
}
