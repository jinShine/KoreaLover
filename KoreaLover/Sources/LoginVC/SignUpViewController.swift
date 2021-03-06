//
//  SignUpViewController.swift
//  KoreaLover
//
//  Created by 김승진 on 2018. 8. 30..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signupTitle: UILabel!
    @IBOutlet weak var emailAddressTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextLine: UIView!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextLine: UIView!
    @IBOutlet weak var confirmPasswordTitle: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextLine: UIView!
    @IBOutlet weak var errorContents: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var backBtnTop: NSLayoutConstraint!
    
    private var activityView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInit()
        
        UIApplication.shared.statusBarStyle = .default
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signupAction(_ sender: UIButton) {
        activityView.startAnimating()
        
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    self.activityView.stopAnimating()
                    
                    if error != nil {
                        if let err = error {
                            self.errorContents.text = ((err as NSError).userInfo["NSLocalizedDescription"] as! String)
                        }
                        return
                    }
                    
                    //로그인 화면으로 이동
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        if sender == emailTextField {
            if (sender.text?.count)! > 0 {
                self.emailTextLine.backgroundColor = UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1)
            } else {
                self.emailTextLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            }
        } else if sender == passwordTextField {
            if (sender.text?.count)! > 0 {
                self.passwordTextLine.backgroundColor = UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1)
            } else {
                self.passwordTextLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            }
        } else {
            if (sender.text?.count)! > 0 {
                self.confirmPasswordTextLine.backgroundColor = UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1)
            } else {
                self.confirmPasswordTextLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            }
        }
    }
    
    private func setupInit() {
        setupLocalizedText()
        setupActivityIndicator()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    private func setupLocalizedText() {
        signupTitle.text = NSLocalizedString("LOGIN_SIGNUP", comment: "")
        emailAddressTitle.text = NSLocalizedString("LOGIN_EMAIL_ADDRESS", comment: "")
        passwordTitle.text = NSLocalizedString("LOGIN_PW", comment: "")
        confirmPasswordTitle.text = NSLocalizedString("LOGIN_PW_CONFIRM", comment: "")
        signupBtn.setTitle(NSLocalizedString("LOGIN_SIGNUP", comment: ""), for: UIControlState.normal)
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.ballBeat, color: UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
        self.view.addSubview(activityView)
    }
    
    @objc private func keyboardWillShow(noti: Notification) {
        
        let notiInfo = noti.userInfo! as Dictionary
        let keyboardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height
        
        if self.view.frame.height - errorContents.frame.origin.y < keyboardHeight {
            self.backBtnTop.constant = -keyboardHeight - 30 + (self.view.frame.height - errorContents.frame.origin.y)
        }
        
        UIView.animate(withDuration: notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(noti: Notification) {
        
        let notiInfo = noti.userInfo! as Dictionary
        
        self.backBtnTop.constant = 20
        
        UIView.animate(withDuration: notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    //Email 정규식
    private func validateEmail(email: String) -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    func validatePassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{6,50}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if let email = textField.text {
                if !validateEmail(email: email) {
                    errorContents.text = NSLocalizedString("LOGIN_ERROR_USER_NOT_FOUND", comment: "")
                } else {
                    errorContents.text = ""
                }
            }
        } else if textField == passwordTextField {
            if let password = textField.text {
                if !validatePassword(password: password) {
                    errorContents.text = NSLocalizedString("LOGIN_ERROR_VALID_PASSWORD", comment: "")
                } else {
                    errorContents.text = ""
                }
            }
        } else {
            if let confirmPassword = textField.text,
                let password = passwordTextField.text {
                
                if confirmPassword != password {
                    errorContents.text = NSLocalizedString("LOGIN_ERROR_NOT_MATCH", comment: "")
                } else {
                    errorContents.text = ""
                }
            }
        }
    }
}
