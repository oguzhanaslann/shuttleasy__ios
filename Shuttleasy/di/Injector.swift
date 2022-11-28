//
//  Injector.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import Swinject

class Injector {
    
    let container = Container()
    
    static let shared  = Injector()
    static let userLocalInfoDependency = "userInfoLocal"
    static let userNetworkInfoDependency = "userInfoNetwork"
    
    private init() {
        registerUserInfoLocalDataSource()
        registerUsserNetworkDataSource()
    }
    
    private func registerUserInfoLocalDataSource() {
        container.register(UserInfoLocalDataSource.self, name: Injector.userLocalInfoDependency) { resolver in
            return UserInfoLocalDataSourceImpl()
        }
    }

    private func registerUsserNetworkDataSource() {
        container.register(UserNetworkDataSource.self, name: Injector.userNetworkInfoDependency) { resolver in
            return UserNetworkDataSourceImpl()
        }
    }
    
    private func registerDependencyIfNotRegistered<T>(dependency : T.Type,objectScope: ObjectScope? = nil, onRegisterNeeded : @escaping ( Resolver ) -> T ) {
        if container.resolve(dependency.self) == nil  {
            registerDependency(dependency: dependency,objectScope: objectScope, onRegisterNeeded: onRegisterNeeded)
        }
    }
    
    private func registerDependency<T>(dependency : T.Type,objectScope: ObjectScope? = nil, onRegisterNeeded : @escaping ( Resolver ) -> T ) {
        let registeredServiceEntry = container.register(dependency) { resolver in
             onRegisterNeeded(resolver)
         }
         
         if let scope = objectScope {
             registeredServiceEntry.inObjectScope(scope)
         }
    }
    
    func injectOnboardViewModel() -> OnboardViewModel {
        registerDependencyIfNotRegistered(
            dependency: OnboardViewModel.self,
            onRegisterNeeded: { resolver in
                OnboardViewModel(
                    userInfoRepository: self.injectUserInfoRepository()
                )
            }
        )
        
        return container.resolve(OnboardViewModel.self)!
    }
    
    func injectUserInfoRepository() -> UserInfoRepository {
        registerShuttleasyUserRepository()
        return container.resolve(ShuttleasyUserRepository.self)!
    }
    
    
    func injectUserInfoLocalDataSource() -> UserInfoLocalDataSource {
        return container.resolve(UserInfoLocalDataSource.self, name: Injector.userLocalInfoDependency)!
    }

    func injectUserNetworkDataSource() -> UserNetworkDataSource {
        return container.resolve(UserNetworkDataSource.self, name: Injector.userNetworkInfoDependency)!
    }

    func injectSignViewModel() -> SignInViewModel {
        registerDependencyIfNotRegistered(
            dependency: SignInViewModel.self,
            onRegisterNeeded: { resolver in
                SignInViewModel(
                    authenticatior: self.injectAuthenticator()
                )
            }
        )
        
        return container.resolve(SignInViewModel.self)!
    }

    func injectAuthenticator() -> Authenticator {
        registerShuttleasyUserRepository()
        return container.resolve(ShuttleasyUserRepository.self)!
    }

    func registerShuttleasyUserRepository() {
        registerDependencyIfNotRegistered(
            dependency: ShuttleasyUserRepository.self,
            onRegisterNeeded: { resolver in
                ShuttleasyUserRepository(
                    userInfoLocalDataSource: self.injectUserInfoLocalDataSource(),
                    userNetworkDataSource: self.injectUserNetworkDataSource()
                )
            }
        )
    }

    func injectSignUpViewModel() -> SignUpViewModel {
        registerDependencyIfNotRegistered(
            dependency: SignUpViewModel.self,
            onRegisterNeeded: { resolver in
                SignUpViewModel(
                    authenticatior: self.injectAuthenticator()
                )
            }
        )
        
        return container.resolve(SignUpViewModel.self)!
    }

    func injectResetPasswordViewModel() -> EmailPasswordResetViewModel {
        registerDependencyIfNotRegistered(
            dependency: EmailPasswordResetViewModel.self,
            onRegisterNeeded: { resolver in
                EmailPasswordResetViewModel(
                    authenticatior: self.injectAuthenticator()
                )
            }
        )
        
        return container.resolve(EmailPasswordResetViewModel.self)!
    }

    func injectResetCodeViewModel() -> ResetCodeViewModel {
        registerDependencyIfNotRegistered(
            dependency: ResetCodeViewModel.self,
            onRegisterNeeded: { resolver in
                ResetCodeViewModel(
                    authenticatior: self.injectAuthenticator()
                )
            }
        )
        
        return container.resolve(ResetCodeViewModel.self)!
    }


    func injectResetPasswordViewModel() -> ResetPasswordViewModel {
        registerDependencyIfNotRegistered(
            dependency: ResetPasswordViewModel.self,
            onRegisterNeeded: { resolver in
                ResetPasswordViewModel(
                    authenticatior: self.injectAuthenticator()
                )
            }
        )
        
        return container.resolve(ResetPasswordViewModel.self)!
    }
}
