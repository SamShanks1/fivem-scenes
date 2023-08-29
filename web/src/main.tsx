import React from 'react';
import ReactDOM from 'react-dom/client';
import { VisibilityProvider } from './providers/VisibilityProvider';
import App from './components/App';
import './index.css';
import { MantineProvider, MantineThemeOverride } from '@mantine/core';
import { isEnvBrowser } from './utils/misc';
import { debugData } from './utils/debugData';

if (isEnvBrowser()) {
  const root = document.getElementById('root');

  // https://i.imgur.com/iPTAdYV.png - Night time img
  // root!.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")';
  // root!.style.backgroundSize = 'cover';
  // root!.style.backgroundRepeat = 'no-repeat';
  // root!.style.backgroundPosition = 'center';

    // This will set the NUI to visible if we are
  // developing in browser
  debugData([
    {
      action: "setVisible",
      data: true,
    },
  ]);
}

const customTheme: MantineThemeOverride = {
  colorScheme: 'dark',
};

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <MantineProvider withNormalizeCSS withGlobalStyles withCSSVariables theme={customTheme}>
      <VisibilityProvider>
        <App />
      </VisibilityProvider>
    </MantineProvider>
  </React.StrictMode>,
);
