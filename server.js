const express = require('express');
const puppeteer = require('puppeteer');

const app = express();

app.use(express.json({ limit: '10mb' }));

app.post('/generate', async (req, res) => {
  console.info('[INFO] /generate route hit');
  const { html } = req.body;
  if (!html) {
    return res.status(400).send('Missing HTML');
  }

  try {
    const browser = await puppeteer.launch({
      args: ['--no-sandbox', '--disable-setuid-sandbox'],
      headless: true,
    });

    const page = await browser.newPage();

    // Navigate to blank page first (helps avoid some timing issues)
    await page.goto('about:blank');

    // Set the provided HTML content
    await page.setContent(html, { waitUntil: 'domcontentloaded' });

    // Take a full page screenshot as PNG
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
