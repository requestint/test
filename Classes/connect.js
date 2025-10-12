// Libraries
import settings from '../settings.js';

// Varibles
let IsConnectedToServer = false

// Tables


// Functions
async function request(type, username, length, PlaceId) {
  console.log('Sending data:', {
    type: type,
    username: username,
    length: length,
    PlaceId: PlaceId
  });

  // http://localhost:3000/send-command < TO RUN LOCALLY FOR DEBUGGING PURPOSES BUT CAN'T REACH ROLBOX SESSIONS
  //'https://middleware.up.railway.app/send-command' < TO RUN PUBLICALLY & CAN RUN ROBLOX SESSIONS
 
  const res = await fetch(settings.PublicDir, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      type: type,
      username: username,
      length: length,
      PlaceId: PlaceId
    })

  });

  if (res.ok) {
    console.log('Command sent successfully : ' + res.text());
  } else {
    console.error('Failed to send command:', await res.text());
  }
}

export class Connect {
  constructor(message) {
    this.message = message;
  }

  start() {
    // Varibles

    /*
     We're now gonna sepreate the series of arguments so instead of it 
     being all one message it will be a split into mutltiple
     */

    const parsedmessage = this.message.content.trim()
    const args = parsedmessage.split(/\s+/)
    const MaliformedCryptedMessage = {
      "Command": args[1],
      "Server": args[2],
      "Username": args[3],
      "Length": args[4],
      "PlaceId": args[5]
    }

    /// Sending nofication
    this.message.reply('Connection is being established, arugments have been provided : ' + JSON.stringify(MaliformedCryptedMessage))

    // Connecting to server on roblox
    /*
      we're gonna check if we're already connected to a server
      so we can then now remotely access a server session, but if we're not we'll connect
      to a new session
    */
    return request(args[1], args[3], args[4], args[5])
  }
}
