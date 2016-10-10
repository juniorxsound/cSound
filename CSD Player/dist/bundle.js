(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/*
var $ = require('jquery');
var csound = require('../lib/csound.js');
*/
//Global Variables
var playing = false;
var started = false;
var loaded = false;
var fname;

function moduleDidLoad() {}

function attachListeners() {
    document.getElementById('playButton').addEventListener('click', togglePlay);
    document.getElementById('files').addEventListener('change', handleFileSelect, false);
}

var count = 0;

function handleMessage(message) {
    var element = document.getElementById('console');
    element.value += message.data;
    element.scrollTop = 99999; // focus on bottom
    count += 1;
    if (count == 1000) {
        element.value = ' ';
        count = 0;
    }
}

function togglePlay() {
    if (loaded) {
        if (!playing) {
            if (started) {
                csound.Play();
            } else {
                csound.PlayCsd("local/" + fname)
                started = true;
            }
            document.getElementById('playButton').innerText = "Pause";
            playing = true;
        } else {
            csound.Pause()
            document.getElementById('playButton').innerText = "Play";
            playing = false;
        }
    }
}

function handleFileSelect(evt) {
    if (!loaded) {
        var files = evt.target.files;
        var f = files[0];
        var objectURL = window.URL.createObjectURL(f);
        csound.CopyUrlToLocal(objectURL, f.name);
        fname = f.name;
        loaded = true;
    } else {
        csound.updateStatus("to load a new CSD, first refresh page!")
    }
}

},{}]},{},[1]);
