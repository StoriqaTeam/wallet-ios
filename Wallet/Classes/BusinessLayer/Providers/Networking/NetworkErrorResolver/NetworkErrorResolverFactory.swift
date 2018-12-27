//
//  NetworkErrorResolverFactory.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol NetworkErrorResolverFactoryProtocol {
    func createDefaultErrorResolver() -> NetworkErrorResolverProtocol
    func createResendConfirmEmailErrorResolver() -> NetworkErrorResolverProtocol
    func createConfirmAddDeviceErrorResolver() -> NetworkErrorResolverProtocol
    func createAddDeviceErrorResolver() -> NetworkErrorResolverProtocol
    func createSendErrorResolver() -> NetworkErrorResolverProtocol
    func createSocialAuthErrorResolver() -> NetworkErrorResolverProtocol
    func createChangePasswordErrorResolver() -> NetworkErrorResolverProtocol
    func createConfirmResetPasswordErrorResolver() -> NetworkErrorResolverProtocol
    func createResetPasswordErrorResolver() -> NetworkErrorResolverProtocol
    func createRegistrationErrorResolver() -> NetworkErrorResolverProtocol
    func createLoginErrorResolver() -> NetworkErrorResolverProtocol
    func createEmailConfirmErrorResolver() -> NetworkErrorResolverProtocol
    func createAccountsErrorResolver() -> NetworkErrorResolverProtocol
    func createRefreshErrorResolver() -> NetworkErrorResolverProtocol
}


class NetworkErrorResolverFactory: NetworkErrorResolverFactoryProtocol {
    
    private let channelStorage: ChannelStorage
    
    init(channelStorage: ChannelStorage) {
        self.channelStorage = channelStorage
    }
    
    func createDefaultErrorResolver() -> NetworkErrorResolverProtocol {
        let tokenExpiredoutputChannel = channelStorage.tokenExpiredChannel
        
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(tokenExpiredChannelOutput: tokenExpiredoutputChannel),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createResendConfirmEmailErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createConfirmAddDeviceErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createAddDeviceErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createSendErrorResolver() -> NetworkErrorResolverProtocol {
        
        let tokenExpiredoutputChannel = channelStorage.tokenExpiredChannel
        
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(tokenExpiredChannelOutput: tokenExpiredoutputChannel),
            SendNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createSocialAuthErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createChangePasswordErrorResolver() -> NetworkErrorResolverProtocol {
        
        let tokenExpiredoutputChannel = channelStorage.tokenExpiredChannel
        
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(tokenExpiredChannelOutput: tokenExpiredoutputChannel),
            ChangePasswordNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createConfirmResetPasswordErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            ConfirmResetPasswordErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createResetPasswordErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            EmailNetworkErrorParser(),
            AuthNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createRegistrationErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            AuthNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createLoginErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            EmailNetworkErrorParser(),
            AuthNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createEmailConfirmErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createAccountsErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            EmptyAccountListNetworkErrorParser(), // should be the first check
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createRefreshErrorResolver() -> NetworkErrorResolverProtocol {
        
        let tokenExpiredoutputChannel = channelStorage.tokenExpiredChannel
        
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(tokenExpiredChannelOutput: tokenExpiredoutputChannel),
            NetworkUnknownErrorParser()
        ]
        
        return NetworkErrorResolver(parsers: parsers)
    }
}
