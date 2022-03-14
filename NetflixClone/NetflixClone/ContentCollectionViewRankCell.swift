//
//  ContentCollectionRankCell.swift
//  NetflixClone
//
//  Created by 유준용 on 2022/03/14.
//

import UIKit

class ContentCollectionRankCell: UICollectionViewCell {
    let imageView = UIImageView()
    let rankLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        configureUI()
    }
    
    private func configureUI(){
//        imageView
        imageView.contentMode = .scaleToFill
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        // rankLabel
        rankLabel.font = .systemFont(ofSize: 80, weight: .black)
        rankLabel.textColor = .white
        contentView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
}
