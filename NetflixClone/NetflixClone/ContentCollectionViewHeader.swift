//
//  ContentCollectionViewHeader.swift
//  NetflixClone
//
//  Created by 유준용 on 2022/03/14.
//

import Foundation
import UIKit

class ContentCollectionViewHeader: UICollectionReusableView{ //UICollectionReusableView 클래스만 header or Footer가 될 수 있다.
    let sectionNameLabel = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    private func configureUI(){
        
        sectionNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        addSubview(sectionNameLabel)
        sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
    
}
