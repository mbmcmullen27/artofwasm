# The Art of WebAssembly

(pg. 15)
- __IIFE__ : _Immediately Invoked Function Expression_

I never knew what this pattern was called
```javascript
(async () => {})();
```

^^ https://github.com/tc39/proposal-do-expressions/issues/34
^^ proposal for a "do while" type syntax for IIFEs 

## Chapter Notes

### Chapter 2 - WAT text basics

[globals.wat](./2-basics/globals.js)
```js
import_i32: 5_000_000_000, // _ is ignored in numbers in JS and WAT
```
^^ neat note about underscore in js. I guess this makes sense since comma is an operator in JS (and C, and perl, not java though in java its a separator and doesn't evaluate to anything)