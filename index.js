// Libraries
import { Client, Events, GatewayIntentBits } from "discord.js";
import self from "./settings.js";
import connect, { Connect } from "./Classes/connect.js"

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

// Interaction Listener
client.on(Events.InteractionCreate, async (interaction) => {
  if (!interaction.isChatInputCommand()) return;

  switch (interaction.commandName) {
    case "kick": {
      const placeId = interaction.options.getInteger("placeid");
      const userId = interaction.options.getNumber("userid");
      const session = new Connect(placeId, userId)

      await interaction.reply({
        content: `Kicking user ID: \`${userId}\` from place ID: \`${placeId}\`...`,
        ephemeral: true,
      });
      
      session.start() 
      break;
    }

    case "ban": {
      // @Varibles
      const placeId = interaction.options.getInteger("placeid");
      const userId = interaction.options.getNumber("userid");

      const banLength = interaction.options.getNumber("ban-length");
      const session = new Connect(placeId, userId, banLength)

      // Waitting for bot response
      await interaction.reply({
        content: `Banning user ID: \`${userId}\` from place ID: \`${placeId}\` for \`${banLength}\`...`,
        ephemeral: true,
      });

      session.start()
      break;
    }
  }
});

client.login(token);
