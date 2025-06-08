import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { APP_COLORS } from '../utils/constants';

export default function EmptyState({ icon, title, message, button }) {
    return (
        <View style={styles.container}>
            {icon && <View style={styles.iconContainer}>{icon}</View>}
            <Text style={styles.title}>{title}</Text>
            <Text style={styles.message}>{message}</Text>
            {button && <View style={styles.buttonContainer}>{button}</View>}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: 30,
        backgroundColor: 'transparent',
    },
    iconContainer: {
        marginBottom: 20,
    },
    title: {
        fontSize: 20,
        fontWeight: 'bold',
        color: APP_COLORS.darkGray,
        textAlign: 'center',
        marginBottom: 8,
    },
    message: {
        fontSize: 16,
        color: APP_COLORS.mediumGray,
        textAlign: 'center',
        lineHeight: 22,
    },
    buttonContainer: {
        marginTop: 25,
    }
});