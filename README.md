# The Art of WebAssembly

(pg. 15)
- __IIFE__ : _Immediately Invoked Function Expression_

I never knew that's what this pattern was called
```javascript
(async () => {})();
```

^^ https://github.com/tc39/proposal-do-expressions/issues/34
^^ proposal for a "do while" type syntax for IIFEs 

## Chapter Notes
___
### Introduction
    
    Java is a propireitary language and requires plugins to work with the browser. "... and the plugin technology eventually fell out of fasion when it became a security and malware nightmare." (pg. xxi)

- I wonder what this is referencing specifically, was it just there were no popular browsers that could handle java coming from a web server?

___
### Chapter 1 - An Introduction to WebAsssembly

    "WebAssembly is a virtual Instruction SSet Architeccture (ISA) for a stack machine." (pg. 13)

    
    "According to the Mozilla Foundation, WebAsssembly code runs between 10 percent and 800 percent faster than the equivalent JavaScript code." (pg.13)

- Author is on Nodejs version 12.14.0 (pg. 13)

___
### Chapter 2 - WAT text basics

[globals.wat](./2-basics/globals.js)
```js
import_i32: 5_000_000_000, // _ is ignored in numbers in JS and WAT
```
^^ neat note about underscore in js. I guess this makes sense since comma is an operator in JS (and C, and perl, not java though in java its a separator and doesn't evaluate to anything)

___
### Chapter 3 - Functions and Tables

[illegal_pop.wat](./3-functions/illegal_pop.wat)
- this is kind of unexpected scope behavior, this will throw an error when you attempt to compile. 
- Functions can't access variables that exist on the stack unless params are declared/expected
```Bash
wat2wasm illegal_pop.wat
```
[func_perform.js](./3-functions/func_perform.js)
- why'd he do this inside paren?
```JS
// destructure wasm_call and js_call from obj.instance.exports
    ({ wasm_call, js_call } = obj.instance.exports);
```

___
### Chapter 4 - Low-Level Bit Manipulation

    "floating-point numbers have a dedicated sign bit and therefore don't use 2s complement." (pg. 72)

### Chapter 7 - Web Applications

 Is [connect](https://www.npmjs.com/package/connect)
 an express.js product?     
    
    These middleware and libraries are officially supported by the Connect/Express team:

(pg.144 [add_message.html](./add_message.html))
- is there a reason for not declaring add_message_function before assigning? I think this would be hoisted but seems strange to do that on purpose.

### Chapter 8 - Working with the Canvas


    "The canvas element was introduced in 2004 by Applle for itts Safari web browser and adopted as a part of the HTML standard in 2006"

- this is shockingly recent for some reason