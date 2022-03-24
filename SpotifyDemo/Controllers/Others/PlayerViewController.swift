//
//  PlayerViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/10.
//

import UIKit

class PlayerViewController: UIViewController {

    private var imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .systemBlue
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.left.right.equalTo(0)
            make.width.height.equalTo(view.snp.width)
        }
        controlsView.snp.makeConstraints { make in
            make.left.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    private func configureBarButtons() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapAction() {
        //Actions
    }
}
