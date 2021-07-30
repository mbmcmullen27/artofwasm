const fs = require('fs');
const loader = require('@assemblyscript/loader');

(async () => {
    let wasm = fs.readFileSync('vector_loader.wasm');
    // instantiate the module using the loader
    let module = await loader.instantiate(wasm);

    // module.exports.Vector2D mirrors the AssemblyScript class.
    let { Vector2D, Vector3D} = loader.demangle(module).exports;

    let vector1 = new Vector2D(3, 4);
    let vector2 = new Vector2D(4, 5);
    let vector3 = new Vector3D(5, 6, 7);

    vector2.y += 10;
    vector2.add(vector1);
    vector3.z++;

    console.log(`
        vector1=(${vector1.x}, ${vector1.y})
        vector2=(${vector2.x}, ${vector2.y})
        vector3=(${vector3.x}, ${vector3.y}, ${vector3.z})

        vector1.magnitude=${vector1.Magnitude()}
        vector2.magnitude=${vector2.Magnitude()}
        vector2.magnitude=${vector3.Magnitude()}
    `)
})();