import React from 'react';
import { TextInput, StyleSheet, View, Text } from 'react-native';
import { APP_COLORS } from '../utils/constants';
import { Ionicons } from '@expo/vector-icons'; // Certifique-se de que @expo/vector-icons está instalado

export default function CustomInput({ 
    label, 
    value, 
    onChangeText, 
    placeholder, 
    secureTextEntry, 
    keyboardType, 
    autoCapitalize, 
    multiline, 
    numberOfLines, 
    error, 
    style, 
    containerStyle, 
    leftIcon, 
    rightIcon, 
    editable = true, 
    onFocus, 
    onBlur 
}) {
  return (
    <View style={[styles.inputOuterContainer, containerStyle]}>
      {label && <Text style={styles.label}>{label}</Text>}
      <View style={[styles.inputContainer, error ? styles.inputContainerError : null, style]}>
        {leftIcon && <View style={styles.iconWrapper}>{leftIcon}</View>}
        <TextInput
          style={styles.input}
          value={value}
          onChangeText={onChangeText}
          placeholder={placeholder || label}
          placeholderTextColor={APP_COLORS.mediumGray}
          secureTextEntry={secureTextEntry}
          keyboardType={keyboardType}
          autoCapitalize={autoCapitalize || 'sentences'}
          multiline={multiline}
          numberOfLines={numberOfLines}
          selectionColor={APP_COLORS.primary}
          editable={editable}
          onFocus={onFocus}
          onBlur={onBlur}
        />
        {rightIcon && <View style={styles.iconWrapper}>{rightIcon}</View>}
      </View>
      {error && <Text style={styles.errorText}>{error}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  inputOuterContainer: {
    width: '100%',
    marginVertical: 10,
  },
  label: {
    fontSize: 14,
    color: APP_COLORS.darkGray,
    marginBottom: 6,
    fontWeight: '600',
    paddingLeft: 5,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: APP_COLORS.white,
    borderWidth: 1.5,
    borderColor: APP_COLORS.mediumGray,
    borderRadius: 12,
    paddingHorizontal: 12,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1, },
    shadowOpacity: 0.05,
    shadowRadius: 2.00,
    elevation: 1,
  },
  inputContainerError: {
    borderColor: APP_COLORS.danger,
  },
  iconWrapper: {
    paddingHorizontal: 5,
  },
  input: {
    flex: 1,
    paddingVertical: 14,
    fontSize: 16,
    color: APP_COLORS.darkGray,
  },
  errorText: {
    color: APP_COLORS.danger,
    fontSize: 12,
    marginTop: 5,
    paddingLeft: 10,
  },
});