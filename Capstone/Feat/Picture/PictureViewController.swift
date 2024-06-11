//
//  PictureViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/06/07.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import Kingfisher

final class PictureViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let imageURL : String
    private let descriptionText : String
    init(imageURL: String, descriptionText : String) {
        self.imageURL = imageURL
        self.descriptionText = descriptionText
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    //전체 담을 뷰
    private let recommandView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    //설명
    private let textView : UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return view
    }()
    //이미지
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.image = nil
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    //취소 버튼
    private let cancelBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        return btn
    }()
    private let loadingIndicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .lightGray
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
}
//MARK: - UI Layout
private extension PictureViewController {
    private func setLayout() {
        self.view.backgroundColor = .clear
        
        recommandView.addSubview(cancelBtn)
        recommandView.addSubview(image)
        recommandView.addSubview(textView)
        recommandView.addSubview(loadingIndicator)
        
        self.view.addSubview(recommandView)
        
        recommandView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.bottom.equalToSuperview().inset(self.view.frame.height / 6)
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
            make.width.height.equalTo(30)
        }
        image.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(40)
            make.height.equalToSuperview().dividedBy(1.4)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        self.loadingIndicator.startAnimating()
    }
}
//MARK: - Binding
private extension PictureViewController {
    private func setBinding() {
        if let imageUrl = URL(string: imageURL) {
            self.image.kf.setImage(with: imageUrl)
            self.loadingIndicator.stopAnimating()
        }
        self.textView.text = self.descriptionText
        cancelBtn.rx.tap.bind(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}
