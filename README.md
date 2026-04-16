# 🔐 spki-pinning-toolkit

A simple toolkit to generate and manage **SPKI (Subject Public Key Info) pins** for SSL/TLS certificate pinning, with built-in support for **backup keys** and **safe rotation**.

---

## 🚀 Why SPKI Pinning?

Traditional certificate pinning breaks when certificates rotate (e.g., AWS ACM auto-renewal).

**SPKI pinning solves this by:**

* Pinning the **public key**, not the full certificate
* Allowing certificate renewal without breaking your app
* Supporting **controlled key rotation** with backup pins

> **Mental model:**
> *Pin keys you control, not certificates providers rotate.*

---

## ⚙️ Features

* ✅ Extract SPKI hash from any live domain
* 🔑 Generate backup keys for future rotations
* 📦 Output ready-to-use mobile pin configuration
* ☁️ Works seamlessly with AWS ALB + ACM
* ⚡ Lightweight, no dependencies beyond OpenSSL

---

## 🛠 Requirements

* `openssl`
* `bash`

---

## 📦 Usage

### 1. Clone the repo

```bash
git clone https://github.com/your-username/spki-pinning-toolkit.git
cd spki-pinning-toolkit
```

---

### 2. Make script executable

```bash
chmod +x generate_pins.sh
```

---

### 3. Generate pins

```bash
./generate_pins.sh yourdomain.com
```

---

## 📤 Example Output

```json
{
  "pins": [
    "sha256/AAAAAAAAAAAAAAAAAAAA...",
    "sha256/BBBBBBBBBBBBBBBBBBBB...",
    "sha256/CCCCCCCCCCCCCCCCCCCC..."
  ]
}
```

---

## 🔄 Key Rotation Strategy

### Initial Setup

* Use:

  * ✅ 1 current pin (from live domain)
  * ✅ 1–2 backup pins (generated keys)

---

### When Rotating Certificates

**If using same key:**

* ✅ No app update needed

**If changing key:**

1. Use one of the backup keys
2. Issue new certificate with that key
3. Generate a new backup key
4. Update app later (non-urgent)

---

## 🔐 Security Notes

* Keep generated `backup*.key` files **secure and private**
* Never expose private keys in your repo
* Always include at least **one backup pin** in production apps

---

## ☁️ AWS / ACM Compatibility

This toolkit is designed to work well with:

* AWS ALB (Application Load Balancer)
* AWS Certificate Manager (ACM)

Since ACM rotates certificates automatically:

* ❌ Certificate pinning will break
* ✅ SPKI pinning continues to work safely

---

## 🤝 Contributing

PRs and improvements are welcome.
Feel free to add:

* Multi-domain support
* CI validation
* Language-specific pin generators

---

## ⭐ Final Note

If you're implementing SSL pinning in production:

> **Always include backup pins.**
> Skipping this is the #1 reason apps break after cert rotation.
