import PropTypes from 'prop-types';
import React from 'react';
import {NativeModules} from 'react-native';
import {requireNativeComponent} from 'react-native';

const AudioNative = NativeModules.Audio;

const AudioComponent = ({...props}) => {
  return <RNAudio {...props} />;
};

AudioComponent.propTypes = {
  // onDoSomething: PropTypes.func,
};

var RNAudio = requireNativeComponent('Audio', AudioComponent);

export const Audio = AudioComponent;
