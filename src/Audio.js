import PropTypes from 'prop-types';
import React from 'react';
import {NativeModules, NativeEventEmitter} from 'react-native';
import {requireNativeComponent} from 'react-native';

// Executa a funcão e devolve o returno via callcack.
// Documentacao: native-components-ios
const AudioNative = NativeModules.AudioView;
const AudioEventEmitter = NativeModules.AudioEventEmitter;

//
const AudioEvents = new NativeEventEmitter(AudioEventEmitter);

// subscribe to event
// AudioEvents.addListener('onStop', (res) => console.log(' Evento emitido', res));

// console.log('--->', AudioEventEmitter);
// console.log(AudioEvents);

// AudioNative.onFinishCallback((e, str) =>
//   console.log('Chamando o Callback', str),
// );
// AudioEventEmitter.showFile();

const AudioComponent = ({...props}) => {
  return <RNAudio {...props} />;
};

AudioComponent.propTypes = {
  // onDoSomething: PropTypes.func,
};

var RNAudio = requireNativeComponent('Audio', AudioComponent);

export {
  AudioComponent as Audio,
  AudioEvents as AudioRecoder,
  AudioEventEmitter,
};
