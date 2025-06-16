import '@testing-library/jest-native/extend-expect';

// Mock Expo modules
jest.mock('expo-constants', () => ({
  default: {
    appOwnership: 'standalone',
  },
}));

jest.mock('expo-status-bar', () => ({
  StatusBar: 'StatusBar',
}));
