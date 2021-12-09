import UIKit

//Colors

private let orange = UIColor(red: 254/255, green: 148/255, blue: 8/255, alpha: 1)

extension UIButton {
    
    func round(){
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    func shine(){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.5
        }) {(completion) in
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            })
        }
    }
    
    func selectedOperation(_ selected: Bool){
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal)
    }
}
    
