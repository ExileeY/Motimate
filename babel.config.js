module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    // react-native-worklets/plugin powers Reanimated 4 worklets (SDK 54 ships
    // Reanimated 4.1). Must remain the LAST plugin in the list.
    plugins: ['react-native-worklets/plugin'],
  };
};
