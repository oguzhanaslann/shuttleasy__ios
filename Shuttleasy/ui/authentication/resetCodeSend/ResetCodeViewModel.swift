import Foundation
import Combine

class ResetCodeViewModel : ViewModel {
    
    let authenticator : Authenticator
   
    private let resetCodeSubject = PassthroughSubject<UiDataState<Bool>, Error>()
    let resetCodeResult : AnyPublisher<UiDataState<Bool>, Error>
    
    private let resetCodeSendSubject = PassthroughSubject<UiDataState<Bool>, Error>()
    let resetCodeSendResult : AnyPublisher<UiDataState<Bool>, Error>
  
    var resetCodeSendTask : Task<(),Error>? = nil

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
        self.resetCodeResult = resetCodeSubject.eraseToAnyPublisher()
        self.resetCodeSendResult = resetCodeSendSubject.eraseToAnyPublisher()
    }
  
    func sendResetCodeTo(email: String) {
        if (resetCodeSendTask?.isCancelled == false) {
            resetCodeSendTask?.cancel()
        }
    
       resetCodeSendTask = Task.init{
           let result = try await self.authenticator.sendResetCodeTo(email: email)

           switch result {
               case .success(let isSuccess):
                    debugPrint("EmailPasswordResetViewModel - signInUser - isSuccess: \(isSuccess)")
                    resetCodeSendSubject.send(UiDataState.Success(DataContent.createFrom(data: isSuccess)))
               case .failure(let error):
                    debugPrint("EmailPasswordResetViewModel - signInUser - error: \(error) - message : \(error.localizedDescription)")
                    resetCodeSendSubject.send(UiDataState.Error(error.localizedDescription))
           }
       }
    }
    
    func sendResetCode(email: String, code : String) {
        Task.init {
            let result = try await self.authenticator.sendResetCode(code: code, email: email)

            switch result {
                case .success(let isSuccess):
                    debugPrint("EmailPasswordResetViewModel - signInUser - isSuccess: \(isSuccess)")
                    resetCodeSubject.send(UiDataState.Success(DataContent.createFrom(data: isSuccess)))
                case .failure(let error):
                    debugPrint("EmailPasswordResetViewModel - signInUser - error: \(error) - message : \(error.localizedDescription)")
                    resetCodeSubject.send(UiDataState.Error(error.localizedDescription))
            }
        }   
    }
}
