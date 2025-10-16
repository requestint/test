// Libraries
import { REST, Routes, SlashCommandBuilder } from "discord.js";
import self from "./settings.js";

// Array's
const commands = [

//    <<------------------------------------------>> 

  new SlashCommandBuilder()
    // Defining basic info
    .setName("kick")
    .setDescription("Attempt to Kick within an experience's server.")
    .addStringOption((option) =>
      option
        .setName("placeid")
        .setDescription("Your experience's place ID")
        .setRequired(true)
    )

    // Defining arguments
    .addStringOption((option) => 
        option
            .setName('userid')
            .setDescription('The UserId of the target')
            .setRequired(true)
    ),

//    <<------------------------------------------>> 

  new SlashCommandBuilder()
    // Defining basic info
    .setName("ban")
    .setDescription("Attempt to Ban within an experience's server.")
    .addStringOption((option) =>
      option
        .setName("placeid")
        .setDescription("Your experience's place ID")
        .setRequired(true)
    )

    // Defining arguments
    .addStringOption((option) => 
        option
            .setName('userid')
            .setDescription('The UserId of the target')
            .setRequired(true)
    )

    
    .addStringOption((option) => 
        option
            .setName('ban-length')
            .setDescription('Ban Length')
            .setRequired(true)
    ),

//    <<------------------------------------------>> 

  new SlashCommandBuilder()
    // Defining basic info
    .setName("unban")
    .setDescription("Attempt to UnBan within an experience's server.")
    .addStringOption((option) =>
      option
        .setName("placeid")
        .setDescription("Your experience's place ID")
        .setRequired(true)
    )

    // Defining arguments
    .addStringOption((option) => 
        option
            .setName('userid')
            .setDescription('The UserId of the target')
            .setRequired(true)
    ),

//    <<------------------------------------------>> 

  new SlashCommandBuilder()
    // Defining basic info
    .setName("getmessages")
    .setDescription("Attempt to Get a users messages within an experience's server.")
    .addStringOption((option) =>
      option
        .setName("placeid")
        .setDescription("Your experience's place ID")
        .setRequired(true)
    )

    // Defining arguments
    .addStringOption((option) => 
        option
            .setName('userid')
            .setDescription('The UserId of the target')
            .setRequired(true)
    ),


].map((command) => command.toJSON());

// Varibles
const token = self.PrivateToken;
const clientId = self.ClientId; 
const rest = new REST({ version: "10" }).setToken(token);

// Functions
(async () => {
  try {
    console.log(
      `Started refreshing ${commands.length} application (/) commands.`
    );

   
    await rest.put(Routes.applicationCommands(clientId), { body: commands });

    console.log(
      `Successfully reloaded ${commands.length} application (/) commands.`
    );
  } catch (error) {
    console.error(error);
  }
})();
