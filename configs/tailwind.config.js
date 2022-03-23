module.exports = {
  content: [
    './www/**/*.{html,js}',
  ],
  theme: {
    extend: {
      colors: {
        'black': '#000',
        'white': '#fff',
        'f1teams22': {
          mercedes  : '#6cd3bf',
          redbull  : '#1e5bc6',
          ferrari  : '#ed1c24',
          mclaren  : '#ed1c24',
          alpine  : '#2293d1',
          alphatauri  : '#4e7c9b',
          astonmartin  : '#2d826d',
          williams  : '#37bedd',
          alfaromeo  : '#b12039',
          haas  : '#b6babd'
        },
        'f1logos22': {
          f1  : '#FF1801',
          DHL_Yellow  : '#FFCC00',
          DHL_Red  : '#D40511',
          Rolex_Green  : '#006039',
          Rolex_Gold  : '#A37E2C',
          Emirates_Red  : '#D71A21',
          Pirelli_Red  : '#D52B1E',
          Pirelli_Yellow  : '#FED100',
        }
      },
    },
  },
  plugins: [require("daisyui")],
}
