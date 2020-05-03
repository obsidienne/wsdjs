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

if (!Element.prototype.toggleAttribute) {
    Element.prototype.toggleAttribute = function (name, force) {
        var forcePassed = arguments.length === 2;
        var forceOn = !!force;
        var forceOff = forcePassed && !force;

        if (this.getAttribute(name) !== null) {
            if (forceOn) return true;

            this.removeAttribute(name);
            return false;
        } else {
            if (forceOff) return false;

            this.setAttribute(name, "");
            return true;
        }
    };
}