#!/bin/bash

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Usage: ./generate_pins.sh yourdomain.com"
  exit 1
fi

echo "🔐 Generating SPKI pin for: $DOMAIN"
echo "-----------------------------------"

# Get current SPKI hash
CURRENT_PIN=$(echo | openssl s_client -connect ${DOMAIN}:443 -servername ${DOMAIN} 2>/dev/null \
| openssl x509 -pubkey -noout \
| openssl pkey -pubin -outform der \
| openssl dgst -sha256 -binary | base64)

echo "✅ Current SPKI Pin:"
echo "sha256/${CURRENT_PIN}"
echo ""

# Generate backup key 1
echo "🔧 Generating backup key 1..."
openssl genrsa -out backup1.key 2048 2>/dev/null

BACKUP1_PIN=$(openssl rsa -in backup1.key -pubout -outform der 2>/dev/null \
| openssl dgst -sha256 -binary | base64)

echo "✅ Backup Pin 1:"
echo "sha256/${BACKUP1_PIN}"
echo ""

# Generate backup key 2
echo "🔧 Generating backup key 2..."
openssl genrsa -out backup2.key 2048 2>/dev/null

BACKUP2_PIN=$(openssl rsa -in backup2.key -pubout -outform der 2>/dev/null \
| openssl dgst -sha256 -binary | base64)

echo "✅ Backup Pin 2:"
echo "sha256/${BACKUP2_PIN}"
echo ""

echo "📦 Suggested Mobile Config:"
echo "-----------------------------------"
echo "{"
echo "  \"pins\": ["
echo "    \"sha256/${CURRENT_PIN}\","
echo "    \"sha256/${BACKUP1_PIN}\","
echo "    \"sha256/${BACKUP2_PIN}\""
echo "  ]"
echo "}"
echo ""
echo "⚠️ Keep backup private keys safe (backup*.key)"
