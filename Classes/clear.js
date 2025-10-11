export class Clear {
    
  constructor(message) {
    this.message = message;
  }

  start() {
    if (!this.message.member.permissions.has('ManageMessages')) {
            return message.reply("You don't have permission to do that.");
        }

        try {
            (async () => {
                const messages = await this.message.channel.messages.fetch({ limit: 100 });
                await this.message.channel.bulkDelete(messages, true);
            })();

            // sending response
            this.message.channel.send("✅ Cleared recent messages.").then(msg => {
                setTimeout(() => msg.delete(), 5000); // Auto-delete confirmation
            });

            // Adding a function / listener called catch to get any error response
        } catch (err) {
            console.error(err);
            this.message.reply("❌ Failed to clear messages. Make sure they're not older than 14 days.");
        }
  }
}
