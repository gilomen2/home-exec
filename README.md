# Home Exec Cross-Platform App

A React Native + Expo application for Home Exec that deploys to web, iOS, and Android.

## Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm start

# Run on specific platforms
npm run web      # Web browser
npm run ios      # iOS simulator  
npm run android  # Android emulator
```

## Development

This project uses:
- **Expo** for cross-platform development
- **TypeScript** for type safety
- **Jest** for testing
- **ESLint** for code quality
- **GitHub Actions** for CI/CD

## Available Scripts

- `npm start` - Start Expo development server
- `npm test` - Run tests
- `npm run lint` - Check code quality
- `npm run type-check` - TypeScript type checking
- `npm run build:web` - Build for web deployment
- `npm run build:ios` - Build iOS app (requires EAS)
- `npm run build:android` - Build Android app (requires EAS)

## Deployment

### Web
Automatically deploys via Netlify's direct GitHub integration (no secrets needed).

### Mobile
Builds are created via Expo Application Services (EAS) when pushed to main.

## Setup Requirements

1. **Expo CLI**: `npm install -g @expo/cli`
2. **EAS CLI**: `npm install -g eas-cli`
3. **Expo Account**: Sign up at expo.dev
4. **Netlify Account**: Sign up at netlify.com (connect with GitHub)
5. **GitHub Secrets**: Only needed for mobile builds (EXPO_TOKEN)

For detailed setup instructions, see the deployment documentation.
