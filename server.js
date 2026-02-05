//
//  server.js
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-28.
//


const express = require('express');
const multer = require('multer');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(cors());

const upload = multer({ storage: multer.memoryStorage() });

// 🔽 PUT YOUR GITHUB INFO HERE
const GITHUB_USERNAME = "mkmsravanthi";
const GITHUB_REPO = "desh-i-boutique";
const GITHUB_TOKEN = "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";

app.post('/upload', upload.single('image'), async (req, res) => {
    if (!req.file) return res.status(400).json({ error: 'No image uploaded' });

    const base64 = req.file.buffer.toString('base64');
    //const fileName = `images/image_${Date.now()}.jpg`;
    const fileName = `image_${Date.now()}.jpg`;


    try {
        const response = await axios.put(
            `https://api.github.com/repos/${GITHUB_USERNAME}/${GITHUB_REPO}/contents/${fileName}`,
            {
                message: 'Upload image',
                content: base64
            },
            {
                headers: {
                    Authorization: `token ${GITHUB_TOKEN}`
                }
            }
        );

        res.json({ url: response.data.content.download_url });
    } catch (error) {
        console.error("GitHub error:", error.response?.data || error.message);
        res.status(500).json({ error: error.response?.data || error.message });
    }
});

app.listen(3000, '0.0.0.0', () => console.log('Server running on port 3000'));

const functions = require("firebase-functions");
const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "yourshop@gmail.com",
    pass: "app_password"
  }
});

exports.sendOrderEmail = functions.firestore
  .document("orders/{orderId}")
  .onCreate(async (snap) => {

    const order = snap.data();

    await transporter.sendMail({
      to: "customer@email.com",
      subject: `Order Confirmed - ${order.orderNumber}`,
      text: `Thank you! Total: kr ${order.total}`
    });
  });
