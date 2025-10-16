// Libraries
import settings from '../settings.js';

// Varibles
let IsConnectedToServer = false

// Tables


// Functions
async function request(param) {
  console.log('Sending data:', param);

  // http://localhost:3000/send-command < TO RUN LOCALLY FOR DEBUGGING PURPOSES BUT CAN'T REACH ROLBOX SESSIONS
  //'https://middleware.up.railway.app/send-command' < TO RUN PUBLICALLY & CAN RUN ROBLOX SESSIONS
 
  const res = await fetch(settings.PublicDir, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(param)

  });

  if (res.ok) {
    console.log('Command sent successfully : ' + res.text());
  } else {
    console.error('Failed to send command:', await res.text());
  }
}

export class Connect {
  constructor(...priameters) {
    console.log(...priameters)
    this.response = [...priameters];
  }

  start() {
    /// Sending nofication
    // this.message.reply('Connection is being established, arugments have been provided : ' + this.response)

    // Connecting to server on roblox
    /*
      we're gonna check if we're already connected to a server
      so we can then now remotely access a server session, but if we're not we'll connect
      to a new session
    */
    return request(this.response)
  }
}
