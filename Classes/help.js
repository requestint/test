import fs from 'fs'
import path from 'path'
import settings from '../settings.js';

/*
  @function GetBotClassApplications 

  @Description 
    This function goes to your requested decicated tredectory
    storage or location to get all files, scripts or anything stored
    aslong as it's in the given Directory

  @Priameters 
    StrClassPathDir : str / string; This defines where it's start path is defined
*/
function GetBotClassApplications(StrClassPathDir) {
  // Varibles
  const fileClassDir = fs.readdirSync(StrClassPathDir, { withFileTypes : true });
  const Classes = [];
  const DiscoveredPath = ""
  /*
    Now that we've made the nesscary varibles that we've imported
    from our settings we can now go through and use our path and fs package
    to go through can conduct a search through the directorie's files
  */

    for (const app of fileClassDir) {
      if (app.isDirectory()) { // < makes the decision for if it's in a certain Directory
        Classes.push(...GetBotClassApplications(path.join(StrClassPathDir, app.name)))
      }  

      else if (app.isFile() && path.extname(app.name) === '.js') {
        Classes.push(path.join(StrClassPathDir, app.name))
      }

      // other wise we'll append / add the file to the classes table
    }

    // returning all found classes
    return Classes
}
export class Help {
  constructor(message) {
    this.message = message;
    this.applications = GetBotClassApplications('./Classes')
  }

  start() {
    this.message.reply(this.message.reply("```json\n" + JSON.stringify(this.applications, null, 2) + "\n```"));
    return this
  }
}