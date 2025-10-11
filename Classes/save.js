// Libaries


// tables
const msgs =  []

// Class's & functions
export class Save {
  constructor(message) {
    this.message = message;
    msgs.fill(JSON.stringify(msgs.length + 1), message)
  }

  start(index) {
    console.log(JSON.stringify(msgs))
    // return  this.message.text
  }
}