import Foundation
import Combine

class ResetCodeViewModel : ViewModel {
    
    let authenticator : Authenticator
   
    let resetCodeResult = PassthroughSubject<Bool, Error>()
    let resetCodeSendResult = PassthroughSubject<Bool, Error>()
  
    var resetCodeSendTask : Task<(),Error>? = nil

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
    }
  
    func sendResetCodeTo(email: String) {
       if (resetCodeSendTask?.isCancelled == false) {
          resetCodeSendTask?.cancel()
       }
       
       resetCodeSendTask = Task.init{
            do {
                let result = try await self.authenticator.sendResetCodeTo(email: email)
                self.resetCodeSendResult.send(result)
            } catch {
               self.resetCodeSendResult.send(completion: .failure(error))
            }
       }
    }
    
    func sendResetCode(email: String, code : String) {
        Task.init {
            do {
                let result = try await self.authenticator.sendResetCode(code: code, email: email)
                self.resetCodeResult.send(result)
            } catch {
               self.resetCodeResult.send(completion: .failure(error))
            }
        }   
    }
}
