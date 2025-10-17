// Libraries
import { Client, Events, GatewayIntentBits } from "discord.js";
import self from "./settings.js";
import { Connect } from "./Classes/connect.js"
import { Clear } from "./Classes/clear.js";

// Varibles
const token = self.PrivateToken;
const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
  ],
});


// Functions

// Waiting for the event client to be ready
client.once(Events.ClientReady, (c) => {
  console.log(`Ready! Logged in as ${c.user.tag}`);
});


// Message Listener (FOR CLEAR COMMAND ONLY)
client.on(Events.MessageCreate, async (message) => {
  if (!message.content.includes(self.prefix, 1)) return;
  
  if (message.content.includes('Clear')) {
    // @varibles
    const Class = new Clear(message)
    

    Class.start()
  } 
})
// Interaction Listener
client.on(Events.InteractionCreate, async (interaction) => {
  if (!interaction.isChatInputCommand()) return;
  if (!interaction.member.roles.cache.some(role => role.name === "RemoteGameAccess")) return;

  console.log(!interaction.member.roles.cache.some(role => role.name === "RemoteGameAccess"))
  
  switch (interaction.commandName) {
    case "kick": {
      const placeId = interaction.options.getString("placeid");
      const userId = interaction.options.getString("userid");
      const session = Connect.default ||new Connect("Kick", placeId, userId);
      
      console.log(typeof(session))
      await interaction.reply({
        content: `Kicking user ID: \`${userId}\` from place ID: \`${placeId}\`...`,
        ephemeral: true,
      });
      

      session.start() 
      break;
    }

    case "ban": {
      // @Varibles
      const placeId = interaction.options.getString("placeid");
      const userId = interaction.options.getString("userid");

      const banLength = interaction.options.getString("ban-length");
      const session = Connect.default ||new Connect("Ban", placeId, userId, banLength);

      // Waitting for bot response
      await interaction.reply({
        content: `Banning user ID: \`${userId}\` from place ID: \`${placeId}\` for \`${banLength}\`...`,
        ephemeral: true,
      });

      session.start()
      break;
    }

    case "unban": {
       // @Varibles
      const placeId = interaction.options.getString("placeid");
      const userId = interaction.options.getString("userid");
      const session = Connect.default ||new Connect("UnBan", placeId, userId);

      // Waitting for bot response
      await interaction.reply({
        content: `UnBanning user ID: \`${userId}\` from place ID: \`${placeId}\``,
        ephemeral: true,
      });

      session.start()
      break;
    }

    case "getmessages": {
      const placeId = interaction.options.getString("placeid");
      const userId = interaction.options.getString("userid");
      const session = Connect.default ||new Connect("Getmessages", placeId, userId);

      // Waitting for bot response
      await interaction.reply({
        content: `Getting user messages from userid: \`${userId}\` from place ID: \`${placeId}\``,
        ephemeral: true,
      });

      session.start()
      break;
    }
  }
});

client.login(token);
