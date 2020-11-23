module.exports = {
    purge: [
        "../**/*.html.eex",
        "../**/*.html.leex",
        "../**/views/**/*.ex",
        "../**/live/**/*.ex",
        "./js/**/*.js"
    ],
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('@tailwindcss/aspect-ratio'),
        require('tailwindcss-animatecss')({
            classes: ['animate__animated', 'animate__swing'],
            variants: ['responsive', 'hover', 'reduced-motion'],
        }),
    ]
};