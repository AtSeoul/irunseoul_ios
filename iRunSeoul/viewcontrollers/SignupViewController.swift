//
//  SignupViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 14/04/2017.
//
//

import UIKit
import Firebase
import PKHUD

class SignupViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }


    
    @IBAction func didClickSignup(_ sender: UIButton) {
        
        if let email = emailTextField.text, let display_name = displayNameTextField.text, let password = passwordTextField.text {
            
            HUD.show(.progress)
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                 
                    print("error : \(error.localizedDescription)")
                    HUD.flash(.error, delay: 1.0) { finished in
                        
                        self.showLoginAlert(message: error.localizedDescription)
                    }
                    return
                }
                
                print("\(user!.email!) created")
                let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                changeRequest?.displayName = display_name
                changeRequest?.commitChanges() { (error) in
                    
                    let username = user!.email!.components(separatedBy: "@")[0]
                    self.ref.child("users").child(user!.uid).setValue(["username": username, "email": user!.email!])
                    
                    print("user display Name updated")
                    HUD.flash(.success, delay: 1.0) { finished in
                        
                        self.navigationController!.popViewController(animated: true)
                    }
                    
                }

            }
            
        } else {
            
            self.showLoginAlert(message: "Enter all the required info!")

        }
        
    }
    
    // MARK: - UI Helpers
    
    func setupUI() {
        
        self.navigationController?.navigationBar.isHidden = false
        
        displayNameTextField.returnKeyType = .next
        displayNameTextField.clearButtonMode = .never
        
        emailTextField.returnKeyType = .next
        emailTextField.clearButtonMode = .never
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordTextField.clearButtonMode = .never
        
        displayNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    
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

    
    // MARK: - UITextField Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if( textField == displayNameTextField ) {
            
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            
        } else if (textField == emailTextField) {
            
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        
        } else {
            
            textField.resignFirstResponder()
        }
        return true
        
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
