#!/bin/bash

# Get project name from the first argument
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Error: Please provide a project name."
  echo "Usage: ./create-react-project.sh <project-name>"
  exit 1
fi

# Create Vite project
npm create vite@latest $PROJECT_NAME -- --template react

# Navigate into the project directory
cd $PROJECT_NAME || exit

# Install dependencies
npm install

# Install Tailwind CSS and initialize
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Configure Tailwind
cat <<EOT > tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOT

# Add Tailwind imports to index.css
cat <<EOT > src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOT

# Delete unnecessary files
rm -rf src/assets
rm src/App.css

# Edit App.jsx to the desired content
cat <<EOT > src/App.jsx
function App() {
  return (
    <>
      <h1>Let's build it!</h1>
    </>
  );
}

export default App;
EOT

# Update the title in index.html
sed -i "s/<title>.*<\/title>/<title>${PROJECT_NAME}<\/title>/" index.html

# Modify body class for dark mode with white text
sed -i 's/<body>/<body class="bg-gray-900 text-white">/' index.html

# Create a components folder inside src
mkdir src/components

echo "React project with Vite, Tailwind CSS, and React Router setup completed!"

# Run the development server
npm run dev &

# Wait for the server to start (optional, give it time)
sleep 5

# Detect Thorium browser installation and open the development server
if command -v thorium-browser >/dev/null 2>&1; then
  thorium-browser http://localhost:5173 &
else
  echo "Thorium Browser is not installed or not found. Opening in the default browser."
  xdg-open http://localhost:5173 &
fi
