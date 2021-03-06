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
