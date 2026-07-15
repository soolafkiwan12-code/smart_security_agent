# Smart Security Agent

Starter implementation for the Smart Security Agent application with:
- Flutter mobile app (`mobile_app_flutter`)
- Flask backend API (`backend_flask`)

## Project structure

- `mobile_app_flutter`: Flutter client with manual scan flow
- `backend_flask`: Flask API with phishing and AI-image detection stubs

## 1) Backend setup (Flask)

1. Install Python 3.10+.
2. Open terminal in `backend_flask`.
3. Create and activate virtual environment:
   - Windows PowerShell:
     - `python -m venv .venv`
     - `.venv\Scripts\Activate.ps1`
4. Install dependencies:
   - `pip install -r requirements.txt`
5. Run server:
   - `python app.py`

Backend will run on `http://127.0.0.1:5000`.

## 2) Flutter setup

1. Install Flutter SDK and add it to PATH.
2. Open terminal in `mobile_app_flutter`.
3. Get packages:
   - `flutter pub get`
4. Run app:
   - `flutter run`

## API endpoints

- `GET /health`
- `POST /scan/link`
- `POST /scan/image`
- `POST /scan/batch`

## Notes

- The current detector is a practical starter with rule-based checks.
- Replace logic in `backend_flask/detector.py` with ML models later.
- Android background monitoring and iOS native manual hooks can be added through platform channels in Flutter.
