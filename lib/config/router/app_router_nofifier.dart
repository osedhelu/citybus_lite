import 'package:flutter/foundation.dart';
import 'package:fstcommunity/features/auth/domain/domain.dart';
import 'package:fstcommunity/features/auth/domain/entities/user_login.dart';
import 'package:fstcommunity/features/update_app/presentation/providers/google_play_update_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fstcommunity/features/auth/providers/auth_provider.dart';
import 'package:fstcommunity/features/services/key_value_storage_service.dart';
import 'package:fstcommunity/features/services/key_value_storage_servive_imp.dart';
part 'app_router_nofifier.g.dart';

@riverpod
class GoRouterX extends _$GoRouterX {
  @override
  GoRouterNotifierState build() {
    final authNotifier = ref.read(authProvider.notifier);
    final updateNotifier = ref.read(googlePlayUpdateProvider.notifier);
    final keyValueStorageService = KeyValueStorageServiceImp();
    return GoRouterNotifierState(
      authNotifier,
      keyValueStorageService,
      updateNotifier,
    );
  }
}

class GoRouterNotifierState extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  final KeyValueStorageService _keyValueStorageService;
  final GooglePlayUpdate _updateNotifier;
  AuthStatus _authStatus = AuthStatus.checking;
  GooglePlayUpdateStatus _updateStatus = GooglePlayUpdateStatus.checking;
  LoginResponse? _authUser;
  bool _isAppReopened = false;

  GoRouterNotifierState(
    this._authNotifier,
    this._keyValueStorageService,
    this._updateNotifier,
  ) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
      authUser = state.user;

      if (state.authStatus == AuthStatus.authenticated) {
        _checkAppReopened();
      }
    });

    _updateNotifier.listenSelf((previous, next) {
      updateStatus = next.status;
    });
  }

  Future<void> _checkAppReopened() async {
    _isAppReopened = true;
    notifyListeners();

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await _keyValueStorageService.setKeyValue('last_login_time', currentTime);
  }

  AuthStatus get authStatus => _authStatus;
  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

  LoginResponse? get authUser => _authUser;
  set authUser(LoginResponse? value) {
    _authUser = value;
    notifyListeners();
  }

  bool get isAppReopened => _isAppReopened;
  set isAppReopened(bool value) {
    _isAppReopened = value;
    notifyListeners();
  }

  GooglePlayUpdateStatus get updateStatus => _updateStatus;
  set updateStatus(GooglePlayUpdateStatus value) {
    _updateStatus = value;
    notifyListeners();
  }
}
