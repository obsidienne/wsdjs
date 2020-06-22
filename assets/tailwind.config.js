module.exports = {
    purge: [
        "../**/*.html.eex",
        "../**/*.html.leex",
        "../**/views/**/*.ex",
        "../**/live/**/*.ex",
        "./js/**/*.js"
    ],
    theme: {
        aspectRatio: { // defaults to {}
            'none': 0,
            'square': [1, 1], // or 1 / 1, or simply 1
            '16/9': [16, 9],  // or 16 / 9
            '4/3': [4, 3],    // or 4 / 3
            '21/9': [21, 9],  // or 21 / 9
        },
    },
    variants: {
        aspectRatio: ['responsive']
    },
    plugins: [
        require('tailwindcss-aspect-ratio'),
        require('tailwindcss-animatecss')({
            classes: ['animate__animated', 'animate__fadeIn', 'animate__bounceIn', 'animate__lightSpeedOut'],
            variants: ['responsive', 'hover', 'reduced-motion'],
        }),
    ]
};