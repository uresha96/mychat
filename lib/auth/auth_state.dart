class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool successfullyLoggedIn;
  final String? userId;
  final String? token;
  final String? error;

  const AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    required this.successfullyLoggedIn,
    this.userId,
    this.token,
    this.error,
  });

  factory AuthState.initial() => const AuthState(
        isLoading: false,
        isAuthenticated: false,
        successfullyLoggedIn: false,
      );

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? successfullyLoggedIn,
    String? userId,
    String? token,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      successfullyLoggedIn: successfullyLoggedIn ?? this.successfullyLoggedIn,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      error: error,
    );
  }
}
