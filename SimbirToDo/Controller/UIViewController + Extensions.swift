
import UIKit
import Foundation

extension UIViewController{
    
    func confirmAlert(title: String, message: String? = nil, accept: (() -> Void)? = nil, dismiss: (() -> Void)? = nil){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: "Да", style: .destructive) { _ in
            accept?()
        }
        alert.addAction(confirm)
        
        let dismiss = UIAlertAction(title: "Нет", style: .cancel) { _ in
            dismiss?()
        }
        
        alert.addAction(dismiss)
        present(alert, animated: true)
        
    }
    
}
