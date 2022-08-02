import { cleanup, render, screen } from '@testing-library/react';
import App from './App';

afterEach(cleanup)

test('render cohort panel', () => {
  render(<App />);
  const cohortElem = screen.getByText("Cohort");
  expect(cohortElem).toHaveClass("btn-primary");
});

test('render individual panel', () => {
    render(<App />);
    const individualElem = screen.getByText("Individual");
    expect(individualElem).toHaveClass("btn-secondary");
  });
