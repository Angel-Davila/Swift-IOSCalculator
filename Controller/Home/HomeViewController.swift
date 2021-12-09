
import UIKit

final class HomeViewController: UIViewController {

    //MARK: - Initialization
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //OUTLETS
    
    //LABELS
    //labels and operators
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var operatorClear: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercentage: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    @IBOutlet weak var operatorMult: UIButton!
    @IBOutlet weak var operatorMinus: UIButton!
    @IBOutlet weak var operatorPlus: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorDecimal: UIButton!
    
    //numbers
    @IBOutlet weak var numberZero: UIButton!
    @IBOutlet weak var numberOne: UIButton!
    @IBOutlet weak var numberTwo: UIButton!
    @IBOutlet weak var numberThree: UIButton!
    @IBOutlet weak var numberFour: UIButton!
    @IBOutlet weak var numberFive: UIButton!
    @IBOutlet weak var numberSix: UIButton!
    @IBOutlet weak var numberSeven: UIButton!
    @IBOutlet weak var numberEight: UIButton!
    @IBOutlet weak var numberNine: UIButton!
    
    //variables
    private var total: Double = 0.0
    private var temp: Double = 0.0
    private var operating = false
    private var decimal = false
    private var operation: OperationType = .none
    
    //Constats
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kTotal = "total"
    
    
    
    private enum OperationType{
        case none, addition, substraction, multiplication, division, percent
    }
    
    //Auxiliar values formatters
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.maximumFractionDigits = 100
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.maximumFractionDigits = 100
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    private let printFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        let locale =  Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    
    
    //ACTIONS
    
    // OPERATION BUTTONS
    @IBAction func clearButton(_ sender: UIButton) {
        
        Clear()
        sender.shine()
    
    }
    
    @IBAction func plusminusButton(_ sender: UIButton) {
        
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
        
    }
    
    @IBAction func percentageButton(_ sender: UIButton) {
        
        if operation != .percent {
            Result()
        }
        operating = true
        operation = .percent
        Result()
        sender.shine()
        
    }
    
    @IBAction func divisionButton(_ sender: UIButton) {
        
        if operation != .none{
            Result()
        }
        operating = true
        operation = .division
        sender.selectedOperation(true)
        sender.shine()
        
    }
    
    @IBAction func multButton(_ sender: UIButton) {
        if operation != .none{
            Result()
        }
        operating = true
        operation = .multiplication
        sender.selectedOperation(true)
        sender.shine()
        
    }
    
    @IBAction func minusButton(_ sender: UIButton) {
        if operation != .none{
            Result()
        }
        operating = true
        operation = .substraction
        sender.selectedOperation(true)
        sender.shine()
        
    }
   
    @IBAction func plusButton(_ sender: UIButton) {
        
        if operation != .none{
            Result()
        }
        operating = true
        operation = .addition
        sender.selectedOperation(true)
        sender.shine()
        
    }
   
    @IBAction func resultButton(_ sender: UIButton) {
        Result()
        sender.shine()
        
    }
   
    @IBAction func decimalButton(_ sender: UIButton) {
        
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength{
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        selectVisualOperation()
        sender.shine()
        
    }
    
    //NUMBER BUTTON
    @IBAction func NumberAction(_ sender: UIButton) {

        
        operatorClear.setTitle("C", for: .normal)
        
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number)) ?? 0.0
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        
        sender.shine()
    }
    
    private func Clear(){
        operation = .none
        operatorClear.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
            Result()
        }
    }
    
    private func Result(){
        switch operation {
        
        case .none:
            // no operation is done
            break
        case .addition:
            total = total + temp
            break
        case .substraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("TOTAL \(total)")
    }
    
    
    private func selectVisualOperation(){
        if !operating {
            operatorPlus.selectedOperation(false)
            operatorMinus.selectedOperation(false)
            operatorPercentage.selectedOperation(false)
            operatorMult.selectedOperation(false)
            operatorDivision.selectedOperation(false)
            
        } else {
            switch operation {
            
            case .none, .percent:
                operatorPlus.selectedOperation(false)
                operatorMinus.selectedOperation(false)
                operatorMult.selectedOperation(false)
                operatorDivision.selectedOperation(false)
                break
            case .addition:
                operatorPlus.selectedOperation(true)
                operatorMinus.selectedOperation(false)
                operatorMult.selectedOperation(false)
                operatorDivision.selectedOperation(false)
                break
            case .substraction:
                operatorPlus.selectedOperation(false)
                operatorMinus.selectedOperation(true)
                operatorMult.selectedOperation(false)
                operatorDivision.selectedOperation(false)
                break
            case .multiplication:
                operatorPlus.selectedOperation(false)
                operatorMinus.selectedOperation(false)
                 operatorMult.selectedOperation(true)
                operatorDivision.selectedOperation(false)
                break
            case .division:
                operatorPlus.selectedOperation(false)
                operatorMinus.selectedOperation(false)
                operatorMult.selectedOperation(false)
                operatorDivision.selectedOperation(true)
                break
            
            }
        }
    }
    

    //MARK - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIbuttons customization
        //Numbers
        numberZero.round()
        numberOne.round()
        numberTwo.round()
        numberThree.round()
        numberFour.round()
        numberFive.round()
        numberSix.round()
        numberSeven.round()
        numberEight.round()
        numberNine.round()
        
        //Operators
        operatorClear.round()
        operatorPlusMinus.round()
        operatorPlus.round()
        operatorMult.round()
        operatorMinus.round()
        operatorDivision.round()
        operatorDecimal.round()
        operatorResult.round()
        operatorPercentage.round()
        
        operatorDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: kTotal)
        
        Result()
    }


}
