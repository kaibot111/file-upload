const fs = require('fs');
const path = require('path');

// CONFIG
const GAMES_DIR = path.join(__dirname, 'public', 'games');
const OUTPUT_FILE = path.join(__dirname, 'public', 'games.json');
const IMAGE_TYPES = ['.png', '.jpg', '.jpeg', '.gif', '.webp'];

// 1. Start Scanning
console.log("🔍 Scanning for games...");
const games = [];

if (fs.existsSync(GAMES_DIR)) {
    const folders = fs.readdirSync(GAMES_DIR);

    folders.forEach(folder => {
        const folderPath = path.join(GAMES_DIR, folder);
        
        // Check if it's actually a folder
        if (fs.statSync(folderPath).isDirectory()) {
            const files = fs.readdirSync(folderPath);

            // A. Find the Image (The only image in the folder)
            const imageFile = files.find(file => 
                IMAGE_TYPES.includes(path.extname(file).toLowerCase())
            );

            // B. Find the Game File (usually index.html, but we look for any .html)
            const htmlFile = files.find(file => path.extname(file) === '.html');

            if (imageFile && htmlFile) {
                console.log(`✅ Found: ${folder}`);
                games.push({
                    name: folder.replace(/-/g, ' '), // Turns "super-mario" into "super mario"
                    path: `/games/${folder}/${htmlFile}`,
                    image: `/games/${folder}/${imageFile}`
                });
            } else {
                console.log(`⚠️ Skipped ${folder}: Missing image or .html file`);
            }
        }
    });
}

// 2. Save the list
fs.writeFileSync(OUTPUT_FILE, JSON.stringify(games, null, 2));
console.log(`🎉 Done! Found ${games.length} games.`);
