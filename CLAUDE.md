# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development
- `yarn start` - Start Expo development server with platform selection
- `yarn android` - Start on Android emulator
- `yarn ios` - Start on iOS simulator  
- `yarn web` - Start on web browser

### Testing
- `yarn test` - Run Jest tests
- `yarn test:watch` - Run tests in watch mode
- `yarn test:coverage` - Run tests with coverage report

### Code Quality
- `yarn lint` - Run ESLint
- `yarn lint:fix` - Run ESLint with auto-fix
- `yarn type-check` - Run TypeScript type checking

### Building
- `yarn build:web` - Build for web deployment (outputs to `dist/`)
- `yarn build:android` - Build Android app via EAS
- `yarn build:ios` - Build iOS app via EAS

## Architecture

This is a React Native + Expo cross-platform application that targets web, iOS, and Android.

### Key Technologies
- **Expo SDK 49** - Cross-platform framework
- **TypeScript** - Type safety throughout
- **React Navigation** - Navigation (native-stack)
- **Jest + React Native Testing Library** - Testing
- **Yarn 4.9.2** - Package manager (via corepack)

### Project Structure
- `src/components/` - Reusable UI components
- `src/screens/` - Screen-level components
- `src/hooks/` - Custom React hooks
- `src/types/` - TypeScript type definitions
- `src/utils/` - Utility functions
- `src/test/` - Test configuration and shared test utilities

### Path Aliases
TypeScript path aliases are configured for cleaner imports:
- `@/*` → `./src/*`
- `@/components/*` → `./src/components/*`
- `@/screens/*` → `./src/screens/*`
- `@/hooks/*` → `./src/hooks/*`
- `@/utils/*` → `./src/utils/*`
- `@/types/*` → `./src/types/*`

### Deployment
- **Web**: Auto-deploys to Netlify via GitHub integration
- **Mobile**: EAS builds triggered on main branch pushes
- Bundle identifier: `com.homeexec.crossplatform`

### Testing Configuration
- Jest with `jest-expo` preset
- Coverage threshold: 70% for branches, functions, lines, statements
- Test setup in `src/test/setup.ts` with Expo module mocks
- Supports both `.test.` and `.spec.` file naming