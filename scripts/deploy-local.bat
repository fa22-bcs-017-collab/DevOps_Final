@echo off
echo 🚀 Starting Local Deployment...

echo.
echo 📦 Installing dependencies...
npm install

echo.
echo 🐳 Starting MongoDB container...
docker run -d -p 27017:27017 --name mongodb-local mongo:7.0

echo.
echo ⏳ Waiting for MongoDB to start...
timeout /t 5

echo.
echo 🚀 Starting application...
echo Visit: http://localhost:3000
npm start