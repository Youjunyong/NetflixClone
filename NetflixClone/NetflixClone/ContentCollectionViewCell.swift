//
//  ContentCollectionViewCell.swift
//  NetflixClone
//
//  Created by 유준용 on 2022/03/12.
//

import SnapKit
import UIKit

class ContentCollectionViewCell: UICollectionViewCell{
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        // contentView는 어디서 나온거냐???
        // UICollectionViewCell의 기본 객체
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        // 4방향 꽉차게 이미지 채우기
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
