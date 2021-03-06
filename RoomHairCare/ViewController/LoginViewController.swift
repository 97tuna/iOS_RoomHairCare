//
//  ViewController.swift
//  RoomDentist
//
//  Created by LDH on 2021/07/22.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    var tokens = [NSObjectProtocol]()
    
    lazy var mainLogoImage: UIImageView = {
        let mainLogoImage = UIImageView()
        mainLogoImage.contentMode = .scaleAspectFill
        mainLogoImage.image = .init(named: "FullRoomHairCare.png")
        return mainLogoImage
    }()
    
    lazy var EmailTextBox: UIImageView = {
        let EmailTextBox = UIImageView()
        EmailTextBox.image = UIImage(named: "Box.png")
        return EmailTextBox
    }()
    
    lazy var EmailTextField: UITextField = {
        let EmailTextField = UITextField()
        EmailTextField.placeholder = "Email"
        EmailTextField.setPlaceholderColor(UIColor(named: "Brown")!)
        EmailTextField.keyboardType = .emailAddress
        EmailTextField.textColor = UIColor(named: "Brown")!
        EmailTextField.font = UIFont(name: "GmarketSansBold", size: CGFloat(17))
        EmailTextField.autocapitalizationType = .none
        EmailTextField.autocorrectionType = .no
        EmailTextField.delegate = self
        return EmailTextField
    }()
    
    lazy var PwTextBox: UIImageView = {
        let EmailTextBox = UIImageView()
        EmailTextBox.image = UIImage(named: "Box.png")
        return EmailTextBox
    }()
    
    lazy var PwTextField: UITextField = {
        let PwTextField = UITextField()
        PwTextField.placeholder = "Password"
        PwTextField.setPlaceholderColor(UIColor(named: "Brown")!)
        PwTextField.textColor = .black
        PwTextField.font = UIFont(name: "GmarketSansBold", size: CGFloat(17))
        PwTextField.autocapitalizationType = .none
        PwTextField.autocorrectionType = .no
        PwTextField.isSecureTextEntry = true
        PwTextField.delegate = self
        return PwTextField
    }()
    
    lazy var FindPwButton: UIButton = {
        let FindPwButton = UIButton()
        FindPwButton.backgroundColor = .clear
        FindPwButton.setTitleColor(UIColor(named: "Brown"), for: .normal)
        FindPwButton.setTitle("???????????? ??????", for: .normal)
        FindPwButton.titleLabel?.font = UIFont(name: "GmarketSansMedium", size: CGFloat(13))
        return FindPwButton
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = .systemGray6
        loginButton.setTitleColor(.systemGray, for: .disabled)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitle("?????????", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "GmarketSansBold", size: CGFloat(17))
        return loginButton
    }()
    
    lazy var joinButton: UIButton = {
        let joinButton = UIButton()
        joinButton.layer.cornerRadius = 10
        joinButton.backgroundColor = .clear
        joinButton.setTitle("????????? ???????????????? ????????? ?????? ????????????", for: .normal)
        joinButton.setTitleColor(UIColor(named: "Brown"), for: .normal)
        joinButton.titleLabel?.font = UIFont(name: "GmarketSansMedium", size: CGFloat(15))
        return joinButton
    }()
    
    lazy var appleLoginButton: UIButton = {
        let appleLoginButton = UIButton()
        appleLoginButton.setImage(UIImage(named: "Apple.png"), for: .normal)
        return appleLoginButton
    }()
    
    lazy var googleLoginButton: UIButton = {
        let googleLoginButton = UIButton()
        googleLoginButton.setImage(UIImage(named: "Google.png"), for: .normal)
//        googleLoginButton.addTarget(self, action: #selector(loginGoogle), for: .touchUpInside)
        return googleLoginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadUser() // ????????? ?????? ???????????? ????????? ConfigureUI() ??????
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        loginButton.addTarget(self, action: #selector(moveMainView), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(moveJoinView), for: .touchUpInside)
        FindPwButton.addTarget(self, action: #selector(moveResetIDView), for: .touchUpInside)
    }

    // MARK: Action
    @objc func moveJoinView() {
        performSegue(withIdentifier: "JoinSegue", sender: nil)
    }
    
    @objc func moveResetIDView() {
        performSegue(withIdentifier: "ResetSegue", sender: nil)
    }
    
    @objc func moveMainView() {
        checkSign()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    @objc func loginGoogle() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
//
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
//                return
//            }
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
//
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                if error != nil {
//                    if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
//                        switch ErrorCode {
//                        case AuthErrorCode.operationNotAllowed:
//                            self.showAlert(message: "???????????? ?????? ?????? ?????????")
//                        case AuthErrorCode.userDisabled:
//                            self.showAlert(message: "????????? ???????????????. ??????????????? ??????????????????")
//                        case AuthErrorCode.invalidEmail:
//                            self.showAlert(message: "???????????? ???????????? ????????? ?????????")
//                        case AuthErrorCode.wrongPassword:
//                            self.showAlert(message: "??????????????? ???????????????.")
//                        default:
//                            self.showAlert(message: "????????? ?????? ??????????????? ???????????? ????????? ?????????")
//                        }
//                    }
//                } else {
//                    let db = Database.database().reference()
//                    let uid = Auth.auth().currentUser?.uid
//                    let dataMap = [
//                        "username": user.profile.name,
//                        "email": user.profile.email,
//                        "birth": user.profile.,
//                        "gender": genderText.text
//                    ]
//                    db.child("users").child(uid!).setValue(dataMap)
//                    self.pushNavigationControllerToMain()
//                }
//            }
//        }
//    }
    
    func configureUI() {
        self.view.addSubview(self.mainLogoImage)
        self.view.addSubview(self.EmailTextBox)
        self.view.addSubview(self.EmailTextField)
        self.view.addSubview(self.PwTextBox)
        self.view.addSubview(self.PwTextField)
        self.view.addSubview(self.FindPwButton)
        self.view.addSubview(self.loginButton)
        self.view.addSubview(self.joinButton)
        self.view.addSubview(self.appleLoginButton)
        self.view.addSubview(self.googleLoginButton)
        
        self.mainLogoImage.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            $0.size.height.equalTo(self.view.safeAreaLayoutGuide.snp.height).multipliedBy(0.25)
        }
        
        self.EmailTextBox.snp.makeConstraints {
            $0.top.equalTo(self.mainLogoImage.snp.bottom).offset(20)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
            $0.height.equalTo(58)
        }
        
        self.EmailTextField.snp.makeConstraints {
            $0.centerY.equalTo(self.EmailTextBox.snp.centerY)
            $0.centerX.equalTo(self.EmailTextBox.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(40)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(40)
        }
        
        self.PwTextBox.snp.makeConstraints {
            $0.top.equalTo(self.EmailTextBox.snp.bottom).offset(10)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
            $0.height.equalTo(58)
        }
        
        self.PwTextField.snp.makeConstraints {
            $0.centerY.equalTo(self.PwTextBox.snp.centerY)
            $0.centerX.equalTo(self.PwTextBox.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(40)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(40)
        }
        
        self.FindPwButton.snp.makeConstraints {
            $0.top.equalTo(self.PwTextBox.snp.bottom).offset(0)
            $0.right.equalTo(self.PwTextBox.snp.right).inset(0)
        }
        
        self.loginButton.snp.makeConstraints {
            $0.top.equalTo(self.PwTextBox.snp.bottom).offset(45)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(22)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(22)
            $0.height.equalTo(54)
        }
        
        self.joinButton.snp.makeConstraints {
            $0.top.equalTo(self.loginButton.snp.bottom).offset(15)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(22)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(22)
            $0.height.equalTo(54)
        }
        
        self.appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.googleLoginButton.snp.top).offset(-5)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
        }
        
        self.googleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view).inset(20)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
        }
    }
}

extension LoginViewController {
    func showAlert(message:String){
        let alert = UIAlertController(title: "????????? ??????",message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "??????", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkSign() {
        view.endEditing(true)
        
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PwTextField.text!) { [weak self] authResult, error in
            if error != nil {
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch ErrorCode {
                    case AuthErrorCode.operationNotAllowed:
                        self?.showAlert(message: "???????????? ?????? ?????? ?????????")
                    case AuthErrorCode.userDisabled:
                        self?.showAlert(message: "????????? ???????????????. ??????????????? ??????????????????")
                    case AuthErrorCode.invalidEmail:
                        self?.showAlert(message: "???????????? ???????????? ????????? ?????????")
                    case AuthErrorCode.wrongPassword:
                        self?.showAlert(message: "??????????????? ???????????????.")
                    default:
                        self?.showAlert(message: "????????? ?????? ??????????????? ???????????? ????????? ?????????")
                    }
                }
            } else{
                self?.pushNavigationControllerToMain()
            }
        }
    }
    
    // MARK: ????????? ????????? ?????? ????????????
    func reloadUser(_ callback: ((Error?) -> ())? = nil){
        let status = Auth.auth().currentUser?.reload(completion: { (error) in
            if error != nil{
                self.configureUI()
                self.showAlert(message: "????????? ????????? ?????????????????????. ?????? ?????????????????????")
            } else {
                self.pushNavigationControllerToMain()
                self.configureUI()
            }
        })
        if status == nil {
            self.configureUI()
        }
    }
    
    func pushNavigationControllerToMain() {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(pushVC!, animated: false)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // MARK: return ??? ????????? ?????? (????????? + ???????????? 4?????? ?????? ????????? ?????????, ????????????)
        
        let IdCount = EmailTextField.text?.count ?? 0
        let PwCount = PwTextField.text?.count ?? 0
        
        if IdCount > 4 && PwCount > 4 {
            textField.resignFirstResponder()
            checkSign()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.count > 0 { // ?????? ??????
            guard string.rangeOfCharacter(from: charSet) == nil else {
                return false
            } // nil??? ????????? ??????, ????????? ?????? ????????? ????????? ????????? ?????????
        }
        
        let IdFinalText = NSMutableString(string: EmailTextField.text ?? "") // ????????? ???????????? ?????? ?????????
        let PwFinalText = NSMutableString(string: PwTextField.text ?? "") // ????????? ???????????? ?????? ?????????
        
        if textField == EmailTextField {
            IdFinalText.replaceCharacters(in: range, with: string)
        } else {
            PwFinalText.replaceCharacters(in: range, with: string)
        }

        if IdFinalText.length > 4 && PwFinalText.length > 4 {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemYellow
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .systemGray6
        }
        
        return true
    }
}

// MARK: TextFields Placeholder ?????? ??????
public extension UITextField {
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}
