const express = require('express');
const wkhtmltoimage = require('wkhtmltoimage');

const app = express();
app.use(express.json({ limit: '10mb' }));

app.post('/generate', (req, res) => {
  const { html } = req.body;

  if (!html) {
    return res.status(400).send('Missing HTML');
  }

  console.info('[INFO] Generating image from HTML');

  wkhtmltoimage.generate(html, { quality: 100 }, function (err, buffer) {
    if (err) {
      console.error('[ERROR] wkhtmltoimage error:', err);
      return res.status(500).send('Error generating image');
    }

    res.set('Content-Type', 'image/png');
    res.send(buffer);
  });
});

app.listen(3000, () => console.log('HTML-to-Image API running on port 3000'));
