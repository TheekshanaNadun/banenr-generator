app.post('/generate', async (req, res) => {
  console.info('[INFO] /generate route hit');
  const { html } = req.body;
  if (!html) return res.status(400).send('Missing HTML');

  try {
    const browser = await puppeteer.launch({
      args: ['--no-sandbox', '--disable-setuid-sandbox'],
      headless: true,
    });

    const page = await browser.newPage();
    await page.goto('about:blank');                     // This line fixes the error
    await page.setContent(html, { waitUntil: 'domcontentloaded' });

    const buffer = await page.screenshot({ type: 'png', fullPage: true });
    await browser.close();

    res.set('Content-Type', 'image/png');
    res.send(buffer);
  } catch (err) {
    console.error('[ERROR] Puppeteer error:', err);
    res.status(500).send('Error generating image');
  }
});
