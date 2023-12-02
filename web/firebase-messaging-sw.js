importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCpj85ZkPrnrFyEidgCYpOC8CoziwmdIVw",
    authDomain: "doctor-application-4a3c6.firebaseapp.com",
    projectId: "doctor-application-4a3c6",
    storageBucket: "doctor-application-4a3c6.appspot.com",
    messagingSenderId: "20839637148",
    appId: "1:20839637148:web:2bebe7aa9a2cf8533b0d59",
    measurementId: "G-1VYPCMH3YK"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});