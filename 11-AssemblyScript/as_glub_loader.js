const loader = require("@assemblyscript/loader");
const fs = require('fs');
var module;

const importObject = {
    as_glub: {
        console_log: (str_index) => {
            console.log(module.exports.__getString(str_index));
        }
    }
};

(async () => {
    let wasm = fs.readFileSync('as_glub.wasm');
    module = await loader.instantiate(wasm, importObject);
    module.exports.glubGlub();
})();