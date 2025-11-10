// jest.setup.js

import { expect } from '@jest/globals';
import * as matchers from '@testing-library/jest-dom/matchers';
expect.extend(matchers);

global.__API_URL__ = 'http://localhost:5000';
