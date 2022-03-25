//
//  NoDataView.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/25.
//

import UIKit

struct NoDataViewViewModel {
    let text: String
    let actionTitle: String
    let imageName: String?
}

protocol NoDataViewDelegate: AnyObject {
    func noDataViewButtonTapped(_ noDataView: NoDataView)
}
class NoDataView: UIView {

    weak var delegate: NoDataViewDelegate?
    
    private let imageview: UIImageView = {
       let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
//        isHidden = true
        addSubview(imageview)
        addSubview(label)
        addSubview(button)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapButton() {
        delegate?.noDataViewButtonTapped(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalToSuperview().offset(-55)
            make.height.equalTo(44)
        }
        imageview.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.lessThanOrEqualTo(self.width-40)
        }
        label.snp.makeConstraints { make in
            make.left.right.equalTo(10)
            make.top.equalTo(imageview.snp.bottom).offset(20)
        }
    }
    
    func configure(with viewModel: NoDataViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
        guard let imgName = viewModel.imageName else
        {
            return
        }
        imageview.image = UIImage(named: imgName )
    }
}
