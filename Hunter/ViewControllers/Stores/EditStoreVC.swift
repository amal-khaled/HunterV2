//
//  EditStoreVC.swift
//  Hunter
//
//  Created by iOSayed on 31/08/2023.
//

import UIKit
import MOLH

class EditStoreVC: UIViewController {

    static func instantiate()-> EditStoreVC{
        let editStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "EditStoreVC") as! EditStoreVC
        
        return editStoreVC 
    }
    
    
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var changeCoverButton: UIButton!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleNameOfStoreTextField: UITextField!
    @IBOutlet weak var companyNameTextFiled: UITextField!
    @IBOutlet weak var activityTextFiled: UITextField!
    @IBOutlet weak var mobileTextFiled: UITextField!
    
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var aboutCompanyTextFiled: UITextField!
    @IBOutlet weak var regionButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    
    // MARK: - Proprerties
    var cityId = AppDelegate.currentUser.cityId ?? 0
    var countryId = AppDelegate.currentUser.countryId ?? 6
    var cityName = MOLHLanguage.currentAppleLanguage() == "en" ? (AppDelegate.currentUser.citiesNameEn ?? "") : (AppDelegate.currentUser.citiesNameAr ?? "")
    var stateId = AppDelegate.currentUser.regionId ?? 0
    
    var regionName = MOLHLanguage.currentAppleLanguage() == "en" ? (AppDelegate.currentUser.regionsNameEn ?? "") : (AppDelegate.currentUser.regionsNameAr ?? "")
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Methods

    
    private func configureView(){
        self.cityButton.setTitle(cityName, for: .normal)
        self.regionButton.setTitle(regionName, for: .normal)
        profileImageContainerView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    
//    private func setData(){
//
//        companyNameTextFiled.text = AppDelegate.currentUser.username
//        stateId = "\(AppDelegate.currentUser.regionId ?? 0)"
//        cityId = "\(AppDelegate.currentUser.cityId ?? 0)"
////        .text = AppDelegate.currentUser.name
////        txt_lastName.text = AppDelegate.currentUser.name
//        passwordTextFiled.text = "******"
//        e.text = AppDelegate.currentUser.email
//
//                do {
//
//                    let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse("\(AppDelegate.currentUser.phone ?? "")", ignoreType: false)
//
//                    phoneNumber.text = String(phoneNumberCustomDefaultRegion.nationalNumber)
//                    phoneCode.text = String(phoneNumberCustomDefaultRegion.countryCode)                }
//                catch {
//                    let mobile = AppDelegate.currentUser.phone?.dropFirst(3)
////                    order.phoneCode = String(user.mobile.prefix(3))
//                    phoneNumber.text = AppDelegate.currentUser.phone ?? ""
//                    print("Generic parser error")
//                }
//
//
//        upic.setImageWithLoading(url: AppDelegate.currentUser.pic ?? "")
//        bio.text = AppDelegate.currentUser.bio ?? ""
//    }
    // MARK: - IBActions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapChooseCityButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: CITIES_VCIID) as!  CitiesViewController
        vc.countryId = self.countryId
        vc.citiesBtclosure = {
            (city) in
           var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.cityId = city.id ?? 0
            self.cityButton.setTitle(name, for: .normal)
            self.cityName = name
            self.getAreas()
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didTapChooseRegionButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: STATE_VCID) as!  StateViewController
        vc.countryId = self.cityId
        vc.citiesBtclosure = {
            (city) in
           var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.regionButton.setTitle(name, for: .normal)
            self.regionName = name
            self.stateId = city.id ?? -1
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didTapChangeMobileButton(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: Auth_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ChangePhoneVC") as! ChangePhoneVC
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapChangePasswordButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: Auth_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapEditSocialMediaButton(_ sender: UIButton) {
        
        let editSocialMediaVC = EditSocialMediaVC.instantiate()
        
        editSocialMediaVC.modalPresentationStyle = .overFullScreen
        present(editSocialMediaVC, animated: false)
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        
        
    }
    
}

extension EditStoreVC {
    func getAreas(){
        CountryController.shared.getStates(completion: {
            countries, check,msg in
            Constants.STATUS = countries
            if Constants.STATUS.count > 0{
                self.stateId = Constants.STATUS[0].id ?? -1
                self.regionButton.setTitle(MOLHLanguage.currentAppleLanguage() == "en" ? Constants.STATUS[0].nameEn : Constants.STATUS[0].nameAr, for: .normal)
            }
        }, countryId: cityId)
    }
}
