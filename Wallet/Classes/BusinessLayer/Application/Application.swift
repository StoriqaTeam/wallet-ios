//
//  Application.swift
//  Wallet
//
//  Created by Storiqa on 27/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import Foundation
import FacebookLogin

#if DEBUG
let BITCOIN_NETWORK = Network.btcTestnet
#else
let BITCOIN_NETWORK = Network.btcMainnet
#endif


class Application {
    
    // MARK: - Factories
    
    lazy var accountWatcherFactory: CurrentAccountWatcherFactoryProtocol = CurrentAccountWatcherFactory(accountProvider: self.accountsProvider)
    lazy var sendTransactionBuilderFactory: SendTransactionBuilderFactoryProtocol = SendTransactionBuilderFactory(currencyConverterFactory: self.currencyConverterFactory,
                                                                                                                  currencyFormatter: self.currencyFormatter,
                                                                                                                  accountsProvider: self.accountsProvider,
                                                                                                                  feeProvider: self.feeProvider,
                                                                                                                  denominationUnitsConverter: self.denominationUnitsConverter)
    lazy var biometricAuthProviderFactory: BiometricAuthProviderFactory = BiometricAuthProviderFactory()
    lazy var exchangeProviderBuilderFactory: ExchangeProviderBuilderFactoryProtocol = ExchangeProviderBuilderFactory(accountsProvider: self.accountsProvider,
                                                                                                                     converterFactory: self.currencyConverterFactory,
                                                                                                                     denominationUnitsConverter: self.denominationUnitsConverter)
    
    
    // MARK: - System store
    lazy var keychainProvider: KeychainProviderProtocol = KeychainProvider()
    lazy var defaultsProvider: DefaultsProviderProtocol = DefaultsProvider()
    
    
    // MARK: - Data Store Services
    lazy var userDataStoreService: UserDataStoreService = UserDataStoreService()
    lazy var accountsDataStoreService: AccountsDataStoreServiceProtocol = AccountsDataStoreService()
    lazy var sessionsDataStoreService: SessionsDataStoreServiceProtocol = SessionsDataStoreService()
    lazy var transactionDataStoreService: TransactionDataStoreServiceProtocol = TransactionDataStoreService()
    lazy var contactsDataStoreService: ContactsDataStoreServiceProtocol = ContactsDataStoreService()
    lazy var ratesDataStoreService: RatesDataStoreServiceProtocol = RatesDataStoreService()
    
    
    // MARK: - Network Providers
    lazy var loginNetworkProvider: LoginNetworkProviderProtocol = LoginNetworkProvider()
    lazy var userNetworkProvider: CurrentUserNetworkProviderProtocol = CurrentUserNetworkProvider()
    lazy var accountsNetworkProvider: AccountsNetworkProviderProtocol = AccountsNetworkProvider()
    lazy var registrationNetworkProvider: RegistrationNetworkProviderProtocol = RegistrationNetworkProvider()
    lazy var emailConfirmNetworkProvider: EmailConfirmNetworkProviderProtocol = EmailConfirmNetworkProvider()
    lazy var transactionsNetworkProvider: TransactionsNetworkProviderProtocol = TransactionsNetworkProvider()
    lazy var resetPasswordNetworkProvider: ResetPasswordNetworkProviderProtocol = ResetPasswordNetworkProvider()
    lazy var confirmResetPasswordNetworkProvider: ConfirmResetPasswordNetworkProviderProtocol = ConfirmResetPasswordNetworkProvider()
    lazy var sendTransactionNetworkProvider: SendTransactionNetworkProviderProtocol = SendTransactionNetworkProvider()
    lazy var ratesNetworkProvider: RatesNetworkProviderProtocol = RatesNetworkProvider()
    lazy var changePasswordNetworkProvider: ChangePasswordNetworkProviderProtocol = ChangePasswordNetworkProvider()
    lazy var createAccountsNetworkProvider: CreateAccountNetworkProviderProtocol = CreateAccountNetworkProvider()
    lazy var socialAuthNetworkProvider: SocialAuthNetworkProviderProtocol = SocialAuthNetworkProvider()
    lazy var feeNetworkProvider: FeeNetworkProviderProtocol = FeeNetworkProvider()
    lazy var addDeviceNetworkProvider: AddDeviceNetworkProviderProtocol = AddDeviceNetworkProvider()
    lazy var confirmAddDeviceNetworkProvider: ConfirmAddDeviceNetworkProviderProtocol = ConfirmAddDeviceNetworkProvider()
    lazy var exchangeRateNetworkProvider: ExchangeRateNetworkProviderProtocol = ExchangeRateNetworkProvider()
    
    
    // MARK: - Common Providers
    lazy var pinValidationProvider: PinValidationProviderProtocol = PinValidationProvider(keychainProvider: self.keychainProvider)
    lazy var passwordRecoveryConfirmFormValidator: PasswordRecoveryConfirmFormValidatorProtocol = PasswordRecoveryConfirmFormValidator()
    lazy var registrationFormValidatonProvider: RegistrationFormValidatonProviderProtocol = RegistrationFormValidatonProvider()
    lazy var deviceContactsFetcher: DeviceContactsFetcherProtocol = DeviceContactsFetcher()
    lazy var currencyImageProvider: CurrencyImageProviderProtocol = CurrencyImageProvider()
    lazy var authTokenDefaultsProvider: AuthTokenDefaultsProviderProtocol = AuthTokenDefaultsProvider()
    lazy var authTokenProvider: AuthTokenProviderProtocol = AuthTokenProvider(defaults: self.authTokenDefaultsProvider,
                                                                              loginNetworkProvider: self.loginNetworkProvider,
                                                                              socialAuthNetworkProvider: self.socialAuthNetworkProvider,
                                                                              authDataResolver: self.authDataResolver,
                                                                              signHeaderFactory: self.signHeaderFactory)
    lazy var contactsProvider: ContactsProviderProtocol = ContactsProvider(dataStoreService: self.contactsDataStoreService)
    lazy var accountsProvider: AccountsProviderProtocol = AccountsProvider(dataStoreService: self.accountsDataStoreService)
    lazy var transactionsProvider: TransactionsProviderProtocol = TransactionsProvider(transactionDataStoreService:
        self.transactionDataStoreService)
    lazy var qrCodeProvider: QRCodeProviderProtocol = QRCodeProvider()
    lazy var appLockerProvider: AppLockerProviderProtocol = AppLockerProvider(app: self)
    lazy var ratesProvider: RatesProviderProtocol = RatesProvider(ratesDataStoreService: self.ratesDataStoreService)
    lazy var feeProvider: FeeProviderProtocol = FeeProvider(medianWaitFormatter: medianWaitFormatter)
    lazy var defaultAccountsProvider: DefaultAccountsProviderProtocol = DefaultAccountsProvider(userDataStore: self.userDataStoreService,
                                                                                                authTokenProvider: self.authTokenProvider,
                                                                                                createAccountsNetworkProvider: self.createAccountsNetworkProvider,
                                                                                                accountsDataStore: self.accountsDataStoreService,
                                                                                                signHeaderFactory: self.signHeaderFactory)
    lazy var signer: SignerProtocol = Signer()
    lazy var keyGenerator: KeyGeneratorProtocol = KeyGenerator()
    lazy var signHeaderFactory: SignHeaderFactoryProtocol = SignHeaderFactory(keychain: self.keychainProvider, signer: self.signer)
    lazy var userKeyManager: UserKeyManagerProtocol = UserKeyManager(keychainProvider: self.keychainProvider, keyGenerator: self.keyGenerator)
    
    // MARK: - Updaters
    lazy var accountsUpdater: AccountsUpdaterProtocol = AccountsUpdater(accountsNetworkProvider: self.accountsNetworkProvider,
                                                                        accountsDataStore: self.accountsDataStoreService,
                                                                        authTokenProvider: self.authTokenProvider,
                                                                        signHeaderFactory: self.signHeaderFactory,
                                                                        userDataStoreService: self.userDataStoreService)
    lazy var transactionsUpdater: TransactionsUpdaterProtocol = TransactionsUpdater(transactionsProvider: self.transactionsProvider,
                                                                                    transactionsNetworkProvider: self.transactionsNetworkProvider,
                                                                                    transactionsDataStoreService: self.transactionDataStoreService,
                                                                                    signHeaderFactory: self.signHeaderFactory,
                                                                                    defaultsProvider: self.defaultsProvider,
                                                                                    authTokenProvider: self.authTokenProvider,
                                                                                    userDataStoreService: self.userDataStoreService)

    lazy var contactsChacheUpdater: ContactsCacheUpdaterProtocol = ContactsCacheUpdater(deviceContactsFetcher: self.deviceContactsFetcher,
                                                                                        contactsNetworkProvider: self.fakeContactsNetworkProvider,
                                                                                        contactsAddressLinker: self.contactsAddressLinker)
    lazy var ratesUpdater: RatesUpdaterProtocol = RatesUpdater(ratesDataSourceService: self.ratesDataStoreService,
                                                               ratesNetworkProvider: self.ratesNetworkProvider)
    lazy var loginService: LoginServiceProtocol = LoginService(authTokenDefaultsProvider: self.authTokenDefaultsProvider,
                                                               loginNetworkProvider: self.loginNetworkProvider,
                                                               socialAuthNetworkProvider: self.socialAuthNetworkProvider,
                                                               userNetworkProvider: self.userNetworkProvider,
                                                               userDataStore: self.userDataStoreService,
                                                               keychain: self.keychainProvider,
                                                               defaults: self.defaultsProvider,
                                                               accountsNetworkProvider: self.accountsNetworkProvider,
                                                               accountsDataStore: self.accountsDataStoreService,
                                                               defaultAccountsProvider: self.defaultAccountsProvider,
                                                               signHeaderFactory: self.signHeaderFactory)
    lazy var authDataResolver: AuthDataResolverProtocol = AuthDataResolver(defaults: self.defaultsProvider,
                                                                           keychain: self.keychainProvider,
                                                                           userDataStoreService: self.userDataStoreService)
    lazy var sendTransactionService: SendTransactionServiceProtocol = SendTransactionService(sendNetworkProvider: self.sendTransactionNetworkProvider,
                                                                                             userDataStoreService: self.userDataStoreService,
                                                                                             authTokenProvider: self.authTokenProvider,
                                                                                             accountsUpdater: self.accountsUpdater,
                                                                                             txnUpdater: self.transactionsUpdater,
                                                                                             signHeaderFactory: self.signHeaderFactory)
    
    
    // MARK: - Converters and formattera
    lazy var currencyConverterFactory: CurrencyConverterFactoryProtocol = CurrencyConverterFactory(ratesProvider: self.ratesProvider)
    lazy var currencyFormatter: CurrencyFormatterProtocol = CurrencyFormatter()
    lazy var denominationUnitsConverter: DenominationUnitsConverterProtocol = DenominationUnitsConverter()
    lazy var medianWaitFormatter: MedianWaitFormatterProtocol = MedianWaitFormatter()
    
    // MARK: - Validators
    lazy var btcAddressValidator: AddressValidatorProtocol = BitcoinAddressValidator(network: BITCOIN_NETWORK)
    lazy var ethAddressValidator: AddressValidatorProtocol = EthereumAddressValidator()
    lazy var erc20SendValidator: Erc20SendValidatorProtocol = Erc20SendValidator()
    
    
    // MARK: - Resolvers
    lazy var accountTypeResolver: AccountTypeResolverProtocol = AccountTypeResolver()
    lazy var transactionDirectionResolver: TransactionDirectionResolverProtocol = TransactionDirectionResolver()
    lazy var transactionOpponentResolver: TransactionOpponentResolverProtocol = TransactionOpponentResolver(contactsProvider: self.contactsProvider,
                                                                                                            transactionDirectionResolver: self.transactionDirectionResolver,
                                                                                                            contactsMapper: self.contactsMapper)
    lazy var cryptoAddressResolver: CryptoAddressResolverProtocol = CryptoAddressResolver(btcAddressValidator: self.btcAddressValidator,
                                                                                          ethAddressValidator: self.ethAddressValidator)
    
    // MARK: - Sorters
    lazy var contactsSorter: ContactsSorterProtocol = ContactsSorter()
    lazy var sessionDateSorter: SessionDateSorterProtocol = SessionDateSorter()
    
    
    // MARK: - Linkers
    lazy var accountLinker: AccountsLinkerProtocol = AccountsLinker(accountsProvider: self.accountsProvider, transactionsProvider: self.transactionsProvider)
    lazy var contactsAddressLinker: ContactsAddressLinkerProtocol = ContactsAddressLinker(contactsDataStoreService: self.contactsDataStoreService)
    
    // MARK: - Mappers
    lazy var contactsMapper: ContactsMapper = ContactsMapper()
    lazy var transactionMapper: TransactionMapperProtocol = TransactionMapper(currencyFormatter: self.currencyFormatter,
                                                                              converterFactory: self.currencyConverterFactory,
                                                                              transactionDirectionResolver: self.transactionDirectionResolver,
                                                                              transactionOpponentResolver: self.transactionOpponentResolver,
                                                                              denominationUnitsConverter: self.denominationUnitsConverter)
    
    // MARK: - Loaders
    lazy var exchangeLoader: ExchangeRatesLoaderProtocol = ExchangeRatesLoader(userDataStore: self.userDataStoreService,
                                                                               authTokenProvider: self.authTokenProvider,
                                                                               signHeaderFactory: self.signHeaderFactory,
                                                                               exchangeRatesNetworkProvider: self.exchangeRateNetworkProvider)
    lazy var feeLoader: FeeLoaderProtocol = FeeLoader(userDataStore: self.userDataStoreService,
                                                      authTokenProvider: self.authTokenProvider,
                                                      signHeaderFactory: self.signHeaderFactory,
                                                      feeNetworkProvider: self.feeNetworkProvider)
    
    // MARK: - Social Networks
    lazy var facebookLoginManager: LoginManager = LoginManager()
    
    
    // MARK: - Global services
    lazy var shortPollingTimer: ShortPollingTimerProtocol = ShortPollingTimer(timeout: 90)
    
    // MARK: - Channels
    lazy var channelStorage: ChannelStorage = ChannelStorage()
    
    
    // MARK: - FakeProviders -
    lazy var fakeContactsNetworkProvider: ContactsNetworkProviderProtocol = FakeContactsNetworkProvider()
}
