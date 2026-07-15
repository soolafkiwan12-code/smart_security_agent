from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from flask import Flask, jsonify, request
from flask_cors import CORS

from detector import detect_ai_generated_image, detect_phishing_link

app = Flask(__name__)
CORS(app)


def now_utc_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


@app.get("/health")
def health() -> Any:
    return jsonify({"status": "ok", "timestamp_utc": now_utc_iso()})


@app.post("/scan/link")
def scan_link() -> Any:
    payload = request.get_json(silent=True) or {}
    url = payload.get("url", "")
    source = payload.get("source", "manual")

    result = detect_phishing_link(url)
    return jsonify(
        {
            "type": "link",
            "source": source,
            "input": {"url": url},
            "result": result.to_dict(),
            "timestamp_utc": now_utc_iso(),
        }
    )


@app.post("/scan/image")
def scan_image() -> Any:
    payload = request.get_json(silent=True) or {}
    image_name = payload.get("image_name", "")
    metadata_text = payload.get("metadata_text")
    source = payload.get("source", "manual")

    result = detect_ai_generated_image(image_name=image_name, metadata_text=metadata_text)
    return jsonify(
        {
            "type": "image",
            "source": source,
            "input": {"image_name": image_name},
            "result": result.to_dict(),
            "timestamp_utc": now_utc_iso(),
        }
    )


@app.post("/scan/batch")
def scan_batch() -> Any:
    payload = request.get_json(silent=True) or {}
    links = payload.get("links", [])
    images = payload.get("images", [])
    source = payload.get("source", "automated")

    scanned_links = [
        {"url": link, "result": detect_phishing_link(link).to_dict()}
        for link in links
        if isinstance(link, str)
    ]
    scanned_images = [
        {"image_name": image_name, "result": detect_ai_generated_image(image_name).to_dict()}
        for image_name in images
        if isinstance(image_name, str)
    ]

    return jsonify(
        {
            "type": "batch",
            "source": source,
            "counts": {"links": len(scanned_links), "images": len(scanned_images)},
            "results": {"links": scanned_links, "images": scanned_images},
            "timestamp_utc": now_utc_iso(),
        }
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
