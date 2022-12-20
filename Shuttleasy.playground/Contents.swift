import Foundation

func isValidPhone(_ phone: String) -> Bool {
    
    if phone.count != 13 {
        return false
    }
    
    let phoneRegex = "^\\+[0-9]{10,13}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phoneTest.evaluate(with: phone)
}

print("5553332211 : \(isValidPhone("5553332211"))")
print("+905553332211 : \(isValidPhone("+905553332211"))")
print("+9055533322111 : \(isValidPhone("+9055533322111"))")
print("90555333222: \(isValidPhone("90555333222"))")
