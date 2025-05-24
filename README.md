# Jem's Disco

This project is intended to be a simple, yet well architected, demonstration of how to control a Raspberry Pi Pico 2W peripheral with bluetooth. The project consists of two parts - the RPi firmware, written in C using the Raspberry Pi Pico SDK and FreeRTOS; and the mobile app, written in Dart using Flutter and the Material UI framework. The peripheral which is controlleed is a WS2812b chain of LEDs. The mobile app allows the user to select colours, patterns, speeds and brightness.

## Overview

The system works by having the mobile app send commands to the Pico. A task in the Pico firmware is dedicated to listening for commands and adding them to a fifo queue. A second task loads the data to be sent to the WS2812b LED chain, kicks off a DMA process to play out the data to the chain and then waits for the DMA to complete, once DMA is complete there is a further delay which is configurable using the `speed` parameter - see the command protocol below. 

TODO: this would be better if the 10ms delay was kicked off at the start of the DMA.

## Command Protocol

A command consists of two 8 bit bytes. The first byte indicated the parameter which is to be set by the command:

* 0x01 - Pattern (fixed colours are special cases of patterns)
* 0x02 - Speed 
* 0x03 - Brightness

The second byte is simply the value which the parameter should be set to. The pattern value is the index of the pattern in the `pattern_table` which is defined towards the bottom of `pattern.c`. The `speed` value is the number of multiples of 5ms the pattern loop will wait between pattern steps. The `brightness` value is applied within the pattern loop
