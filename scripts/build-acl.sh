#!/usr/bin/env bash
set -e

echo "📄 Building ACL paper..."

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/acl"

mkdir -p "$BUILD_DIR"


echo "📚 Copying bibliography..."
cp "$ROOT_DIR/content/bibliography/references.bib" "$BUILD_DIR/"

echo "📦 Copying ACL template files..."
cp "$ROOT_DIR/templates/acl/acl.sty" "$BUILD_DIR/"
cp "$ROOT_DIR/templates/acl/acl_natbib.bst" "$BUILD_DIR/"


echo "🧱 Generating LaTeX via Pandoc..."
pandoc \
  "$ROOT_DIR/content/sections/"*.md \
  --template="$ROOT_DIR/templates/acl/pandoc-acl.tex" \
  --natbib \
  --metadata title="Automated Business Requirements Extraction from Legacy Systems" \
  --metadata author.name="Ankur Kalohia" \
  --metadata author.affiliation="EPAM Systems" \
  --metadata author.location="Pittsburgh, PA, USA" \
  --metadata author.email="ankur.kalohia@gmail.com" \
  -o "$BUILD_DIR/paper.tex"


cd "$BUILD_DIR"

echo "📚 Compiling PDF (pdflatex → bibtex → pdflatex ×2)..."
pdflatex -interaction=nonstopmode paper.tex
bibtex paper
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex

echo "✅ ACL PDF ready: $BUILD_DIR/paper.pdf"
