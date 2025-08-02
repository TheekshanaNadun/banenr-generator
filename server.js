const express = require('express');
const puppeteer = require('puppeteer');

const app = express();
app.use(express.json({ limit: '10mb' }));

// Simple root route for health check
app.get('/', (req, res) => {
  console.log('[INFO] Root path accessed');
  res.send('Puppeteer server is running');
});

app.post('/generate', async (req, res) => {
  console.log('[INFO] /generate route hit');

  const { html } = req.body;

  if (!html) {
    console.log('[ERROR] Missing HTML in request body');
    return res.status(400).send('Missing HTML');
  }

  console.log('[INFO] Received HTML length:', html.length);

  try {
    const browser = await puppeteer.launch({ headless: 'new', args: ['--no-sandbox'] });
    console.log('[INFO] Puppeteer launched');

    const page = await browser.newPage();
    console.log('[INFO] New page created');

    await page.setContent(html, { waitUntil: 'networkidle0' });
    console.log('[INFO] Page content set');

    const buffer = await page.screenshot({ type: 'png', fullPage: true });
    console.log('[INFO] Screenshot taken');

    await browser.close();
    console.log('[INFO] Puppeteer browser closed');

    res.set('Content-Type', 'image/png');
    res.send(buffer);
    console.log('[INFO] Response sent with image');

  } catch (error) {
    console.error('[ERROR] Puppeteer error:', error);
    res.status(500).send('Error generating image');
  }
});

// Listen on all interfaces - important for CapRover!
app.listen(3000, '0.0.0.0', () => {
  console.log('HTML-to-Image API running on port 3000');
});
