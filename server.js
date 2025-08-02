const express = require('express');
const { spawn } = require('child_process');

const app = express();
app.use(express.json({ limit: '10mb' }));

app.post('/generate', (req, res) => {
  const { html } = req.body;

  if (!html) {
    console.warn('[WARN] Missing HTML in request body');
    return res.status(400).send('Missing HTML');
  }

  console.info('[INFO] Generating image from HTML, length:', html.length);

  // Spawn wkhtmltoimage process
  const wkProcess = spawn('wkhtmltoimage', ['--quality', '100', '-', '-']); 
  // '-' means read HTML from stdin and output image to stdout

  let chunks = [];
  let errorChunks = [];

  // Collect stdout chunks (image data)
  wkProcess.stdout.on('data', (chunk) => {
    chunks.push(chunk);
  });

  // Collect stderr chunks (errors)
  wkProcess.stderr.on('data', (chunk) => {
    errorChunks.push(chunk);
  });

  wkProcess.on('error', (err) => {
    console.error('[ERROR] wkhtmltoimage spawn error:', err);
    res.status(500).send('Error generating image');
  });

  wkProcess.on('close', (code) => {
    if (code !== 0) {
      const errorMsg = Buffer.concat(errorChunks).toString() || `Exit code: ${code}`;
      console.error('[ERROR] wkhtmltoimage failed:', errorMsg);
      return res.status(500).send('Error generating image');
    }

    const buffer = Buffer.concat(chunks);
    console.info('[INFO] Image generated successfully, sending response');
    res.set('Content-Type', 'image/png');
    res.send(buffer);
  });

  // Write the HTML to stdin of wkhtmltoimage
  wkProcess.stdin.write(html);
  wkProcess.stdin.end();
});

// Optional error middleware
app.use((err, req, res, next) => {
  console.error('[ERROR] Unhandled error:', err);
  res.status(500).send('Internal Server Error');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`HTML-to-Image API running on port ${PORT}`));
