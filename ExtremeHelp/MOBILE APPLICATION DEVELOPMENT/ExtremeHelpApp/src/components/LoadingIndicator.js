import React from 'react';
import { View, ActivityIndicator, Text, StyleSheet, Modal } from 'react-native';
import { APP_COLORS } from '../utils/constants';

export default function LoadingIndicator({ message }) {
  return (
    <Modal
      transparent={true}
      animationType="fade"
      visible={true}
    >
      <View style={styles.container}>
        <View style={styles.box}>
            <ActivityIndicator size="large" color={APP_COLORS.primary} />
            {message && <Text style={styles.message}>{message}</Text>}
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.4)', // Fundo escuro semi-transparente
  },
  box: {
    backgroundColor: APP_COLORS.white,
    borderRadius: 12,
    padding: 25,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: "#000",
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
  },
  message: {
    marginTop: 15,
    fontSize: 16,
    color: APP_COLORS.darkGray,
    fontWeight: '500',
  },
});