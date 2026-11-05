/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        base: {
          950: '#0b1321',
          900: '#101a2b',
          850: '#17243a',
          800: '#1d3048',
          700: '#29435f',
          600: '#3b5a75',
        },
        cyan: {
          glow: '#67d8e8',
          deep: '#2b9fbb',
        },
        orange: {
          glow: '#f3a06f',
          deep: '#c8754f',
        },
        oxblood: {
          400: '#d27680',
          500: '#bd5d6b',
          600: '#984655',
          700: '#743644',
        },
        cream: '#e8eef5',
      },
      fontFamily: {
        sans: ['Space Grotesk', 'system-ui', 'sans-serif'],
        mono: ['IBM Plex Mono', 'JetBrains Mono', 'ui-monospace', 'monospace'],
      },
      boxShadow: {
        'hud-cyan': '0 0 0 1px rgba(103,216,232,0.25), 0 0 18px rgba(103,216,232,0.08)',
        'hud-orange': '0 0 0 1px rgba(243,160,111,0.25), 0 0 18px rgba(243,160,111,0.08)',
        'glow-cyan': '0 0 14px rgba(103,216,232,0.3)',
        'glow-orange': '0 0 14px rgba(243,160,111,0.3)',
      },
      animation: {
        'pulse-slow': 'pulse-slow 3s ease-in-out infinite',
        'scan': 'scan 4s linear infinite',
      },
      keyframes: {
        'pulse-slow': {
          '0%,100%': { opacity: '1' },
          '50%': { opacity: '0.6' },
        },
        'scan': {
          '0%': { transform: 'translateY(-100%)' },
          '100%': { transform: 'translateY(100%)' },
        },
      },
    },
  },
  plugins: [],
};
