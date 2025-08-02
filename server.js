const express = require('express');
const puppeteer = require('puppeteer');
const app = express();

app.use(express.json({ limit: '10mb' }));

app.post('/generate', async (req, res) => {
  console.info('[INFO] /generate route hit');
  const { html } = req.body;
  if (!html) return res.status(400).send('Missing HTML');

  try {
    const browser = await puppeteer.launch({
      headless: 'new',
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'networkidle0' });
    const buffer = await page.screenshot({ type: 'png', fullPage: true });

    await browser.close();

    res.set('Content-Type', 'image/png');
    res.send(buffer);
  } catch (err) {
    console.error('[ERROR] Puppeteer error:', err);
    res.status(500).send('Error generating image');
  }
});

app.listen(3000, () => console.log('HTML-to-Image API running on port 3000'));
