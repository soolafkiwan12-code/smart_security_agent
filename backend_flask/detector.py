from __future__ import annotations

from dataclasses import dataclass
from urllib.parse import urlparse


SUSPICIOUS_KEYWORDS = {
    "verify",
    "urgent",
    "security-alert",
    "reset-password",
    "free-gift",
    "wallet",
    "banking",
}


@dataclass
class DetectionOutput:
    label: str
    score: float
    reason: str

    def to_dict(self) -> dict:
        return {
            "label": self.label,
            "score": round(self.score, 3),
            "reason": self.reason,
        }


def detect_phishing_link(url: str) -> DetectionOutput:
    if not url:
        return DetectionOutput("suspicious", 0.99, "URL is empty.")

    parsed = urlparse(url)
    host = parsed.netloc.lower()
    path = parsed.path.lower()
    full = f"{host}{path}"

    score = 0.1
    reasons: list[str] = []

    if parsed.scheme not in {"http", "https"}:
        score += 0.3
        reasons.append("Unsupported or missing URL scheme.")

    if "@" in url:
        score += 0.25
        reasons.append("Contains @ symbol in URL.")

    if host.count("-") >= 3:
        score += 0.15
        reasons.append("Excessive hyphen use in hostname.")

    if any(keyword in full for keyword in SUSPICIOUS_KEYWORDS):
        score += 0.3
        reasons.append("Contains known phishing-like keywords.")

    if "." not in host:
        score += 0.3
        reasons.append("Malformed host.")

    if host.endswith((".zip", ".mov", ".xyz", ".top")):
        score += 0.2
        reasons.append("Suspicious top-level domain.")

    if score >= 0.65:
        return DetectionOutput("suspicious", min(score, 0.99), "; ".join(reasons) or "Potential phishing indicators.")

    return DetectionOutput("safe", max(0.05, score), "No critical phishing indicators detected.")


def detect_ai_generated_image(image_name: str, metadata_text: str | None = None) -> DetectionOutput:
    if not image_name:
        return DetectionOutput("suspicious", 0.88, "Missing image name.")

    lowered = image_name.lower()
    hints = ["midjourney", "stable_diffusion", "dalle", "generated", "synthetic", "ai_"]
    score = 0.2
    reasons: list[str] = []

    if any(token in lowered for token in hints):
        score += 0.45
        reasons.append("Filename contains AI-generation hint.")

    if metadata_text:
        meta = metadata_text.lower()
        if "prompt" in meta or "sampler" in meta or "steps" in meta:
            score += 0.25
            reasons.append("Metadata includes generation-like fields.")

    if score >= 0.6:
        return DetectionOutput("suspicious", min(score, 0.99), "; ".join(reasons) or "AI generation indicators found.")

    return DetectionOutput("safe", score, "No strong AI-generation indicators detected.")
