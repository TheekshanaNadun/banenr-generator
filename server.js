const express = require('express');
const puppeteer = require('puppeteer');

const app = express();
app.use(express.json());

app.post('/generate', async (req, res) => {
  const html = req.body.html || '<h1>Hello</h1>';

  try {
    const browser = await puppeteer.launch({
      executablePath: process.env.PUPPETEER_EXECUTABLE_PATH,
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();
    await page.setContent(html);
    const screenshot = await page.screenshot();

    await browser.close();
    res.setHeader('Content-Type', 'image/png');
    res.send(screenshot);
  } catch (error) {
    console.error('[ERROR] Puppeteer error:', error);
    res.status(500).send('Error generating image');
  }
});

app.listen(3000, () => {
  console.log('HTML-to-Image API running on port 3000');
});
