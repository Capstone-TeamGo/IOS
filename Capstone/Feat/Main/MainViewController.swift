//
//  MainViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices
import Charts
import DGCharts
final class MainViewController: UIViewController{
    private let disposeBag = DisposeBag()
    private let mainViewModel = MainViewModel()
    private let feelingTrigger = PublishSubject<Void>()
    
    //MARK: UI Components
    private let naviLogo : UILabel = {
        let label = UILabel()
        label.text = "CheeYou"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .FifthryColor
        label.textAlignment = .left
        return label
    }()
    //명언
    private let naviImage : UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .clear
        return image
    }()
    //분석 버튼
    private lazy var analyzeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon1"), for: .normal)
        btn.setImage(UIImage(named: "mainIcon1"), for: .highlighted)
        btn.backgroundColor = .white
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(analyzeBtnTapped), for: .touchUpInside)
        return btn
    }()
    //상담 버튼
    private lazy var consultingBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon2"), for: .normal)
        btn.setImage(UIImage(named: "mainIcon2"), for: .highlighted)
        btn.backgroundColor = .white
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        return btn
    }()
    //과거 기록 버튼
    private lazy var recordBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon4"), for: .normal)
        btn.setImage(UIImage(named: "mainIcon4"), for: .highlighted)
        btn.backgroundColor = .white
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        return btn
    }()
    //추천 버튼
    private lazy var growingBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon3"), for: .normal)
        btn.setImage(UIImage(named: "mainIcon3"), for: .highlighted)
        btn.backgroundColor = .white
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(growingBtnTapped), for: .touchUpInside)
        return btn
    }()
    //차트
    private let Chart : BarChartView = {
        let view = BarChartView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.rightAxis.drawLabelsEnabled = false
        view.leftAxis.drawLabelsEnabled = false
        view.isUserInteractionEnabled = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setLayout()
        setBinding()
    }
}
//MARK: - UI Navigation
extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
    }
    private func setNavigation() {
        self.title = "홈"
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: naviLogo)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.BackgroundColor]
        self.navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - UI Layout
private extension MainViewController {
    private func setLayout() {
        let View = UIView()
        View.backgroundColor = .BackgroundColor
        View.addSubview(naviImage)
        View.addSubview(analyzeBtn)
        View.addSubview(consultingBtn)
        View.addSubview(recordBtn)
        View.addSubview(growingBtn)
        View.addSubview(Chart)
        self.view.addSubview(View)
        View.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        naviImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(self.view.frame.height / 8)
            make.height.equalTo(40)
        }
        analyzeBtn.snp.makeConstraints { make in
            make.top.equalTo(naviImage.snp.bottom).offset(30)
            make.height.equalToSuperview().dividedBy(3.5)
            make.width.equalToSuperview().dividedBy(2.5)
            make.leading.equalToSuperview().inset(20)
        }
        consultingBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().dividedBy(4.5)
            make.top.equalTo(analyzeBtn.snp.bottom).offset(10)
        }
        recordBtn.snp.makeConstraints { make in
            make.top.equalTo(naviImage.snp.bottom).offset(30)
            make.height.equalTo(analyzeBtn.snp.height).dividedBy(2).inset(2.5)
            make.leading.equalTo(analyzeBtn.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
        growingBtn.snp.makeConstraints { make in
            make.height.equalTo(analyzeBtn.snp.height).dividedBy(2).inset(2.5)
            make.top.equalTo(recordBtn.snp.bottom).offset(10)
            make.leading.equalTo(recordBtn.snp.leading).inset(0)
            make.trailing.equalToSuperview().inset(20)
        }
        Chart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(consultingBtn.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 9)
        }
    }
    private func setchart(model : FeelingRequestModel) {
        var entries = [BarChartDataEntry]()
        if let feels = model.data?.feelingStateResponsesDto {
            var index : Double = 0.0
            for feel in feels {
                entries.append(BarChartDataEntry(x: index, y: feel.avgFeelingState ?? 0.0))
                index += 1
            }
        }
        for index in 0...7 {
            entries.append(BarChartDataEntry(x: Double(index), y: Double(index)))
        }
        let dataSet = BarChartDataSet(entries: entries, label: "최근 7일 심리분석 결과")
        dataSet.colors = [.systemGreen]
        dataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueTextColor(.black)
        data.setValueFont(UIFont.systemFont(ofSize: 12))
        
        Chart.data = data
        Chart.animate(xAxisDuration: 0, yAxisDuration: 1.5)
    }
}
//MARK: - set Binding
private extension MainViewController {
    private func setBinding() {
        self.naviImage.image = UIImage(named: "image1")
        self.mainViewModel.feelingTrigger.onNext(())
        self.mainViewModel.feelingResult.subscribe(onNext: {[weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setchart(model: result)
            }
        })
        .disposed(by: disposeBag)
    }
    @objc func analyzeBtnTapped() {
        self.navigationController?.pushViewController(FirstQuestionViewController(), animated: true)
    }
    @objc func growingBtnTapped() {
        self.navigationController?.pushViewController(GrowingViewController(), animated: true)
    }
}
