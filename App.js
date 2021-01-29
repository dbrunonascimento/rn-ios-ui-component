/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {useEffect} from 'react';
import {SafeAreaView, StatusBar, Button} from 'react-native';

import {gql, useMutation} from '@apollo/client';

import {
  ApolloClient,
  InMemoryCache,
  ApolloProvider,
  HttpLink,
} from '@apollo/client';

import {createUploadLink} from 'apollo-upload-client';
import {ReactNativeFile} from 'apollo-upload-client';
import {Audio, AudioRecoder} from './src/Audio';

const client = new ApolloClient({
  cache: new InMemoryCache(),
  link: createUploadLink({
    uri: 'http://localhost:4000/graphql',
  }),
});

const MUTATION = gql`
  mutation UploadFile($file: Upload!) {
    uploadFile(file: $file)
  }
`;

const Wrapper = () => {
  const [mutate] = useMutation(MUTATION);

  const upload = () => {
    console.log('OK');

    AudioRecoder.addListener('onStop', (res) => {
      const uri = res.file || '';

      console.log('Evento emitido :D', uri);

      const file = new ReactNativeFile({
        uri,
        name: 'coisa2.m4a',
        type: 'audio/m4a',
      });

      // console.log(file);

      mutate({variables: {file}}).then((data) => {
        console.log(data);
      });
    });
  };

  useEffect(() => {
    upload();
  }, []);

  return (
    <>
      <Audio style={{backgroundColor: '#f00', width: 300, height: 300}} />
      {/* <Button onPress={uploadTeste} title="Upload" /> */}
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
