---
name: opis-frontend-build
description: Build OPIS frontend applications. Use when working with opis-web (JavaScript/Webpack) or opis-process-reporting-widget (React/TypeScript/Vite). Covers npm commands, bundling, and frontend testing.
allowed-tools: Bash, Read, Glob, Grep
---

# OPIS Frontend Build Skill

## Frontend Projects

### opis-web (Main Web Application)
- **Stack**: JavaScript ES6, Webpack, Mocha/Chai
- **Location**: `opis-web/`

```bash
# Install dependencies
npm install

# Development server
npm run dev

# Production build
npm run build

# Run tests
npm test
npm run coverage
```

### opis-process-reporting-widget (React Dashboard)
- **Stack**: React 18, TypeScript, Vite, Vitest, Ant Design
- **Location**: `opis-process-reporting-widget/`

```bash
# Install dependencies
npm install

# Development server
npm run dev

# Production builds
npm run build              # Standard build
npm run build:production   # Production optimized
npm run build:debug        # Debug build

# Testing
npm test                   # Run tests
npm run test:coverage      # With coverage
npm run test:jenkins       # CI mode

# Code quality
npm run lint               # ESLint
npm run check-types        # TypeScript checking

# Preview production build
npm run preview
```

## Project Structure

### opis-web
```
opis-web/
├── package.json
├── webpack.config.js
├── src/
│   ├── index.js
│   ├── components/
│   └── styles/
├── test/
└── dist/              # Build output
```

### opis-process-reporting-widget
```
opis-process-reporting-widget/
├── package.json
├── vite.config.ts
├── tsconfig.json
├── src/
│   ├── App.tsx
│   ├── components/
│   ├── hooks/
│   ├── services/
│   └── types/
├── test/
└── dist/              # Build output
```

## Common Tasks

### Add New Dependency
```bash
npm install <package>           # Runtime dependency
npm install -D <package>        # Dev dependency
```

### Update Dependencies
```bash
npm update
npm audit fix                   # Fix vulnerabilities
```

### Clean Build
```bash
rm -rf node_modules dist
npm install
npm run build
```

## TypeScript Configuration

Key `tsconfig.json` settings for opis-process-reporting-widget:
- Strict mode enabled
- JSX preserved for React
- Path aliases configured

## Troubleshooting

### Node Version Issues
Ensure correct Node version (check `.nvmrc` if exists):
```bash
nvm use
```

### Module Resolution Errors
Clear cache and reinstall:
```bash
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Vite Build Issues
Check for circular dependencies or missing types.

For Ant Design component usage, see [antd-components.md](antd-components.md).
