# Expo HAS CHANGED

Read the exact versioned docs at https://docs.expo.dev/versions/v56.0.0/ before writing any code.

# JS/TS code style

- Prefer arrow functions: `const fn = (...) => {...}` instead of `function fn(...) {...}`, wherever possible.
- No trailing semicolons (`;`) at the end of statements, wherever possible.
- For large object literals, put each property on its own line — do NOT define them inline. e.g. write

  ```ts
  const obj = {
    property1: '',
    property2: '',
    property3: '',
  }
  ```

  rather than `const obj = { property1: '', property2: '', property3: '' }`.
