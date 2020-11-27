//
//  CommentContentHeaderView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

// MARK: - CommentHeaderView: UIView
class CommentHeaderView: UIView {

    // MARK: - ViewData
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
        let score: Int
        let postName: String
    }

    // MARK: - Properties
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?
    var postNameButtonTap: (() -> Void)?

    private let imageSize = CGSize(width: 32, height: 32)

    lazy var avatarView = UIImageView().then {
        $0.layer.cornerRadius = imageSize.width / 2
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }

    let usernameButton = UIButton().then {
        $0.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    let toTitle = UILabel().then {
        $0.text = "to"
        $0.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    let communityButton = UIButton().then {
        $0.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    let scoreLabel = UILabel()

    let publishedTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    let postNameButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.numberOfLines = 0

    }

    private let stackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 8
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupButtonTargets()
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with comment: CommentHeaderView.ViewData) {
        let usernameButtonText = "@" + comment.username

        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(comment.community, for: .normal)
        publishedTitle.text = comment.published
        scoreLabel.set(text: String(comment.score), leftIcon: Config.Image.boltFill)
        postNameButton.setTitle(comment.postName, for: .normal)

        if let avatarUrl = comment.avatarImageUrl {
            bindAvatar(url: avatarUrl)
        }
    }

    // MARK: - Private API
    private func bindAvatar(url: String) {
        Nuke.loadImage(with: ImageRequest(url: URL(string: url)!), into: avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize.height)
        }

        stackView.insertArrangedSubview(avatarView, at: 0)
    }

    private func setupButtonTargets() {
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped(sender:)), for: .touchUpInside)
        communityButton.addTarget(self, action: #selector(communityButtonTapped(sender:)), for: .touchUpInside)
        postNameButton.addTarget(self, action: #selector(postNameButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func communityButtonTapped(sender: UIButton!) {
        communityButtonTap?()
    }

    @objc private func usernameButtonTapped(sender: UIButton!) {
        usernameButtonTap?()
    }

    @objc private func postNameButtonTapped(sender: UIButton!) {
        postNameButtonTap?()
    }
}

extension CommentHeaderView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        stackView.addStackViewItems(
            .view(usernameButton),
            .view(toTitle),
            .view(communityButton),
            .view(scoreLabel),
            .view(publishedTitle)
        )
        
        self.addSubview(stackView)
        self.addSubview(postNameButton)
    }
    
    func makeConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
        }

        self.postNameButton.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}