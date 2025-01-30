//
//  FoodDetailViewController+Delegate.swift
//  SwiggyClone
//
//  Created by Dheeraj Kumar Sharma on 12/02/22.
//

import UIKit

extension FoodDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FoodDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = FoodDetailSection(rawValue: section) else { return 0 }
        
        switch section {
        case .banner:
            return 1
        case .restaurants:
            return restaurantListMockData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = FoodDetailSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.ReusableIdentifiers.foodTopBannerId, for: indexPath) as! FoodTopBannerCVCell
            cell.bannerImage.image = UIImage(named: "ic_d_banner")
            cell.bannerImage.layer.cornerRadius = 0
            return cell
            
        case .restaurants:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.ReusableIdentifiers.restaurantListId, for: indexPath) as! RestaurantsListCVCell
            cell.data = restaurantListMockData[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Key.ReusableIdentifiers.foodVCHeaderViewId, for: indexPath) as! FoodFilterHeaderView
        header.delegate = self
        header.title.text = "\(restaurantListMockData.count) restaurants".uppercased()
        return header
    }
    
}


extension FoodDetailViewController: FoodFilterHeaderActionDelegate, FoodDetailNavActionDelegate {
    
    func didBackBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func didFilterBtnTapped() {
        filterLaucher.showFilter()
    }
    
    func configureCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) in
            guard let section = FoodDetailSection(rawValue: sectionNumber) else {
                return nil
            }
            
            switch section {
            case .banner:
                return LayoutType.foodDetailBannerLayout.getLayout()
            case .restaurants:
                return LayoutType.foodListLayout.getLayout(withHeader: true)
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}
