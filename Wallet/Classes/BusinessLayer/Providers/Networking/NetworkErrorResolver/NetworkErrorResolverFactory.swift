//
//  NetworkErrorResolverFactory.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol NetworkErrorResolverFactoryProtocol {
    func createDefault() -> NetworkErrorResolverProtocol
    func createForResendConfirmEmail() -> NetworkErrorResolverProtocol
    func createForConfirmAddDevice() -> NetworkErrorResolverProtocol
    func createForAddDevice() -> NetworkErrorResolverProtocol
    func createForSend() -> NetworkErrorResolverProtocol
    func createForSocialAuth() -> NetworkErrorResolverProtocol
    func createForChangePassword() -> NetworkErrorResolverProtocol
    func createForConfirmResetPassword() -> NetworkErrorResolverProtocol
    func createForResetPassword() -> NetworkErrorResolverProtocol
    func createForRegistration() -> NetworkErrorResolverProtocol
    func createForLogin() -> NetworkErrorResolverProtocol
    func createForEmailConfirm() -> NetworkErrorResolverProtocol
}


class NetworkErrorResolverFactory: NetworkErrorResolverFactoryProtocol {
    
    func createDefault() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForResendConfirmEmail() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForConfirmAddDevice() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForAddDevice() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForSend() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(),
            SendNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForSocialAuth() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForChangePassword() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(),
            ChangePasswordNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForConfirmResetPassword() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            ConfirmResetPasswordErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForResetPassword() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForRegistration() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            AuthNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForLogin() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            EmailNetworkErrorParser(),
            AuthNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    func createForEmailConfirm() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownedErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
}
