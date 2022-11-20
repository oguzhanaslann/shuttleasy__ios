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
    
    private init() {
        registerUserInfoLocalDataSource()
    }
    
    private func registerUserInfoLocalDataSource() {
        container.register(UserInfoLocalDataSource.self, name: Injector.userLocalInfoDependency) { resolver in
            return UserInfoLocalDataSourceImpl()
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
        registerDependencyIfNotRegistered(
            dependency: ShuttleasyUserInfoRepository.self,
            onRegisterNeeded: { resolver in
                ShuttleasyUserInfoRepository(
                    userInfoLocalDataSource: self.injectUserInfoLocalDataSource()
                )
            }
        )
        
        return container.resolve(ShuttleasyUserInfoRepository.self)!
    }
    
    
    func injectUserInfoLocalDataSource() -> UserInfoLocalDataSource {
        return container.resolve(UserInfoLocalDataSource.self, name: Injector.userLocalInfoDependency)!
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
        registerDependencyIfNotRegistered(
            dependency: Authenticator.self,
            onRegisterNeeded: { resolver in
                AuthenticatorImpl(
                    userInfoLocalDataSource: self.injectUserInfoLocalDataSource()
                )
            }
        )
        
        return container.resolve(Authenticator.self)!
    }
}
