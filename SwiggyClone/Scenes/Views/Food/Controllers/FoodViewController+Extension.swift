//
//  FoodViewController+Extension.swift.swift
//  SwiggyClone
//
//  Created by Dheeraj Kumar Sharma on 29/01/22.
//

import UIKit

extension FoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FoodSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = FoodSection(rawValue: section) else { return 0 }
        
        switch section {
        case .topBanner:
            return foodTopBannerMockData.count
        case .categories:
            return foodCategoryMockData.count
        case .restaurantList:
            return restaurantListMockData.count
        case .suggestions:
            return curatedRestaurantsMockData.count
        case .popularRestaurants:
            return restaurantListMockData.count
        case .veganRestaurants:
            return veganRestaurantMockData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = FoodSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .topBanner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.ReusableIdentifiers.foodTopBannerId, for: indexPath) as! FoodTopBannerCVCell
            cell.data = foodTopBannerMockData[indexPath.row]
            return cell
            
        case .categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.ReusableIdentifiers.foodCategoryId, for: indexPath) as! FoodCategoryCVCell
            cell.data = foodCategoryMockData[indexPath.row]
            return cell
            
        case .suggestions:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.ReusableIdentifiers.foodSuggestionCardId, for: indexPath) as! FoodSuggestionCardCVCell
            cell.data = curatedRestaurantsMockData[indexPath.row]
            return cell
            
        case .veganRestaurants:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.ReusableIdentifiers.restaurantVeganId, for: indexPath) as! RestaurantVeganCVCell
            cell.data = veganRestaurantMockData[indexPath.row]
            return cell
            
        case .restaurantList, .popularRestaurants:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.ReusableIdentifiers.restaurantListId, for: indexPath) as! RestaurantsListCVCell
            cell.data = restaurantListMockData[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = FoodSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        if kind == headerKind {
            switch section {
            case .restaurantList:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Key.ReusableIdentifiers.foodVCHeaderViewId, for: indexPath) as! FoodFilterHeaderView
                header.delegate = self
                return header
                
            case .veganRestaurants:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Key.ReusableIdentifiers.sectionHeaderView2Id, for: indexPath) as! SectionHeaderView_2
                return header
                
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Key.ReusableIdentifiers.sectionHeaderViewId, for: indexPath) as! SectionHeaderView
                return header
            }
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Key.ReusableIdentifiers.sectionFooterViewId, for: indexPath) as! SectionFooterView
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = FoodSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .topBanner:
            let VC = FoodDetailViewController()
            navigationController?.pushViewController(VC, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FoodTopBannerCVCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.bannerImage.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FoodTopBannerCVCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.bannerImage.transform = .identity
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if abs(yOffset) > 350.0 {
            filterHeaderView.isHidden = false
            filterHeaderView.isStickHeader = true
        } else {
            filterHeaderView.isHidden = true
            filterHeaderView.isStickHeader = false
        }
    }
    
}

extension FoodViewController {
    
    func configureCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) in
            guard let section = FoodSection(rawValue: sectionNumber) else {
                return nil
            }
            
            switch section {
            case .topBanner:
                return LayoutType.headerLayout.getLayout()
            case .categories:
                return LayoutType.foodCategoryLayout.getLayout()
            case .restaurantList:
                return LayoutType.foodListLayout.getLayout()
            case .suggestions:
                return LayoutType.suggestionSectionLayout.getLayout()
            case .veganRestaurants:
                return LayoutType.veganSectionLayout.getLayout()
            case .popularRestaurants:
                return LayoutType.foodListLayout.getLayout(withHeader: false)
            }
        }
        
        layout.register(SectionDecorationView.self, forDecorationViewOfKind: sectionBackground)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}
