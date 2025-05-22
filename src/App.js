import React from 'react';
import './App.css';

// Dynamically import the logo
const logo = require('./logo.svg'); // This will use the logo.svg file updated in the pipeline

function App() {
  return (
    <div className="App">
      <header className="App-header">
        {/* Display dynamically updated logo */}
        <img src={logo} className="App-logo" alt="logo" />
        <h1>Welcome to React</h1>
        <p>
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </header>
    </div>
  );
}

export default App;
