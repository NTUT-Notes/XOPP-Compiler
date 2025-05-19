# XOPP-Compiler
XOPP-Compiler is an automated tool designed to convert `.xopp` notebook files into PDF format using GitHub Actions. The converted PDF files are then stored in the `output-branch` for easy access and sharing.

## 🚀 Features

- **Automated Conversion**: Simply upload a `.xopp` file, and GitHub Actions will handle the conversion process.
- **Branch Management**: The original `.xopp` files remain on the `main` branch, while the converted PDFs are stored in `output-branch`.
- **Seamless Workflow**: No manual intervention needed—just push your files, and the system takes care of the rest.

## 📂 How to Use

### 1️⃣ Upload Your Notes
Push your `.xopp` notebook files to the `main` branch:
```bash
git add your_note.xopp
git commit -m "Add new notes"
git push origin main
```

### 2️⃣ Automatic Processing
GitHub Actions will detect the newly uploaded .xopp file, convert it into a PDF, and store the output in output-branch.

### 3️⃣ Download the PDF
You can access the converted PDF by checking out the output-branch:
```bash
git checkout output-branch
git pull origin output-branch
```
