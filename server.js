const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

console.log("Server berjalan di port 8080...");

wss.on('connection', (ws) => {
    ws.on('message', (data) => {
        // Broadcast ke semua yang konek
        wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(data.toString());
            }
        });
    });
});