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
