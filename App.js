/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {useEffect, useState} from 'react';
import {SafeAreaView, StatusBar, Button, Image} from 'react-native';
import RNFS from 'react-native-fs';

import {gql, useMutation} from '@apollo/client';

import {
  ApolloClient,
  InMemoryCache,
  ApolloProvider,
  HttpLink,
} from '@apollo/client';

import {createUploadLink, ReactNativeFile} from 'apollo-upload-client';
import {Audio, AudioRecoder} from './src/Audio';

// Para testar no dispositivo físivo voce deve informar um domínio
// com HTTPS ou um IP local na mesma rede.

const client = new ApolloClient({
  cache: new InMemoryCache(),
  link: createUploadLink({
    uri: 'http://192.168.0.4:4000/graphql',
  }),
})

const MUTATION = gql`
  mutation UploadFile($file: Upload!) {
    uploadFile(file: $file)
  }
`;

const Wrapper = () => {
  const [mutate] = useMutation(MUTATION);
  const [res, setRes] = useState('');

  const upload = () => {
    const uri = res.file || '';

    console.log('Evento emitido :D', uri);

    // RNFS.readDir('/var/mobile/Containers/Data/Application/1706A871-F827-4168-89D5-1C93CE5DE7B9/Documents/')
    //   .then((result) => {
    //     console.log('GOT RESULT', result);

    //     return Promise.all([RNFS.stat(result[0].path), result[0].path]);
    //   })
    //   .then((statResult) => {
    //     if (statResult[0].isFile()) {
    //       // if we have a file, read it
    //       return RNFS.readFile(statResult[1], 'utf8');
    //     }

    //     return 'no file';
    //   })
    //   .then((contents) => {
    //     // log the file contents
    //     console.log(contents);
    //   })
    //   .catch((err) => {
    //     console.log(err.message, err.code);
    //   });

    const file = new ReactNativeFile({
      uri,
      name: 'audiofile_2.m4a',
      type: 'audio/*',
    });

    console.log(file);

    mutate({variables: {file}})
      .then((data) => {
        console.log(data);
      })
      .catch((e) => {
        console.log(e);
      });
  };

  const addListener = () => {
    AudioRecoder.addListener('onStop', setRes);
  };

  useEffect(() => {
    addListener();
  }, []);

  return (
    <>
      <Audio style={{backgroundColor: '#f00', width: 300, height: 300}} />
      <Button onPress={upload} title="Upload" />
      {/* <Image
        style={{
          width: 66,
          height: 58,
        }}
        source={{
          uri: 'http://192.168.0.4:4000/images/ave.jpg',
        }}
      /> */}
    </>
  );
};

const App: () => React$Node = () => {
  return (
    <ApolloProvider client={client}>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView>
        <Wrapper />
      </SafeAreaView>
    </ApolloProvider>
  );
};

export default App;
