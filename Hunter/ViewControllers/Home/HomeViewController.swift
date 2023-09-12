//
//  HomeViewController.swift
//  Hunter
//
//  Created by Amal Elgalant on 25/04/2023.
//

import UIKit
import MOLH
import WoofTabBarController
//import RAMAnimatedTabBarController

class HomeViewController: UIViewController {
    
    static func instantiate()->HomeViewController{
        let controller = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"home") as! HomeViewController
        return controller
    }
    
    
    
    
    @IBOutlet weak var ContainerStackView: UIStackView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var mainCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var featureContainerView: UIView!
    
    @IBOutlet weak var FeaturesCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var storeCollectionView: UICollectionView!
    
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var gridBtn: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var coountryVC = CounriesViewController()
    var countryId = AppDelegate.currentCountry.id ?? 6
    var countryName = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
    var categoryId = -1
    var subcategoryId = -1
    var page = 1
    var isTheLast = false
    var sell:Int?
    var sorting = "newest"
    var cityName = "choose city"
    var cityId = -1
    var isList = false
    var products = [Product]()
    var featureProducts = [Product]()
    var storesList = [StoreObject]()
    var categories = [Category]()
    var subCategories = [Category]()
    
    let titleLabel = UILabel()
    
    private let shimmerView = ProductsShimmerView.loadFromNib()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        ConfigureView()
        configureNavButtons()
        navigationController?.navigationBar.tintColor = UIColor.green // Change to your desired text color
        print(navigationController)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
        print(navigationController)

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
//        if categoryId == 1 {
//            sell = nil
//            typeLbl.text = "All".localize
//            self.typeView.isHidden = false
//        }else{
//            self.typeView.isHidden = true
//
//        }
       
        countryId = AppDelegate.currentCountry.id ?? 6
        
         countryName = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
//        countryLbl.text = countryName
        getData()
        getFeatureData()
        getStores()
    }
    
    
    
   
    //MARK: Methods
    
    private func ConfigureView(){
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        customNavView.cornerRadius = 30
        customNavView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.navigationController?.navigationBar.isHidden = false
//        self.navigationItem.title = "Home".localize

//        NotificationCenter.default.addObserver(self, selector: #selector(self.chooseCategory(_:)), name: NSNotification.Name(rawValue: "chooseCategory"), object: nil)

        FeaturesCollectionView.semanticContentAttribute = .forceLeftToRight
        mainCategoryCollectionView.semanticContentAttribute = .forceLeftToRight
//        didChangeCountry()
        getCategory()
        createAddAdvsButton()
        searchTextField.setPlaceHolderColor(.white)
    }
    
    func createCustomNavBar(){
        customNavView.cornerRadius = 30
        customNavView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
 
    
    func createAddAdvsButton(){
        
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
        titleLabel.adjustsFontSizeToFitWidth = true
        rightView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 30, y: 0, width: rightView.frame.width - 60, height: rightView.frame.height ) // Adjust the position and width of the label
             let categoryButton = UIButton(type: .custom)
     //        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 20,bottom: 0,right:20)
        categoryButton.frame = rightView.bounds
        categoryButton.addTarget(self, action: #selector(categoryBtnAction), for: .touchUpInside)

        rightView.addSubview(categoryButton)

        let countryButton = UIBarButtonItem(customView: rightView)
        navigationItem.leftBarButtonItems = [countryButton]
    }
    
    @objc func addAdvsBtnAction(){
        if StaticFunctions.isLogin() {
            let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: ADDADVS_VCID) as! AddAdvsVC
            vc.modalPresentationStyle = .fullScreen
//            presentDetail(vc)
            vc.isFromHome = true
            navigationController?.pushViewController(vc, animated: true)
        }else{
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Uplaod ads!".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
        }
        
      
    }
    
    @objc func categoryBtnAction(){
//        basicNavigation(storyName: CATEGORRY_STORYBOARD, segueId: CATEGORIES_VCID)
        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            AppDelegate.currentCountry = country
            self.countryName = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
//            self.rightButton.setTitle(self.countryName, for: .normal)
            self.titleLabel.text = self.countryName
            self.countryId = country.id ?? 6
            self.cityId = -1
            self.featureContainerView.isHidden = true
            self.resetProducts()
            self.getData()
            self.getFeatureData()
            
        }
        self.present(coountryVC, animated: false, completion: nil)
    }
    
    @objc func chooseCategory(_ notification: NSNotification) {
//        let categoryIndex = notification.userInfo?["cat_index"] as! Int
//        let subcategoryIndex = notification.userInfo?["sub_cat_index"] as! Int
//        subCategories = notification.userInfo?["subCategories"] as! [Category]
//        categoryId = categories[categoryIndex+1].id ?? 0
//        print(categoryId)
//
//        subcategoryId = subCategories[subcategoryIndex].id ?? 0
//        self.subCategories.insert(Category(nameAr: "الكل", nameEn: "All",id: -1, hasSubCat: 0), at: 0)
//
//        mainCategoryCollectionView.selectItem(at: [0, categoryIndex+1], animated: true, scrollPosition: .centeredHorizontally)
////        self.subCategoryCollectionView.isHidden = false
////        self.subCategoryCollectionView.reloadData()
////        subCategoryCollectionView.selectItem(at: [0, subcategoryIndex+1], animated: true, scrollPosition: .centeredHorizontally)
////            // do something with your image
//        if categoryId == 1 {
//            sell = nil
//            typeLbl.text = "All".localize
//            self.typeView.isHidden = false
//        }else{
//            self.typeView.isHidden = true
//
//        }
//        getData()
    }
    
    //MARK: IBActions
    
    @IBAction func filterAction(_ sender: Any) {
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: CITY_VCIID) as!  CityViewController
        vc.countryId = countryId
        vc.cityId = cityId
        vc.cityName = cityName
        vc.cityBtclosure = {
            (value, name) in
            self.cityId = value
            self.resetProducts()
            self.getData()
        }
        self.present(vc, animated: false, completion: nil)
        
        
    }
    
    @IBAction func cateegoriesAction(_ sender: Any) {
        basicNavigation(storyName: CATEGORRY_STORYBOARD, segueId: CATEGORIES_VCID)
    }
    @IBAction func sortActioon(_ sender: Any) {
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: SORT_VCID) as!  SortViewController
        vc.type = self.sorting
        vc.sortBtclosure = {
            (value) in
            self.sorting = value
            self.resetProducts()
            self.getData()
        }
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func typeActiion(_ sender: Any) {
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: TYPE_VCID) as!  TypeViewController
        vc.typeBtclosure = {
            (value, name) in
            self.sell = value
            self.typeLbl.text = name
            self.resetProducts()
            self.getData()
        }
        self.present(vc, animated: false, completion: nil)
        
    }
    @IBAction func countryAction(_ sender: Any) {

        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            AppDelegate.currentCountry = country
//            self.countryLbl.text = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
            self.countryId = country.id ?? 6
            self.cityId = -1

            self.resetProducts()
            self.getData()
        }
        self.present(coountryVC, animated: false, completion: nil)
    }
    @IBAction func goLogin(_ sender: Any) {
//        basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
    }
    @IBAction func gridAction(_ sender: Any) {
        isList = false
        gridBtn.tintColor = UIColor(named: "#0093F5")
        listBtn.tintColor = UIColor(named: "#929292")
        DispatchQueue.main.async {
            self.productCollectionView.reloadData()
        }
    }
    @IBAction func categoriesAction(_ sender: Any) {
        
    }
    @IBAction func ListAction(_ sender: Any) {
        isList = true
        listBtn.tintColor = UIColor(named: "#0093F5")
        gridBtn.tintColor = UIColor(named: "#929292")
        DispatchQueue.main.async {
            self.productCollectionView.reloadData()
        }
    }
    
    //More Feature Ads
    
    @IBAction func didTapMoreFeatureAds(_ sender: UIButton) {
        let homeDetailsVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "homeDetails") as! HomeDetailsViewController
        homeDetailsVC.selectedCategoryIndex = 0
        homeDetailsVC.categoryId = categories[0].id ?? 0
        homeDetailsVC.isComeToFeatureAds = true
        homeDetailsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(homeDetailsVC, animated: true)
    }
    
    //More Most recent Ads
    @IBAction func didTapMoreMostRecentAds(_ sender: UIButton) {
        let homeDetailsVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "homeDetails") as! HomeDetailsViewController
        homeDetailsVC.selectedCategoryIndex = 0
        homeDetailsVC.categoryId = categories[0].id ?? 0
        homeDetailsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(homeDetailsVC, animated: true)
    }
    
    @IBAction func didTapMoreStores(_ sender: UIButton) {
        
        tabBarController?.selectedIndex = 2
    }
}
extension HomeViewController{
    
//    private func loading(isloading loading:Bool){
//        self.view.alpha = loading ?  0.4 : 1
//    }
    
    func getFeatureData(){
        ProductController.shared.getHomeFeatureProducts(completion: { featureProducts, check, message in
            if check == 0{
                print(featureProducts.count)
                self.featureProducts = featureProducts
                if featureProducts.count > 0 {
                    self.featureContainerView.isHidden = false
                }else{
                    self.featureContainerView.isHidden = true
                }
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, countryId: countryId)
    }
    
    
    
    func getData(){
        ContainerStackView.addArrangedSubview(shimmerView)
        ProductController.shared.getHomeProducts(completion: {
            products, check, msg in
            if check == 0{
                self.shimmerView.isHidden = true
                if self.page == 1 {
                    self.products.removeAll()
                    self.products = products
                    
                }else{
                    self.products.append(contentsOf: products)
                }
                if products.isEmpty{
                    self.page = self.page == 1 ? 1 : self.page - 1
                    self.isTheLast = true
                }
                self.productCollectionView.reloadData()
                self.FeaturesCollectionView.reloadData()
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
                self.page = self.page == 1 ? 1 : self.page - 1
            }
        }, page: page, countryId: countryId, cityId: cityId, categoryId: categoryId, subCategoryId: subcategoryId, type: 1, sorting: sorting, sell: sell)
    }
    
    func getStores(){
        ProductController.shared.getStores(completion: { stores, check, message in
            if check == 0{
                print(stores.count)
                self.storesList.removeAll()
                self.storesList.append(contentsOf: stores)
                self.storeCollectionView.reloadData()
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, countryId: countryId)
    }
    
    
    func getCategory(){
        CategoryController.shared.getCategoories(completion: {
            categories, check, msg in
            
            self.categories = categories
//            self.categories.insert(Category(nameAr: "الكل", nameEn: "All",id: -1, hasSubCat: 0), at: 0)
            self.mainCategoryCollectionView.reloadData()
            self.mainCategoryCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .centeredHorizontally)
            
        })
    }
    func getSubCategory(){
        CategoryController.shared.getSubCategories(completion: {
            categories, check, msg in
            self.subCategories.removeAll()
            
            self.subCategories = categories
            self.subCategories.insert(Category(nameAr: "الكل", nameEn: "All",id: -1, hasSubCat: 0), at: 0)
            
            if categories.count > 0 {
//                self.subCategoryCollectionView.isHidden = false
            }else{
//                self.subCategoryCollectionView.isHidden = true
                
            }
            
//            self.subCategoryCollectionView.reloadData()
//            self.subCategoryCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .centeredHorizontally)
            
        }, categoryId: self.categoryId)
    }
    func resetProducts(){
        self.page = 1
        self.isTheLast = false
        //        self.products.removeAll()
    }
    
    
}
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
          return products.count >= 10 ? 10 : products.count
        }else if collectionView == mainCategoryCollectionView{
            return categories.count
        }else if collectionView == FeaturesCollectionView {
            //TODO: pass count of feature products
            return featureProducts.count
        }else if collectionView == storeCollectionView {
            return storesList.count
        }
        return subCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView{
            
            var cell: ProductCollectionViewCell
            if isList{
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-tableview", for: indexPath) as! ProductCollectionViewCell
            }else{
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-grid", for: indexPath) as! ProductCollectionViewCell
            }
            cell.setData(product: products[indexPath.row])
            return cell
        }else if collectionView == mainCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat-cell", for: indexPath) as! MainCategoryCollectionViewCell
            cell.setData(category: categories[indexPath.row])
            return cell
        }else if collectionView == FeaturesCollectionView {
         let    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-feature", for: indexPath) as! FeaturesProductsCollectionViewCell
            cell.setData(product: featureProducts[indexPath.item])
            return cell
        }else if collectionView == storeCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStoreCollectionViewCell", for: indexPath) as! HomeStoreCollectionViewCell
            // pass data
            cell.setData(from: storesList[indexPath.item])
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sub-cell", for: indexPath) as! SubCategoryCollectionViewCell
            cell.setData(category: subCategories[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView{
            if isList{
                return CGSize(width: UIScreen.main.bounds.width-10, height: 130)
            }else{
                print((UIScreen.main.bounds.width/2 )-15)
                return CGSize(width: (UIScreen.main.bounds.width/2)-15, height: 280)
            }
        }else if collectionView == mainCategoryCollectionView {
            return CGSize(width: 90, height: 100)
        }else if collectionView == FeaturesCollectionView {
            return CGSize(width: (UIScreen.main.bounds.width/2), height: 240)
        }else if collectionView == storeCollectionView {
            return CGSize(width: (UIScreen.main.bounds.width)/1.5, height: 180)
        }
        else {
            return CGSize(width: 108, height: 35)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView{
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
            vc.modalPresentationStyle = .fullScreen
            vc.product = products[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
//            presentDetail(vc)
        }
        else if collectionView == mainCategoryCollectionView{
            
            // go to HomeDetailsViewController
            let selectedIndex = indexPath.item
            print(selectedIndex)
            let homeDetailsVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "homeDetails") as! HomeDetailsViewController
            homeDetailsVC.selectedCategoryIndex = selectedIndex
            homeDetailsVC.categoryId = categories[selectedIndex].id ?? 0
            homeDetailsVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(homeDetailsVC, animated: true)
            
            
        }else if collectionView == FeaturesCollectionView {
            
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
            vc.modalPresentationStyle = .fullScreen
            //TODO: pass Product Id of Features ads
            vc.product = featureProducts[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == storeCollectionView{
            let storeProfile = StoreProfileVC.instantiate()
            storeProfile.otherUserId = storesList[indexPath.item].userID ?? 0
            storeProfile.countryId = storesList[indexPath.item].countryID ?? 6
            navigationController?.pushViewController(storeProfile, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (products.count-1) && !isTheLast{
            page+=1
            getData()
            
        }
    }
}
class RTLCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return  MOLHLanguage.currentAppleLanguage() == "en" ? false: true
    }
    
    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        return MOLHLanguage.currentAppleLanguage() == "en" ? UIUserInterfaceLayoutDirection.leftToRight: UIUserInterfaceLayoutDirection.rightToLeft
    }
}


extension HomeViewController {
    
    //MARK: Methods to create custom Navigation Bar and bar items
    
    private func createButtonWithImage(_ image: UIImage?, selector: Selector) -> UIButton {
            let button = UIButton(type: .system)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: selector, for: .touchUpInside)
            
            // Adjust the spacing between the buttons (modify the insets as needed)
            let spacing: CGFloat = 8.0
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
            
            return button
        }
    
    private func configureNavButtons(){
        // Create images
            let image1 = UIImage(named: "chatIcon 1")
            let image2 = UIImage(named: "notificationn 1")
        
        let chatButton = UIButton(type: .custom)
        chatButton.frame = CGRect(x: 0.0, y: 0.0, width: 25, height: 25)
        chatButton.setImage(UIImage(named:"chatIcon 1"), for: .normal)
        chatButton.addTarget(self, action: #selector(didTapChatButton), for: UIControl.Event.touchUpInside)

           let chatBarItem = UIBarButtonItem(customView: chatButton)
        
        let notificationButton = UIButton(type: .custom)
        notificationButton.frame = CGRect(x: 0.0, y: 0.0, width: 25, height: 25)
        notificationButton.setImage(UIImage(named:"notificationn 1"), for: .normal)
        notificationButton.addTarget(self, action: #selector(didTapNotificationButton), for: UIControl.Event.touchUpInside)

           let notificationBarItem = UIBarButtonItem(customView: notificationButton)
        
            
            // Create buttons with images
//               let chatButton = UIBarButtonItem(customView: createButtonWithImage(image1, selector: #selector(didTapChatButton)))
//
//               let notificationButton = UIBarButtonItem(customView: createButtonWithImage(image2, selector: #selector(didTapNotificationButton)))
//        notificationButton.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)

            // Add buttons to the right side of the navigation bar
            navigationItem.rightBarButtonItems = [notificationBarItem,chatBarItem]
    }
   
    @objc private func didTapChatButton() {
        // Handle chat  tap
        print("Chat")
        let messagesVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "msgsv") as! msgsC
        messagesVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    @objc private func didTapNotificationButton() {
        // Handle notification  tap
        print("Notifications")
        let notificationsVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
        notificationsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    }

extension HomeViewController:UITextFieldDelegate{
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

extension HomeViewController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {
    
    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Home".localize, image: "home", selectedImage: "HomeButtonIcon",notificationCount: 3)
    }
}
