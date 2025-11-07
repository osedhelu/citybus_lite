import 'package:flutter/material.dart';
import 'package:fstcommunity/features/aliados/presentation/screens/aliados_screen.dart';
import 'package:fstcommunity/features/fst_card/presentation/screens/fst_card_form_screen.dart';
import 'package:fstcommunity/features/fst_card/presentation/screens/fst_card_screen.dart';
import 'package:fstcommunity/features/fstgummies/presentation/screens/fstgummies_screen.dart';
import 'package:fstcommunity/features/fstgummies/presentation/screens/fst_gummies_form_screen.dart';
import 'package:fstcommunity/features/fstgummies/presentation/screens/fst_gummies_orders_screen.dart';
import 'package:fstcommunity/features/games/presentation/screens/games_list_screen.dart';
import 'package:fstcommunity/features/games/presentation/screens/notifications/BroadcastNotifications.dart';
import 'package:fstcommunity/features/games/presentation/screens/sorteo/sorteo_game_screen.dart';
import 'package:fstcommunity/features/websocket/presentation/screens/list_user_screen.dart';
import 'package:fstcommunity/features/ibo/presentation/screens/ibo_screen.dart';
import 'package:fstcommunity/features/launchpad/presentation/screens/launchpad_screen.dart';
import 'package:fstcommunity/features/p2p/presentation/screens/p2p_screen.dart';
import 'package:fstcommunity/features/profile/presentation/screens/profile_screen.dart';
import 'package:fstcommunity/features/profile/presentation/screens/profile_upgrade_screen.dart';
import 'package:fstcommunity/features/genealogy/presentation/screens/genealogy_screen.dart';
import 'package:fstcommunity/features/recharge_crypto/presentation/screens/recharge_crypto_screen.dart';
import 'package:fstcommunity/features/shared/widgets/game_layout.dart';
import 'package:fstcommunity/features/toast/helpers/toast_helpper.dart';
import 'package:fstcommunity/features/update_app/presentation/providers/google_play_update_provider.dart';
import 'package:fstcommunity/features/update_app/presentation/screens/update_app_screen.dart';
import 'package:fstcommunity/features/wallet/presentation/configure_wallet_screen.dart';
import 'package:fstcommunity/features/withdraw/presentation/screens/withdraw_crypto_screen.dart';
import 'package:fstcommunity/features/withdraw/presentation/screens/withdrawal_history_screen.dart';
import 'package:fstcommunity/features/withdraw/presentation/screens/user_wallets_screen.dart';
import 'package:fstcommunity/features/withdraw/presentation/screens/user_wallet_form_screen.dart';
import 'package:fstcommunity/features/withdraw/domain/entities/user_wallet_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fstcommunity/config/router/app_router_nofifier.dart';
import 'package:fstcommunity/features/auth/providers/auth_provider.dart';
import 'package:fstcommunity/features/products/products.dart';
import 'package:fstcommunity/features/products/domain/entities/category.dart';
import 'package:fstcommunity/features/products/domain/entities/products.dart';
import 'package:fstcommunity/features/products/presentation/screens/products_by_category_screen.dart';
import 'package:fstcommunity/features/products/presentation/screens/product_detail_screen.dart';
import 'package:fstcommunity/features/features.dart';
import 'package:fstcommunity/features/fstgummies/presentation/screens/bono_30d_screen.dart';
import 'package:fstcommunity/features/shared/shared.dart';
import 'package:fstcommunity/features/products/presentation/screens/payment_confirmation_screen.dart';
import 'package:fstcommunity/features/setting/presentation/screens/setting_screen.dart';
import 'package:fstcommunity/features/withdraw_pta/presentation/screens/withdraw_pta_screen.dart';
import 'package:fstcommunity/features/wallet/presentation/transfer_wallet_screen.dart';
import 'package:fstcommunity/features/parameter/presentation/screens/parameter_screen.dart';
import 'package:fstcommunity/features/wallet/presentation/transaction_details_screen.dart';
import 'package:fstcommunity/features/wallet/presentation/wallet_receive.dart';
import 'package:fstcommunity/features/withdraw/presentation/screens/withdraw_bank_screen.dart';
import 'package:fstcommunity/features/withdraw/presentation/screens/user_bank_account_form_screen.dart';
import 'package:fstcommunity/features/withdraw/presentation/screens/user_bank_accounts_screen.dart';
import 'package:fstcommunity/features/withdraw/domain/entities/user_bank_account_entity.dart';
import 'package:fstcommunity/features/binance/presentation/screens/binance_screen.dart';
import 'package:fstcommunity/features/binance/presentation/screens/transfer_fst_screen.dart';
import 'package:fstcommunity/features/binance/presentation/screens/binance_receive_screen.dart';
import 'package:fstcommunity/features/binance/presentation/screens/transaction_confirmation_screen.dart';
import 'package:fstcommunity/features/binance/presentation/screens/fst_conversion_screen.dart';
import 'package:fstcommunity/features/test_emit_message/presentation/screens/test_emit_message_screen.dart';

part 'app_router.g.dart';

@riverpod
class AppRouter extends _$AppRouter {
  @override
  GoRouter build() {
    final goRouterNotifier = ref.read(goRouterXProvider);

    return GoRouter(
      initialLocation: '/login',
      refreshListenable: goRouterNotifier,
      navigatorKey: navigatorKey,
      errorBuilder: (context, state) =>
          const Scaffold(body: Center(child: Text('Página no encontrada'))),
      routes: [
        GoRoute(
          path: '/check-auth-status',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),

        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AuthLayout(child: LoginScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AuthLayout(child: RegisterScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: "/configure-wallet",
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AuthLayout(child: ConfigureWalletScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/aliados',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: AliadosScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/fstgummies',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: FstgummiesScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/launchpad',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: LaunchpadScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/products',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: ProductsScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          path: '/ibo',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: IboScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/p2p',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: P2pScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/binance',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: BinanceScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/transfer-fst',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: TransferFstScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/transaction-confirmation',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(
              child: TransactionConfirmationScreen(
                fromPrivateKey:
                    (state.extra as Map<String, dynamic>?)?['fromPrivateKey']
                            as String? ??
                        '',
                toAddress: (state.extra as Map<String, dynamic>?)?['toAddress']
                        as String? ??
                    '',
                amount: (state.extra as Map<String, dynamic>?)?['amount']
                        as String? ??
                    '',
                fromAddress: (state.extra
                    as Map<String, dynamic>?)?['fromAddress'] as String?,
              ),
            ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/binance-receive',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: BinanceReceiveScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/fst-conversion',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: FstConversionScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: SettingScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/parameters',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: ParameterScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          path: "/withdraw-pta",
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: WithdrawPTAScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: WalletHomeScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/update-app',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: UpdateAppScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/test-emit-message',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: TestEmitMessageScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/wallet/:address/:title',
          pageBuilder: (context, state) {
            final address = state.pathParameters['address'] ?? '';
            final title = state.pathParameters['title'] ?? '';
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(
                child: DetailWalletScreen(address: address, title: title),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),

        GoRoute(
          path: '/wallet_receive/:address',
          pageBuilder: (context, state) {
            final address = state.pathParameters['address'];
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(child: WalletReceive(address: address ?? '')),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/wallet_send',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: TransferWalletScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: ProfileScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/profile-upgrade',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: ProfileUpgradeScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/genealogy',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: GenealogyScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/recharge-crypto',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: RechargeCryptoScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/wallet_withdraw',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: WithdrawBankScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/wallet_withdraw_alt',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: WithdrawBankScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/wallet_withdraw_crypto',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: WithdrawCryptoScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/withdrawal-history',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: WithdrawalHistoryScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/bono-30d',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: Bono30DScreen(selectedDay: 24)),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          path: '/product-detail',
          pageBuilder: (context, state) {
            final product = state.extra as Product;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(child: ProductDetailScreen(product: product)),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),

        GoRoute(
          path: '/products/:categoryId/:categoryTitle',
          pageBuilder: (context, state) {
            final categoryId = state.pathParameters['categoryId'] ?? '';
            final categoryTitle =
                '${state.pathParameters['categoryTitle']} - $categoryId';

            // Crear la categoría con los parámetros de la URL
            final category = ProductCategory(
              id: categoryId,
              title: categoryTitle,
              description: '',
              createdAt: '',
              publishedAt: '',
              updatedAt: '',
            );

            return CustomTransitionPage(
              key: state.pageKey,
              child: ProductsByCategoryScreen(category: category),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/fst-card',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(
                child: FstCardScreen(),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/fstore-form',
          pageBuilder: (context, state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(
                child: FstCardFormScreen(
                  productData: extra,
                  pathApi: '/fstore-form',
                  title: 'Solicitar FST Store',
                ),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/fst-card-form',
          pageBuilder: (context, state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(
                child: FstCardFormScreen(
                  productData: extra,
                  pathApi: '/fst-card-form',
                  title: 'Solicitar FST Card',
                ),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/payment-confirmation',
          pageBuilder: (context, state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(
                child: PaymentConfirmationScreen(
                  productId: extra['productId'],
                  productTitle: extra['productTitle'],
                  productPrice: extra['productPrice'],
                  productCategory: extra['productCategory'],
                  quantity: extra['quantity'],
                ),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/fst-gummies-form',
          pageBuilder: (context, state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(
                child: FstGummiesFormScreen(productData: extra),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/fst-gummies-orders',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: FstGummiesOrdersScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/transaction-details',
          pageBuilder: (context, state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MainLayout(
                child: TransactionDetailsScreen(
                  toAddress: extra['toAddress'] as String,
                  fromAddress: extra['fromAddress'] as String,
                  amount: extra['amount'] as String,
                  isSuccess: extra['isSuccess'] as bool,
                  errorMessage: extra['errorMessage'] as String?,
                  transactionHash: extra['transactionHash'] as String?,
                ),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),

        GoRoute(
          path: '/user-address',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: UserAddressScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/user-wallets',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: UserWalletsScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/user-wallets/new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const UserWalletFormScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/user-wallets/edit',
          pageBuilder: (context, state) {
            final wallet = state.extra as UserWalletEntity;
            return CustomTransitionPage(
              key: state.pageKey,
              child: UserWalletFormScreen(wallet: wallet),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/user-bank-accounts',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: UserBankAccountsScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/user-bank-accounts/new',
          pageBuilder: (context, state) {
            final userId = state.extra as int;
            return CustomTransitionPage(
              key: state.pageKey,
              child: UserBankAccountFormScreen(userId: userId),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/user-bank-accounts/edit',
          pageBuilder: (context, state) {
            final account = state.extra as UserBankAccountEntity;
            return CustomTransitionPage(
              key: state.pageKey,
              child: UserBankAccountFormScreen(
                accountToEdit: account,
                userId: account.userId,
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),

        // Rutas de Juegos
        GoRoute(
          path: '/games',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: GameLayout(child: GamesListScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/games/sorteo',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: GameLayout(child: SorteoGameScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        // GoRoute(
        //   path: '/games/winners',
        //   pageBuilder: (context, state) => CustomTransitionPage(
        //     key: state.pageKey,
        //     child: GameLayout(child: WinnersScreen()),
        //     transitionsBuilder: (
        //       context,
        //       animation,
        //       secondaryAnimation,
        //       child,
        //     ) {
        //       return FadeTransition(opacity: animation, child: child);
        //     },
        //   ),
        //         ),

        // Rutas de WebSocket
        GoRoute(
          path: '/websocket/users',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(child: ListUserScreen()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/games/notifications',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: GameLayout(child: BroadcastNotifications()),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        // GoRoute(
        //   path: '/game-registration',
        //   pageBuilder:
        //       (context, state) => CustomTransitionPage(
        //         key: state.pageKey,
        //         child: MainLayout(child: GameRegistrationScreen()),
        //         transitionsBuilder: (
        //           context,
        //           animation,
        //           secondaryAnimation,
        //           child,
        //         ) {
        //           return FadeTransition(opacity: animation, child: child);
        //         },
        //       ),
        // ),
        // GoRoute(
        //   path: '/game-waiting-room',
        //   pageBuilder:
        //       (context, state) => CustomTransitionPage(
        //         key: state.pageKey,
        //         child: MainLayout(child: GameWaitingRoomScreen()),
        //         transitionsBuilder: (
        //           context,
        //           animation,
        //           secondaryAnimation,
        //           child,
        //         ) {
        //           return FadeTransition(opacity: animation, child: child);
        //         },
        //       ),
        // ),

        // GoRoute(
        //   path: '/game-winner',
        //   pageBuilder:
        //       (context, state) => CustomTransitionPage(
        //         key: state.pageKey,
        //         child: MainLayout(child: GameWinnerScreen()),
        //         transitionsBuilder: (
        //           context,
        //           animation,
        //           secondaryAnimation,
        //           child,
        //         ) {
        //           return FadeTransition(opacity: animation, child: child);
        //         },
        //       ),
        // ),

        // GoRoute(
        //   path: '/games/transaction-success',
        //   pageBuilder: (context, state) {
        //     final roomId = state.extra as Map<String, dynamic>?;
        //     return CustomTransitionPage(
        //       key: state.pageKey,
        //       child: MainLayout(
        //         child: GameTransactionSuccessScreen(
        //           roomId: roomId?['roomId'] ?? 'unknown',
        //           amount: roomId?['amount'] ?? 5.0,
        //           gameType: roomId?['gameType'] ?? 'Juego de Conexión',
        //         ),
        //       ),
        //       transitionsBuilder: (
        //         context,
        //         animation,
        //         secondaryAnimation,
        //         child,
        //       ) {
        //         return FadeTransition(opacity: animation, child: child);
        //       },
        //     );
        //   },
        // ),
      ],
      redirect: (ctx, state) {
        final isGoingTo = state.matchedLocation;
        final authState = goRouterNotifier.authStatus;
        final updateStatus = goRouterNotifier.updateStatus;

        if (updateStatus == GooglePlayUpdateStatus.noUpdate) {
          // Permitir navegación manual a rutas de auth (excepto '/login' cuando el estado exige otro flujo)
          if (isGoingTo == '/register' ||
              isGoingTo == '/configure-wallet' ||
              isGoingTo == '/profile-upgrade' ||
              isGoingTo == '/security-policy') {
            return null; // No redirigir, permitir navegación manual
          }

          // Calcular destino deseado según estado de autenticación
          String? desired;
          switch (authState) {
            case AuthStatus.unauthenticated:
              desired = '/login';
              break;
            case AuthStatus.registering:
              desired = '/register';
              break;
            case AuthStatus.profileIncomplete:
              desired = '/profile-upgrade';
              break;
            case AuthStatus.walletSetup:
              desired = '/configure-wallet';
              break;
            case AuthStatus.phoneRequired:
              desired = '/profile-upgrade';
              break;
            case AuthStatus.checking:
              desired = '/check-auth-status';
              break;
            case AuthStatus.authenticated:
              desired = null;
              break;
          }

          // Si hay un destino definido y no estamos ya ahí, redirigir
          if (desired != null && isGoingTo != desired) {
            return desired;
          }

          // Evitar que un usuario autenticado se quede en rutas públicas de auth
          // (excepto cuando navega manualmente)
          if (authState == AuthStatus.authenticated &&
              (isGoingTo == '/check-auth-status')) {
            return '/';
          }

          return null;
        }

        if (updateStatus == GooglePlayUpdateStatus.available) {
          return '/update-app';
        }

        return null;
      },
    );
  }
}
