//
//  WelcomeViewController.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/10.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()
    
    private let bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "album_cover")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()
    
    private let logoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icon")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "Listion to Millions\nof Songs on\nthe go."
        label.textAlignment = .center
        label.textColor = .systemGreen
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
        
        view.backgroundColor = .systemGreen
        view.addSubview(bgImgView)
        view.addSubview(overlayView)
        view.addSubview(logoImgView)
        view.addSubview(welcomeLabel)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgImgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        overlayView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        logoImgView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)

        }
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImgView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
        }
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
        
        
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] success in
            self?.handleSignIn(success: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        //Log in
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong on signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVc = TabBarViewController()
        mainAppTabBarVc.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVc, animated: true)
    }
}
