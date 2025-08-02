const express = require('express');
const { spawn } = require('child_process');

const app = express();
app.use(express.json({ limit: '10mb' }));

const log = (level, message, ...rest) => {
  const time = new Date().toISOString();
  console.log(`[${time}] [${level}] ${message}`, ...rest);
};

app.post('/generate', (req, res) => {
  const { html } = req.body;

  if (!html) {
    log('WARN', 'Missing HTML in request body');
    return res.status(400).send('Missing HTML');
  }

  log('INFO', 'Generating image from HTML, length:', html.length);

  const wkProcess = spawn('wkhtmltoimage', ['--quality', '100', '-', '-']);

  const chunks = [];
  const errorChunks = [];

  wkProcess.stdout.on('data', (chunk) => {
    chunks.push(chunk);
  });

  wkProcess.stderr.on('data', (chunk) => {
    errorChunks.push(chunk);
    log('DEBUG', 'wkhtmltoimage stderr:', chunk.toString());
  });

  wkProcess.on('error', (err) => {
    log('ERROR', 'wkhtmltoimage spawn error:', err);
    res.status(500).send('Error generating image');
  });

  wkProcess.on('close', (code) => {
    if (code !== 0) {
      const errorMsg = Buffer.concat(errorChunks).toString() || `Exit code: ${code}`;
      log('ERROR', 'wkhtmltoimage failed:', errorMsg);
      return res.status(500).send(errorMsg || 'Error generating image');
    }

    const buffer = Buffer.concat(chunks);
    log('INFO', 'Image generated successfully, sending response');
    res.set('Content-Type', 'image/png');
    res.send(buffer);
  });

  wkProcess.stdin.write(html);
  wkProcess.stdin.end();
});

// Catch all unhandled errors
app.use((err, req, res, next) => {
  log('ERROR', 'Unhandled error:', err);
  res.status(500).send('Internal Server Error');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, ()
