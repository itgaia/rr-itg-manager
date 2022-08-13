/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*',
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}

// module.exports = {
//   content: [
//     './app/views/**/*.html.erb',
//     './app/helpers/**/*.rb',
//     './app/assets/stylesheets/**/*.css',
//     './app/javascript/**/*.js'
//   ]
// }
