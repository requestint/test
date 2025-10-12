// libraries
import { Client, GatewayIntentBits, Role, User } from "discord.js";
import { assert, log, table } from "node:console";
import { request } from "node:http";
import { time } from "node:console";

// Json Files
import self from './settings.js'
import { Save } from "./Classes/save.js";
import settings from "./settings.js";



// Varibles
console.warn(self)

// Modules

// Tables / arrays 
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
    ],
});

// Functions

async function loadAndRunCommand(commandName, message) {
  try {
    // import { Connect } from "./Classes/Connect.js";
    console.warn('attempting to get module : ' + `C:/Users/zjara/OneDrive/Desktop/DiscordBotCode/LiveModeration/Classes/${commandName}.js`)
    const module = await import(`./Classes/${commandName}.js`);
    // const module = SetPath(commandName)
    const ClassName = module.default || module[capitalize(commandName)];

    // if (module) {throw new Error(typeof module)}

    if (typeof ClassName !== 'function') {
      throw new Error(`No valid class export found in ${commandName}.js`);
    }

    const instance = new ClassName(message);

    console.log('loaded class instance!')

    instance.start();
  } catch (err) {
    console.error(err);
    message.reply("❌ Command not found or failed to load.");
  }
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

/*
    Establishing connection on the bot, once connected
    we'll establish a connection to the roblox server
*/

// * Establishing Bot Connection ->
client.once("ready", () => {
    console.log(`✅ Logged in as ${client.user.tag}`);
});


// * Message Listener
client.on("messageCreate", (message) => {
    // Varibles
    const commandName = message.content.slice(1).split(' ')[0].toLowerCase();
    const member = message.member;
    const targetRoleName = '.';
    
    if (message.author.bot) return;

    // Use `.some()` to check if any of the roles match the name
    if (!member.roles.cache.some(role => role.name === targetRoleName)) {
      return;
    }

    if (!message.content.includes(settings.prefix)) {
      message.channel.send('Seeking command!')
      return;
    } 

    message.reply(`Hello, ${targetRoleName}!`);

    
    try {
        message.reply("[LIVE MODERATION] " + message.content + " recieved! ")

        const newsave = new Save(message.content)

        // newsave.start()

        return loadAndRunCommand(commandName, message)
    } catch (err) {
        console.error(err);
        message.reply("❌ Command not found or failed to load.");
    }

});

client.login(self.PrivateToken);
