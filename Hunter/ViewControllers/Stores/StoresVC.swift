//
//  StoresVC.swift
//  Hunter
//
//  Created by iOSayed on 24/08/2023.
//

import UIKit
import FSPagerView
import MOLH
import WoofTabBarController

class StoresVC: UIViewController {
    static func instantiate()->StoresVC{
        let controller = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier:"StoresVC" ) as! StoresVC
        return controller
    }
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }


    let titleLabel = UILabel()
    var coountryVC = CounriesViewController()
    var countryName = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
    var countryId = AppDelegate.currentCountry.id ?? 6
    var cityId = -1
    var storesList = [StoreObject]()
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        pagerView.delegate = self
        pagerView.dataSource = self
        getStores()
        
        customNavView.cornerRadius = 30
        customNavView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        createChangeCountryButton()
            searchTextField.setPlaceHolderColor(.white)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func createChangeCountryButton(){
        //MARK: Right Button
        
         let rightView = UIView()
        rightView.backgroundColor = .white
        rightView.frame = CGRect(x: 0, y: 0, width: 130, height: 30) // Increase the width

        let cornerRadius: CGFloat = 16.0
        rightView.layer.cornerRadius = cornerRadius // Apply corner radius

        let dropDownImage = UIImageView(image: UIImage(named: "dropDownIcon")?.withRenderingMode(.alwaysOriginal))
        dropDownImage.contentMode = .scaleAspectFill
        dropDownImage.frame = CGRect(x: 10 , y: 10, width: 14, height: 10) // Adjust the position and size of the image

        rightView.addSubview(dropDownImage)

        let locationImage = UIImageView(image: UIImage(named: "locationBlack")?.withRenderingMode(.alwaysOriginal))
        locationImage.contentMode = .scaleAspectFill
        locationImage.frame = CGRect(x: rightView.frame.width - 25, y: 10, width: 14, height: 10) // Adjust the position and size of the image

        rightView.addSubview(locationImage)
        
        titleLabel.text = countryName // Assuming you have a "localized" method for localization
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        rightView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 20, y: 0, width: rightView.frame.width - 40, height: rightView.frame.height) // Adjust the position and width of the label
        
        let categoryButton = UIButton(type: .custom)
        categoryButton.frame = rightView.bounds
        categoryButton.addTarget(self, action: #selector(categoryBtnAction), for: .touchUpInside)

        rightView.addSubview(categoryButton)

        let countryButton = UIBarButtonItem(customView: rightView)
        navigationItem.rightBarButtonItems = [countryButton]
        navigationItem.leftBarButtonItems = []
    }
    
    @objc func categoryBtnAction(){
        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            AppDelegate.currentCountry = country
            self.countryName = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
//            self.rightButton.setTitle(self.countryName, for: .normal)
            self.titleLabel.text = self.countryName
            self.countryId = country.id ?? 6
            self.cityId = -1
//            self.resetProducts()
//            self.getData()
        }
        self.present(coountryVC, animated: false, completion: nil)
    }
    //MARK: IBActions
    
    @IBAction func didTapCreateStoreButton(_ sender: UIButton) {
        let addStoreVC = CreateStoreVC.instantiate()
        navigationController?.pushViewController(addStoreVC, animated: true)
        
    }
    
}

//MARK: UICollectionView DataSource
extension StoresVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return storesList.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCollectionViewCell", for: indexPath) as? StoreCollectionViewCell else {return UICollectionViewCell()}
         cell.setData(store: storesList[indexPath.item])
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2)-10, height: 175)
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let storeProfile = StoreProfileVC.instantiate()
         storeProfile.otherUserId = storesList[indexPath.item].userID ?? 0
         storeProfile.countryId = storesList[indexPath.item].countryID ?? 6
         navigationController?.pushViewController(storeProfile, animated: true)
    }
    
}

extension StoresVC:FSPagerViewDelegate , FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cell.imageView?.image = UIImage(named: "about_hdr")
            return cell
    }


}

extension StoresVC {
    func getStores(){
        ProductController.shared.getStores(completion: { stores, check, message in
            if check == 0{
                print(stores.count)
                self.storesList.removeAll()
                self.storesList.append(contentsOf: stores)
                self.CollectionView.reloadData()
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, countryId: countryId)
    }
}
extension StoresVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Perform the segue when the Return key is pressed
        let vc = UIStoryboard(name: SEARCH_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "search") as! SearchViewController
        if searchTextField.text.safeValue != "" {
            vc.searchText = searchTextField.text!
            navigationController?.pushViewController(vc, animated: true)
        }else{
            StaticFunctions.createErrorAlert(msg: "Please type in anything you want to search for in Hunter".localize)
        }
       
            return true
        }
}
extension StoresVC:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {
    
    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Commercial".localize, image: "storeIconGray", selectedImage: "storeButtonIcon")
    }
}
