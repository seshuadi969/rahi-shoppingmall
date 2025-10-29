const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3000;

const server = http.createServer((req, res) => {
    let filePath = '';
    
    if (req.url === '/' || req.url === '/index.html') {
        filePath = path.join(__dirname, 'frontend/index.html');
    } else {
        filePath = path.join(__dirname, 'frontend', req.url);
    }
    
    fs.readFile(filePath, (err, content) => {
        if (err) {
            // Serve basic HTML if file not found
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Rahi Shopping Mall</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 40px; text-align: center; }
                        .container { max-width: 800px; margin: 0 auto; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1>🛍️ Rahi Shopping Mall</h1>
                        <p>Your application is running!</p>
                        <div style="margin: 20px; padding: 20px; border: 1px solid #ccc;">
                            <h3>Backend Status</h3>
                            <p id="status">Checking...</p>
                            <button onclick="checkBackend()">Check Backend</button>
                        </div>
                    </div>
                    <script>
                        async function checkBackend() {
                            try {
                                const response = await fetch('http://localhost:5000/api/health');
                                const data = await response.json();
                                document.getElementById('status').textContent = 'Backend Connected ✅';
                            } catch (error) {
                                document.getElementById('status').textContent = 'Backend Not Connected ❌';
                            }
                        }
                        checkBackend();
                    </script>
                </body>
                </html>
            `);
        } else {
            const ext = path.extname(filePath);
            let contentType = 'text/html';
            
            if (ext === '.css') contentType = 'text/css';
            if (ext === '.js') contentType = 'application/javascript';
            
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content);
        }
    });
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Frontend server running on http://${require('os').hostname()}:${PORT}`);
    console.log(`🌐 Access from anywhere: http://YOUR_SERVER_IP:${PORT}`);
});
