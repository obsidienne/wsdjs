window.formToObject = (form) => {
    let output = {};

    new FormData(form).forEach(
        (value, key) => {
            if (value) {
                // Check if property already exist
                if (Object.prototype.hasOwnProperty.call(output, key)) {
                    let current = output[key];
                    if (!Array.isArray(current)) {
                        current = output[key] = [current];
                    }
                    current.push(value); // Add the new value to the array.
                } else {
                    output[key] = value;
                }
            }
        }
    );

    return output;
}