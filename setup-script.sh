#!/bin/bash

# Setup script for cross-platform React app in home-exec repo
set -e

# Get current repo info
CURRENT_REPO=$(git remote get-url origin)
echo "📁 Current repository: $CURRENT_REPO"

# Create project structure
echo "📁 Creating project structure..."
mkdir -p .github/workflows
mkdir -p src/{components,screens,hooks,utils,types,test}
mkdir -p assets

# Create all the configuration files
echo "📝 Creating configuration files..."

# package.json
cat > package.json << 'EOF'
{
  "name": "home-exec-cross-platform",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web",
    "build:web": "expo export:web",
    "build:android": "eas build --platform android",
    "build:ios": "eas build --platform ios",
    "submit:android": "eas submit --platform android",
    "submit:ios": "eas submit --platform ios",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "lint:fix": "eslint . --ext .js,.jsx,.ts,.tsx --fix",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "@expo/vector-icons": "^13.0.0",
    "@react-navigation/native": "^6.1.7",
    "@react-navigation/native-stack": "^6.9.13",
    "expo": "~49.0.0",
    "expo-constants": "~14.4.2",
    "expo-linking": "~5.0.2",
    "expo-router": "^2.0.0",
    "expo-splash-screen": "~0.20.5",
    "expo-status-bar": "~1.6.0",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "react-native": "0.72.3",
    "react-native-safe-area-context": "4.6.3",
    "react-native-screens": "~3.22.0",
    "react-native-web": "~0.19.6"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "@types/react": "~18.2.14",
    "@types/react-native": "~0.72.2",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.44.0",
    "eslint-config-expo": "^7.0.0",
    "jest": "^29.6.1",
    "jest-expo": "~49.0.0",
    "typescript": "^5.1.3"
  },
  "private": true
}
EOF

# app.config.js
cat > app.config.js << 'EOF'
export default {
  expo: {
    name: "Home Exec Cross Platform",
    slug: "home-exec-cross-platform",
    version: "1.0.0",
    orientation: "portrait",
    icon: "./assets/icon.png",
    userInterfaceStyle: "light",
    splash: {
      image: "./assets/splash.png",
      resizeMode: "contain",
      backgroundColor: "#ffffff"
    },
    assetBundlePatterns: [
      "**/*"
    ],
    ios: {
      supportsTablet: true,
      bundleIdentifier: "com.homeexec.crossplatform"
    },
    android: {
      adaptiveIcon: {
        foregroundImage: "./assets/adaptive-icon.png",
        backgroundColor: "#FFFFFF"
      },
      package: "com.homeexec.crossplatform"
    },
    web: {
      favicon: "./assets/favicon.png",
      bundler: "metro"
    },
    extra: {
      eas: {
        projectId: "your-project-id-here"
      }
    }
  }
};
EOF

# eas.json
cat > eas.json << 'EOF'
{
  "cli": {
    "version": ">= 5.2.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "simulator": true
      },
      "android": {
        "buildType": "apk"
      }
    },
    "production": {
      "autoIncrement": true,
      "cache": {
        "disabled": false
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your-apple-id@example.com",
        "ascAppId": "your-app-store-connect-app-id",
        "appleTeamId": "your-apple-team-id"
      },
      "android": {
        "serviceAccountKeyPath": "./google-service-account.json",
        "track": "internal"
      }
    }
  }
}
EOF

# App.tsx
cat > App.tsx << 'EOF'
import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, Platform } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Home Exec Cross-Platform App</Text>
      <Text style={styles.subtitle}>
        Running on: {Platform.OS}
      </Text>
      <Text style={styles.description}>
        This app will work on iOS, Android, and Web!
      </Text>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
    textAlign: 'center',
    color: '#333',
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 20,
  },
  description: {
    fontSize: 14,
    color: '#888',
    textAlign: 'center',
    fontStyle: 'italic',
  },
});
EOF

# GitHub Actions CI workflow
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop, feature/* ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'yarn'
        
    - name: Install dependencies
      run: yarn install --frozen-lockfile
      
    - name: Type check
      run: yarn type-check
      
    - name: Lint
      run: yarn lint
      
    - name: Run tests
      run: yarn test:coverage
      
  web-build:
    runs-on: ubuntu-latest
    needs: test
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Setup Expo CLI
      run: npm install -g @expo/cli
      
    - name: Build web
      run: npm run build:web
      
    - name: Upload web build artifacts
      uses: actions/upload-artifact@v3
      with:
        name: web-build
        path: dist/
EOF

# GitHub Actions Deploy workflow
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy-web:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Setup Expo CLI
      run: npm install -g @expo/cli
      
    - name: Build web
      run: npm run build:web
      
    - name: Deploy to Netlify
      uses: nwtgck/actions-netlify@v3.0
      with:
        publish-dir: './dist'
        production-branch: main
        github-token: ${{ secrets.GITHUB_TOKEN }}
        deploy-message: "Deploy from GitHub Actions"
        enable-pull-request-comment: false
        enable-commit-comment: true
        overwrites-pull-request-comment: true
      env:
        NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
        NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        
  build-mobile:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'yarn'
        
    - name: Install dependencies
      run: yarn install --frozen-lockfile
      
    - name: Setup Expo CLI
      run: yarn global add @expo/cli eas-cli
      
    - name: Authenticate with Expo
      run: expo login --non-interactive
      env:
        EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}
        
    - name: Build iOS
      run: yarn build:ios
      env:
        EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}
        
    - name: Build Android
      run: yarn build:android
      env:
        EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}
EOF

# TypeScript configuration
cat > tsconfig.json << 'EOF'
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true,
    "allowJs": true,
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "jsx": "react-jsx",
    "lib": ["dom", "esnext"],
    "moduleResolution": "node",
    "noEmit": true,
    "resolveJsonModule": true,
    "skipLibCheck": true,
    "target": "esnext",
    "baseUrl": "./",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/screens/*": ["./src/screens/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/types/*": ["./src/types/*"]
    }
  },
  "include": [
    "**/*.ts",
    "**/*.tsx",
    ".expo/types/**/*.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF

# Jest configuration
cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'jest-expo',
  transformIgnorePatterns: [
    'node_modules/(?!((jest-)?react-native|@react-native(-community)?)|expo(nent)?|@expo(nent)?/.*|@expo-google-fonts/.*|react-navigation|@react-navigation/.*|@unimodules/.*|unimodules|sentry-expo|native-base|react-native-svg)'
  ],
  setupFilesAfterEnv: ['<rootDir>/src/test/setup.ts'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/test/**/*',
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },
};
EOF

# ESLint configuration
cat > .eslintrc.js << 'EOF'
module.exports = {
  extends: ['expo', '@typescript-eslint/recommended'],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  rules: {
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    'react-hooks/exhaustive-deps': 'warn',
  },
  env: {
    node: true,
  },
};
EOF

# Create test setup file
cat > src/test/setup.ts << 'EOF'
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
EOF

# Create a basic test
cat > src/test/App.test.tsx << 'EOF'
import React from 'react';
import { render, screen } from '@testing-library/react-native';
import App from '../../App';

describe('App Component', () => {
  it('renders correctly', () => {
    render(<App />);
    expect(screen.getByText('Home Exec Cross-Platform App')).toBeTruthy();
  });

  it('displays platform information', () => {
    render(<App />);
    expect(screen.getByText(/Running on:/)).toBeTruthy();
  });
});
EOF

# Create README
cat > README.md << 'EOF'
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
EOF

# Create netlify.toml configuration
cat > netlify.toml << 'EOF'
[build]
  command = "yarn build:web"
  publish = "dist"

[build.environment]
  NODE_VERSION = "18"

# SPA redirect for React Router
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Security headers
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"

# Cache static assets
[[headers]]
  for = "/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
EOF

# Create .yarnrc.yml for Yarn configuration
cat > .yarnrc.yml << 'EOF'
nodeLinker: node-modules
enableGlobalCache: false
compressionLevel: mixed
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
yarn-debug.log*
yarn-error.log*

# Expo
.expo/
dist/
web-build/

# Native
*.orig.*
*.jks
*.p8
*.p12
*.key
*.mobileprovision

# Metro
.metro-health-check*

# Debug
yarn-debug.*
yarn-error.*

# macOS
.DS_Store
*.pem

# Local env files
.env*.local

# TypeScript
*.tsbuildinfo

# IDE
.vscode/
.idea/

# Testing
coverage/
EOF

echo "📦 Installing dependencies..."
yarn install

echo "✅ Project setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Review the generated files"
echo "2. Commit and push to GitHub:"
echo "   git add ."
echo "   git commit -m \"Add cross-platform React Native app with Expo\""
echo "   git push -u origin $BRANCH_NAME"
echo ""
echo "3. Set up Expo account and EAS:"
echo "   expo login"
echo "   eas init"
echo ""
echo "4. Set up Netlify (no secrets needed!):"
echo "   - Sign up at netlify.com with GitHub"
echo "   - Create new site from your home-exec repository"
echo "   - Configure: Build command 'yarn build:web', Publish dir 'dist'"
echo ""
echo "5. Configure GitHub secrets for mobile deployment:"
echo "   - EXPO_TOKEN (for mobile builds only)"
echo ""
echo "🚀 Ready to start developing!"
EOF

chmod +x setup-cross-platform-branch.sh