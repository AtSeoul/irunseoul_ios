//
//  LoginViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 14/04/2017.
//
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        setupUI()
    }

    // MARK: - IBActions
    
    
    @IBAction func didClickLogin(_ sender: UIButton) {
        
        if let user_email = userEmailTextField.text, let password = userPasswordTextField.text  {
        
            HUD.show(.progress)
            
            FIRAuth.auth()?.signIn(withEmail: user_email, password: password) { (user, error) in
                
                guard let user = user, error == nil else {
                    print("error : \(error!.localizedDescription)")
                    HUD.flash(.error, delay: 1.0) { finished in
                        
                        self.showLoginAlert(message: error!.localizedDescription)
                    }
                    return
                }
                
                
                self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // Check if user already exists
                    guard !snapshot.exists() else {
                        HUD.flash(.success, delay: 1.0) { finished in
                            
                            self.navigationController!.popViewController(animated: true)
                        }
                        return
                    }
                    
                    // Otherwise, create new user object
                    
                    let username = user.email!.components(separatedBy: "@")[0]
                    self.ref.child("users").child(user.uid).setValue(["username": username, "email": user.email!])
                })
                
                HUD.flash(.success, delay: 1.0) { finished in
                    
                    self.navigationController!.popViewController(animated: true)
                }

            }
            
        }
        
    }
    
    func resetPassword() {
    
        FIRAuth.auth()?.sendPasswordReset(withEmail: "") { (error) in
            
                if let error = error {
                    self.showLoginAlert(message: error.localizedDescription)
                    return
                }
    
            
        }
    }
    
    // MARK: - UITextField Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if( textField == userEmailTextField ) {
            
            textField.resignFirstResponder()
            userPasswordTextField.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
        }
        return true
        
    }

    
    // MARK: - Helpers
    
    func showLoginAlert(message: String) {
        
        let title = NSLocalizedString("Error", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { action in
            print("cancel button clicked")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    

    
    func setupUI() {
        
         self.navigationController?.navigationBar.isHidden = false

        
        userEmailTextField.returnKeyType = .next
        userEmailTextField.clearButtonMode = .never
        userEmailTextField.keyboardType = UIKeyboardType.emailAddress
        
        userPasswordTextField.isSecureTextEntry = true
        userPasswordTextField.returnKeyType = .done
        userPasswordTextField.clearButtonMode = .never
        

        userEmailTextField.delegate = self
        userPasswordTextField.delegate = self
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
