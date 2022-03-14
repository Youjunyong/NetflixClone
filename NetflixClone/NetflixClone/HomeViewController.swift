//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by 유준용 on 2022/03/12.
//

import UIKit
import SwiftUI


class HomeViewController: UICollectionViewController{
    
    
    var contents: [Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        self.contents = fetchContents()
        self.collectionView.backgroundColor = .black
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true // 중요
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
    }
    private func configureCollectionView(){
        self.collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
//        self.collectionView.register(ContentCollectionViewCell(), forCellWithReuseIdentifier: "ContentCollectionViewCell") 이거 왜 안돼냐?@@ .self는 뭘ㄲ?
        self.collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")
        // Method 주의!! 헤더는 Cell이 아니라  supplemetaryview 이다.
        
        self.collectionView.register(ContentCollectionRankCell.self, forCellWithReuseIdentifier: "ContentCollectionRankCell")
        
        self.collectionView.collectionViewLayout = sectionLayout()
    }
    
    // Plist로부터 데이터 가져오기
    private func fetchContents() -> [Content]{
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"), let data = FileManager.default.contents(atPath: path), let list = try? PropertyListDecoder().decode([Content].self, from: data) else{return [] }
        return list
    }
    // 각각의 섹션 타입에 대한 UICollectionViewLayout 생성
    private func sectionLayout() -> UICollectionViewLayout{
        return UICollectionViewCompositionalLayout{[weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else {return nil}
            switch self.contents[sectionNumber].sectionType{
            case .basic:
                return self.createBasicTypeSection()
            case .large:
                return self.createLargeTypeSection()
            case .rank:
                return self.createRankTypeSection()
            default:
                return nil
            }
        }
    }
    // "Basic Type" Section
    private func createBasicTypeSection() -> NSCollectionLayoutSection{
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))//fractionalWidth -> 비율로 처리하는것.. 검색해보기
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top:10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    private func createLargeTypeSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension:  .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400) )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        return section
    }
    
    private func createRankTypeSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    //sectionheader layout설정
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        //Section Header Layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
}

// UICollectionView DataSource, Delegate
extension HomeViewController {
    // Section당 보여질 셀의 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = contents[section].sectionType
        if sectionType == .basic || sectionType == .large || sectionType == .rank{
            switch section{
            case 0:
                return 1
            default:
                return contents[section].contentItem.count
            }
        }

        return 0
    }
    
    // CollectionView Cell 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType{
        case .basic, .large:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell()}
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        case .rank:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionRankCell", for: indexPath) as? ContentCollectionRankCell else{
                return UICollectionViewCell()}
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            cell.rankLabel.text = "\(indexPath.row + 1)"
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    // Header view 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else{fatalError("could not dequeue header!!")}
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionName
            return headerView
        }
        return UICollectionReusableView()
    }
    // Section 개수
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    // 셀 터치 이벤트
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let sectionName = contents[section].sectionName
        print("\(sectionName)섹션의 \(row + 1)번째 콘텐츠 선택 됨")
    }
    
}


// MARK: - SwiftUI를 사용한 PreView


struct HomeViewController_PreView: PreviewProvider{
    static var previews: some View{
        Group {
            Container().edgesIgnoringSafeArea(.all)
        }
    }
    struct Container: UIViewControllerRepresentable{
        func makeUIViewController(context: Context) -> UIViewController{
            let layout = UICollectionViewLayout()
            let homeViewController = HomeViewController(collectionViewLayout: layout)
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context){} // 필수 메서드
        typealias UIViewControllerType = UIViewController
    }
}
