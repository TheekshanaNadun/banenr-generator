const express = require('express');
const puppeteer = require('puppeteer');

const app = express();

app.use(express.json({ limit: '10mb' }));

app.post('/generate', async (req, res) => {
  console.info('[INFO] /generate route hit');
  const { html } = req.body;

  if (!html) {
    console.warn('[WARN] Missing HTML in request body');
    return res.status(400).send('Missing HTML');
  }

  console.info('[INFO] Received HTML length:', html.length);

  try {
    console.info('[INFO] Launching browser...');
    const browser = await puppeteer.launch({
      args: ['--no-sandbox', '--disable-setuid-sandbox'],
      headless: true,
    });

    const page = await browser.newPage();

    // Removed the problematic page.goto('about:blank')

    console.info('[INFO] Setting HTML content');
    await page.setContent(html, { waitUntil: 'domcontentloaded' });

    console.info('[INFO] Taking screenshot');
    const buffer = await page.screenshot({ type: 'png', fullPage: true });

    console.info('[INFO] Closing browser');
    await browser.close();

    console.info('[INFO] Sending image buffer');
    res.set('Content-Type', 'image/png');
    res.send(buffer);
  } catch (err) {
    console.error('[ERROR] Puppeteer error:', err);
    res.status(500).send('Error generating image');
  }
});

app.listen(3000, () => console.log('HTML-to-Image API running on port 3000'));
