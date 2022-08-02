import { cleanup, render, screen } from '@testing-library/react';
import IndividualPanel from './components/individualPanel'



afterEach(cleanup)


test('render Individual components', () => {
    render(<IndividualPanel/>)
    const individualElem = screen.getByText("Asym");
    expect(individualElem).toBeVisible();
  });