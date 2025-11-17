import numpy as np
import whisper
import torch
from typing import Optional
from .asr_interface import ASRInterface


class VoiceRecognition(ASRInterface):
    def __init__(
        self,
        name: str = "base",
        download_root: Optional[str] = None,
        device: str = "cpu",
        prompt: Optional[str] = None,
    ) -> None:
        # Handle None download_root by not passing it to load_model
        if download_root is not None:
            self.model = whisper.load_model(
                name=name,
                device=device,
                download_root=download_root,
            )
        else:
            self.model = whisper.load_model(
                name=name,
                device=device,
            )
        self.prompt = prompt
        self.device = device

    def transcribe_np(self, audio: np.ndarray) -> str:
        # Convert audio to the appropriate dtype based on device
        # This avoids the FP16 warning on CPU
        if self.device == "cpu":
            # Ensure audio is float32 for CPU
            if audio.dtype != np.float32:
                audio = audio.astype(np.float32)
        else:
            # For GPU, we can use float16 if needed
            pass
            
        if self.prompt is not None:
            result = self.model.transcribe(audio, initial_prompt=self.prompt)
        else:
            result = self.model.transcribe(audio)
        full_text = str(result["text"])
        return full_text