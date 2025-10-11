import settings from "../settings.js";

export class Getplace {
  constructor(message) {
    this.message = message;
  }

  start() {
    this.message.reply(this.message.reply(settings.UniversalBotTestingPlace));
  }
}