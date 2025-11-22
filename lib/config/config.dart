class Config {
  // For Android Emulator use 10.0.2.2
  // For iOS Simulator use 127.0.0.1
  // For web use actual IP on host
  static String get backendUrl {
    const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
    switch (env) {
      case 'prod':
        return 'https://api.floatyfly.com';
      case 'dev':
      default:
        return 'http://localhost:8080'; // Local development URL
    }
  }
}
