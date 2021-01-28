/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import {SafeAreaView, StatusBar, Text} from 'react-native';
import {Audio} from './src/Audio';

const App: () => React$Node = () => {
  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView>
        <Audio style={{backgroundColor: "#f00", width: 300, height: 300}} />
        <Text> WIP </Text>
      </SafeAreaView>
    </>
  );
};

export default App;
