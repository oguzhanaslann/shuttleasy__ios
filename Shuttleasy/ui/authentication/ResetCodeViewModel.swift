import Foundation
import Combine

class ResetCodeViewModel : ViewModel {
    
    let authenticator : Authenticator
   
    let resetCodeResult = PassthroughSubject<Bool, Error>()
  
    let resetCodeSendTask : Task<Bool,Error>? = nil 

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
    }
  
    func sendResetCodeTo(email: String) {
      
       if (resetCodeSendTask?.isCancelled == false) {
          resetCodeSendTask?.cancel()
       }
       
       resetCodeSendTask = Task.init{
            do {
              let result = try await self.authenticator(email: email)
              self.resetCodeResult.send(result)
            } catch {
               self.resetCodeResult.send(completion: .failure(error))
            }
        }
    }
}
