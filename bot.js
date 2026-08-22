const TelegramBot = require("node-telegram-bot-api");
const fs = require("fs");

const TOKEN = "8854368089:AAGuSqO3TaPNTo1Ya6ojSf4YlNGQ71oiXM0";

// polling = sürekli dinler
const bot = new TelegramBot(TOKEN, { polling: true });

const DB_FILE = "db.json";

// DB oku
function loadDB() {
  if (!fs.existsSync(DB_FILE)) return [];
  return JSON.parse(fs.readFileSync(DB_FILE, "utf8"));
}

// DB yaz
function saveDB(data) {
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}

// yeni video kaydet
function addVideo(file_id, caption = "") {
  const db = loadDB();

  db.push({
    file_id,
    caption,
    time: Date.now()
  });

  saveDB(db);
  console.log("SAVED:", file_id);
}

// 🔥 YENİ MESAJLAR (kanala düşen video)
bot.on("channel_post", (msg) => {
  if (!msg.video) return;

  addVideo(msg.video.file_id, msg.caption || "");
});

// 🔥 BOT BAŞLARKEN "SON MESAJLARI DA AL"
async function loadHistory() {
  try {
    const updates = await bot.getUpdates({ limit: 100 });

    updates.forEach(u => {
      if (u.channel_post && u.channel_post.video) {
        addVideo(
          u.channel_post.video.file_id,
          u.channel_post.caption || ""
        );
      }
    });

    console.log("HISTORY LOADED");
  } catch (err) {
    console.log("history hata:", err.message);
  }
}

loadHistory();

console.log("BOT AKTİF - CANLI MOD");
