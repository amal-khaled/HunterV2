//
//  HomeDetailsViewController.swift
//  Hunter
//
//  Created by iOSayed on 13/08/2023.
//



import UIKit
import MOLH
import RAMAnimatedTabBarController

class HomeDetailsViewController: UIViewController {
    @IBOutlet weak var ContainerStackView: UIStackView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var subCategoryCollectionView:UICollectionView!
    @IBOutlet weak var mainCategoryCollectionView: UICollectionView!
    @IBOutlet weak var feaureContainerView: UIView!
    @IBOutlet weak var FeaturesCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var subCatigoryContainer: UIView!
    @IBOutlet weak var featureAdsLabel: UILabel!
    
    @IBOutlet weak var productCollectionViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var featuredLabelContainerView: UIView!
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
    var categories = [Category]()
    var selectedCategoryIndex = 0
    var selectedSubCategoryIndex = 0
    var subCategories = [Category]()
    var isComeToFeatureAds = false
    var isComeFromCategory = false
    
    let titleLabel = UILabel()
    private let shimmerView = ProductsShimmerView.loadFromNib()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCountryName(_:)), name: NSNotification.Name("changeCountryName"), object: nil)
        print(categoryId)
        ConfigureView()
        featuredLabelContainerView.isHidden = !isComeToFeatureAds
        feaureContainerView.isHidden = true
        searchTextField.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        self.navigationController?.navigationBar.isHidden = false
        if categoryId == 74 {
            sell = nil
            typeLbl.text = "All".localize
            self.typeView.isHidden = false
        }else{
            self.typeView.isHidden = true
            
        }
        
        countryId = AppDelegate.currentCountry.id ?? 6
        
        countryName = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
        
        if isComeFromCategory {
            handleChoosingCategory()
        }
        
    }
    
    
    //MARK: Methods
    
    private func ConfigureView(){
        customNavView.cornerRadius = 30
        customNavView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.navigationController?.navigationBar.isHidden = false
        //        self.navigationItem.title = "Home".localize
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.chooseCategory(_:)), name: NSNotification.Name(rawValue: "chooseCategory"), object: nil)
        
        FeaturesCollectionView.semanticContentAttribute = .forceLeftToRight
        mainCategoryCollectionView.semanticContentAttribute = .forceLeftToRight
        subCategoryCollectionView.semanticContentAttribute = .forceLeftToRight
        productCollectionView.semanticContentAttribute = .forceLeftToRight
        //        didChangeCountry()
        getCategory()
        createAddAdvsButton()
        searchTextField.setPlaceHolderColor(.white)
        
    }
    
    func createCustomNavBar(){
        customNavView.cornerRadius = 30
        customNavView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
    }
    @objc func leftBarButtonItem1Tapped() {
        // Handle left bar button item 1 tap
        print("Handle left bar button item 1 tap")
    }
    
    @objc func rightBarButtonItem1Tapped() {
        // Handle right bar button item 1 tap
        print("Handle right bar button item 1 tap")
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
        rightView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 20, y: 0, width: rightView.frame.width - 40, height: rightView.frame.height) // Adjust the position and width of the label
        
        let categoryButton = UIButton(type: .custom)
        categoryButton.frame = rightView.bounds
        categoryButton.addTarget(self, action: #selector(didTapChangeCountryButton), for: .touchUpInside)
        
        rightView.addSubview(categoryButton)
        
        let countryButton = UIBarButtonItem(customView: rightView)
        navigationItem.rightBarButtonItems = [countryButton]
        navigationItem.leftBarButtonItems = []
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
    
    @objc func changeCountryName(_ notification:Notification){
        titleLabel.text = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
    }
    
    @objc func didTapChangeCountryButton(){
        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            AppDelegate.currentCountry = country
            self.countryName = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
            //            self.rightButton.setTitle(self.countryName, for: .normal)
            self.titleLabel.text = self.countryName
            self.countryId = country.id ?? 6
            self.cityId = -1
            self.resetProducts()
            self.getData()
        }
        self.present(coountryVC, animated: false, completion: nil)
    }
    
    private func handleChoosingCategory(){
        let categoryIndex = selectedCategoryIndex
        let subcategoryIndex = selectedSubCategoryIndex
        categoryId = categories[categoryIndex].id ?? 0
        print(selectedCategoryIndex)
        print(categoryId)
        subcategoryId = subCategories[subcategoryIndex].id ?? 0
        self.subCategories.insert(Category(nameAr: "الكل", nameEn: "All",id: -1, hasSubCat: 0), at: 0)
        
        mainCategoryCollectionView.reloadData()
        mainCategoryCollectionView.selectItem(at: [0, categoryIndex], animated: true, scrollPosition: .centeredHorizontally)
        self.subCategoryCollectionView.isHidden = false
        self.subCatigoryContainer.isHidden = false
        self.subCategoryCollectionView.reloadData()
        subCategoryCollectionView.selectItem(at: [0, subcategoryIndex + 1], animated: true, scrollPosition: .centeredHorizontally)
        //            // do something with your image
        feaureContainerView.isHidden = true
        
        if categoryId == 74 {
            sell = nil
            typeLbl.text = "All".localize
            self.typeView.isHidden = false
        }else{
            self.typeView.isHidden = true
            
        }
        
        getData()
    }
    
    
    @objc func chooseCategory(_ notification: NSNotification) {
        let categoryIndex = notification.userInfo?["cat_index"] as! Int
        let subcategoryIndex = notification.userInfo?["sub_cat_index"] as! Int
        subCategories = notification.userInfo?["subCategories"] as! [Category]
        categoryId = categories[categoryIndex+1].id ?? 0
        print(categoryId)
        
        subcategoryId = subCategories[subcategoryIndex].id ?? 0
        self.subCategories.insert(Category(nameAr: "الكل", nameEn: "All",id: -1, hasSubCat: 0), at: 0)
        
        mainCategoryCollectionView.selectItem(at: [0, categoryIndex+1], animated: true, scrollPosition: .centeredHorizontally)
        self.subCategoryCollectionView.isHidden = false
        self.subCatigoryContainer.isHidden = false
        self.subCategoryCollectionView.reloadData()
        subCategoryCollectionView.selectItem(at: [0, subcategoryIndex+1], animated: true, scrollPosition: .centeredHorizontally)
        //            // do something with your image
        if categoryId == 74 {
            sell = nil
            typeLbl.text = "All".localize
            self.typeView.isHidden = false
        }else{
            self.typeView.isHidden = true
            
        }
        
        getData()
        
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
    
    
}
extension HomeDetailsViewController{
    
    func updateCollectionViewHeight() {
        productCollectionView.layoutIfNeeded()
        
        let contentHeight = productCollectionView.collectionViewLayout.collectionViewContentSize.height
        productCollectionViewHeightConstraints.constant = contentHeight
    }
    
    func getData(){
        print("Page: ===> ",page)
        
        ContainerStackView.addArrangedSubview(shimmerView)
        ProductController.shared.getHomeProducts(completion: {
            products, check, msg in
            if check == 0{
                self.shimmerView.isHidden = true
                DispatchQueue.main.async {
                    products.forEach({ item in
                        if item.isFeature ?? false {
                            self.featureProducts.append(item)
                            print(self.featureProducts.count)
                        }
                    })
                    if self.isComeToFeatureAds == false && self.featureProducts.count > 0 {
                        print(self.featureProducts.count)
                        self.feaureContainerView.isHidden = false
                        self.FeaturesCollectionView.reloadData()
                    }else {
                        self.products.append(contentsOf: self.featureProducts)
                        self.productCollectionView.reloadData()
                        self.updateCollectionViewHeight()
                    }
                    
                }
                
                if self.page == 1 {
                    self.products.removeAll()
                    if !self.isComeToFeatureAds {
                        self.featureProducts.removeAll()
                        self.products = products
                    }
                    
                    
                }else{
                    if self.isComeToFeatureAds == true {
                        self.products.append(contentsOf: self.featureProducts)
                    }else {
                        self.products.append(contentsOf: products)
                    }
                    
                }
                if products.isEmpty{
                    self.page = self.page == 1 ? 1 : self.page - 1
                    self.isTheLast = true
                }
                
                
                
                print(self.page)
                self.productCollectionView.reloadData()
                self.updateCollectionViewHeight()
                
                
                //                self.FeaturesCollectionView.reloadData()
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
                self.page = self.page == 1 ? 1 : self.page - 1
            }
        }, page: page, countryId: countryId, cityId: cityId, categoryId: categoryId, subCategoryId: subcategoryId, type: 1, sorting: sorting, sell: sell)
    }
    
    func getCategory(){
        CategoryController.shared.getCategoories(completion: {
            categories, check, msg in
            
            self.categories = categories
            //            self.categories.insert(Category(nameAr: "الكل", nameEn: "All",id: -1, hasSubCat: 0), at: 0)
            self.mainCategoryCollectionView.reloadData()
            self.mainCategoryCollectionView.selectItem(at: [0,self.selectedCategoryIndex], animated: false, scrollPosition: .centeredHorizontally)
            
        })
    }
    func getSubCategory(){
        CategoryController.shared.getSubCategories(completion: {
            categories, check, msg in
            self.subCategories.removeAll()
            
            self.subCategories = categories
            print(self.subCategories.count)
            self.subCategories.insert(Category(nameAr: "الكل", nameEn: "All",id: -1, hasSubCat: 0), at: 0)
            
            if categories.count > 0 {
                self.subCatigoryContainer.isHidden = false
                self.subCategoryCollectionView.isHidden = false
            }else{
                self.subCatigoryContainer.isHidden = true
                self.subCategoryCollectionView.isHidden = true
                
            }
            
            self.subCategoryCollectionView.reloadData()
            self.subCategoryCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .centeredHorizontally)
            
        }, categoryId: self.categoryId)
    }
    func resetProducts(){
        self.page = 1
        self.isTheLast = false
        //        self.products.removeAll()
    }
    
    
    func setupIfSelectedMainCategoryCell(for item:Int) {
        self.subcategoryId = -1
        self.categoryId = categories[item].id ?? 0
        if categories[item].hasSubCat == 1{
            getSubCategory()
        }else{
            //                       subCategories.removeAll()
            self.subCatigoryContainer.isHidden = true
            subCategoryCollectionView.isHidden = true
        }
        if categoryId == 74 {
            sell = nil
            typeLbl.text = "All".localize
            self.typeView.isHidden = false
        }else{
            self.typeView.isHidden = true
            
        }
        self.resetProducts()
        self.getData()
    }
    
    
    
}
extension HomeDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
            print(products.count)
            return products.count
        }else if collectionView == mainCategoryCollectionView{
            return categories.count
        }else if collectionView == FeaturesCollectionView {
            //TODO: pass count of feature products
            print(featureProducts.count)
            return featureProducts.count
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
            if products.count > 0 {
                cell.setData(product: products[indexPath.row])
                if self.isComeToFeatureAds == true {
                    cell.featuredImageIcon.isHidden = false
                }else {
                    cell.featuredImageIcon.isHidden = true
                }
            }
            return cell
        }else if collectionView == mainCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat-cell", for: indexPath) as! MainCategoryCollectionViewCell
            cell.setData(category: categories[indexPath.row])
            if indexPath.item == selectedCategoryIndex {
                if !isComeFromCategory {
                    self.setupIfSelectedMainCategoryCell(for: indexPath.item)
                }
                cell.dropDwonImage.isHidden = false
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    
                    // HERE
                    cell.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1) // Scale your image
                    
                }) { (finished) in
                    UIView.animate(withDuration: 0.6, animations: {
                        
                        cell.transform = CGAffineTransform.identity
                        // undo in 1 seconds
                        
                    })
                }
            }
            return cell
        }else if collectionView == FeaturesCollectionView {
            let    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-feature", for: indexPath) as! FeaturesProductsCollectionViewCell
            if featureProducts.count > 0 {
                cell.setData(product: featureProducts[indexPath.item])
            }
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
            return CGSize(width: 90, height: 115)
        }else if collectionView == FeaturesCollectionView {
            return CGSize(width: (UIScreen.main.bounds.width/2)-15, height: 240)
        }else {
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
            let cell = collectionView.cellForItem(at: indexPath)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                // HERE
                cell?.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1) // Scale your image
                
            }) { (finished) in
                UIView.animate(withDuration: 0.6, animations: {
                    
                    cell?.transform = CGAffineTransform.identity // undo in 1 seconds
                    
                })
            }
            self.feaureContainerView.isHidden = true
            self.products.removeAll()
            self.featureProducts.removeAll()
            self.subcategoryId = -1
            self.categoryId = categories[indexPath.row].id ?? 0
            if categories[indexPath.row].hasSubCat == 1{
                getSubCategory()
            }else{
                //                       subCategories.removeAll()
                self.subCatigoryContainer.isHidden = true
                subCategoryCollectionView.isHidden = true
            }
            if categoryId == 74 {
                sell = nil
                typeLbl.text = "All".localize
                self.typeView.isHidden = false
            }else{
                self.typeView.isHidden = true
                
            }
            self.resetProducts()
            self.getData()
            
        }else if collectionView == FeaturesCollectionView {
            
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
            vc.modalPresentationStyle = .fullScreen
            //TODO: pass Product Id of Features ads
            vc.product = featureProducts[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == subCategoryCollectionView{
            self.subcategoryId = subCategories[indexPath.row].id ?? 0
            self.resetProducts()
            self.getData()
            
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        if  !isTheLast && !isComeToFeatureAds{
    //            page+=1
    //            getData()
    //
    //        }
    //    }
}

extension HomeDetailsViewController:UITextFieldDelegate{
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
extension HomeDetailsViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            
            if  !isTheLast && !isComeToFeatureAds{
                page+=1
                getData()
                
            }
        }
    }
}
