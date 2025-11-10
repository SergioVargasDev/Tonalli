# Tonalli - Indigenous Language Translation App

Tonalli is an iOS translation application developed during HackMTY 2024 that bridges communication gaps between tourists and indigenous language speakers through real-time text and voice translations. The app leverages advanced machine learning and cloud technologies to preserve endangered languages while fostering meaningful cultural connections, achieving 78% translation accuracy across 5 major indigenous dialects.

## Features

- **Real-Time Translation**: Converts speech and text instantly between tourists and indigenous language speakers with 78% accuracy across major dialects.
- **Voice & Text Support**: Seamless speech-to-text and text-to-speech functionality for comprehensive communication.
- **Cultural Context Awareness**: GPT-4 LLM integration delivers translations that preserve meaning and nuance of regional dialects.
- **Offline Access**: Stores frequently used translations for quick retrieval without internet connectivity.
- **Dialect Recognition**: Geolocation-based dialect inference using Google Maps integration for regional accuracy.
- **User-Friendly Experience**: SwiftUI-powered intuitive interface designed for accessibility and ease of use.
- **Session Management**: Comprehensive storage and feedback system for continuous model improvement.

## Tech Stack

### Mobile Development
- **Swift/SwiftUI** – Native iOS app with seamless and intuitive user interface.

### Machine Learning & AI
- **GPT-4 LLM** – Advanced language model for regional dialect translation and cultural context preservation.

### Cloud Services
- **Google Cloud Speech APIs** – Real-time Speech-to-Text and Text-to-Speech functionality.
- **Google Maps API** – Geolocation services for regional dialect inference.

### Backend & Database
- **Flask** – Python backend handling user requests, data flow, and translation processing.
- **PostgreSQL** – SQL database for session storage, user feedback, and translation history.

### Data Processing
- **Python** – Web scraping and processing of 4,500+ indigenous language samples.
- **ETL Workflows** – Collection, cleaning, and structuring of linguistic records for model training.

## Installation

### Prerequisites

- **Xcode 14.0+** - Required for iOS development
- **iOS 15.0+** - Minimum supported iOS version
- **Python 3.8+** - For backend services and data processing
- **MongoDB 4.4+** - Database management
- **Google Cloud Account** - For Speech APIs and Maps integration

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/tonalli-translator.git
   cd tonalli-translator
   ```

2. **Backend Setup**
   ```bash
   # Create virtual environment
   python -m venv tonalli-env
   
   # Activate virtual environment
   # On macOS/Linux:
   source tonalli-env/bin/activate
   # On Windows:
   tonalli-env\Scripts\activate
   
   # Install dependencies
   pip install flask google-cloud-speech pymongo requests beautifulsoup4
   ```

3. **Database Configuration**
   ```bash
   # Install MongoDB and start the service
   # On macOS with Homebrew:
   brew tap mongodb/brew
   brew install mongodb-community
   brew services start mongodb-community
   
   # On Ubuntu:
   # sudo apt-get install mongodb
   # sudo systemctl start mongodb
   
   # Create database and collections
   python setup_db.py
   ```

4. **Environment Configuration**
   ```bash
   # Create .env file with required API keys
   cp .env.example .env
   
   # Add your API keys:
   # GOOGLE_CLOUD_API_KEY=your_key_here
   # OPENAI_API_KEY=your_gpt4_key_here
   # MONGODB_URI=mongodb://localhost:27017/tonalli_db
   ```

5. **Start Backend Server**
   ```bash
   python app.py
   ```

6. **iOS App Setup**
   ```bash
   # Open iOS project in Xcode
   open Tonalli.xcodeproj
   
   # Install dependencies (if using CocoaPods)
   pod install
   
   # Configure API endpoints in Config.swift
   # Build and run on device or simulator
   ```

### Project Structure

```
tonalli-translator/
├── AI/                      # AI models and machine learning components
├── Speech-Text/             # Speech-to-text processing modules
├── SwiftTonalli/           # SwiftUI iOS application source code
├── __pycache__/            # Python compiled bytecode cache
├── images/                 # Project images and assets
├── model/                  # Translation models and AI configurations
├── source/                 # Core source code and utilities
├── venv/                   # Python virtual environment
├── .DS_Store              # macOS system file
├── .env                   # Environment variables and API keys
└── README.md              # This file
```

### Running the Application

#### 1. Backend API Server
```bash
# Start Flask development server
python app.py

# API will be available at http://localhost:5000
```

#### 2. iOS Application
- Open `Tonalli.xcodeproj` in Xcode
- Select target device or simulator
- Configure backend endpoint URL in app settings
- Build and run the application

#### 3. Data Processing Pipeline
```bash
# Run web scraping for new language samples
python data_processing/scrape_languages.py

# Process and clean linguistic data
python data_processing/clean_data.py

# Update dialect mappings with geolocation
python data_processing/update_dialects.py
```

### Key Functionalities

#### Translation Process
1. **Voice Input**: User speaks in their native language
2. **Speech Recognition**: Google Cloud Speech API converts audio to text
3. **Dialect Detection**: Geolocation determines regional dialect variation
4. **Translation**: GPT-4 processes text with cultural context awareness
5. **Speech Output**: Translated text converted back to speech
6. **Session Storage**: Interaction saved for model improvement

#### Offline Mode
- Frequently used translations cached locally
- Core vocabulary available without internet connection
- Seamless transition between online and offline modes

### Performance Metrics

- **Translation Accuracy**: 78% across 5 major indigenous dialects
- **Language Samples**: 4,500+ processed indigenous language records
- **Response Time**: <2 seconds for real-time voice translation
- **Dialect Coverage**: 5 major regional dialect variations
- **Cultural Preservation**: Context-aware translations maintaining linguistic nuance

### Cultural Impact

**Language Preservation**: Tonalli contributes to preserving endangered indigenous languages by making them accessible through modern technology, creating digital records and promoting their continued use.

**Community Bridge**: The app enables meaningful communication between urban tourists and indigenous communities, fostering cultural exchange and mutual understanding.

**Educational Value**: Serves as a learning tool for tourists interested in indigenous cultures and languages, promoting awareness and respect for linguistic diversity.

### Development Achievements

- **HackMTY 2024**: Developed during hackathon demonstrating rapid prototyping and innovative problem-solving
- **Machine Learning Integration**: Successfully implemented GPT-4 for culturally sensitive translations
- **Scalable Architecture**: Built robust backend capable of handling real-time translations and data processing
- **User-Centric Design**: Created intuitive SwiftUI interface optimized for diverse user groups

### Future Enhancements

- Expansion to additional indigenous languages and dialects
- Enhanced offline capabilities with local AI models
- Community contribution features for language speakers
- Integration with cultural tourism platforms
- Advanced analytics for language preservation research

### Contributing

We welcome contributions from developers, linguists, and indigenous language speakers. Please see our contribution guidelines for more information on how to help preserve and promote indigenous languages through technology.

### Troubleshooting

**Common Issues:**

- **API Rate Limits**: Implement caching and request throttling for Google Cloud APIs
- **Translation Accuracy**: Continuously refine model with user feedback and additional training data
- **iOS Permissions**: Ensure microphone and location permissions are properly configured

**Performance Optimization:**

- Cache frequently used translations locally
