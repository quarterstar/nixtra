from app.providers.providers import Provider
import openai
from typing import Dict, List, Optional, TypedDict
import argparse
from app.prompts import *
import os

class OpenAIProvider(Provider):
    def name(self) -> str:
        return "openai"

    def require_authentication(self) -> bool:
        return True

    def autocomplete(self, settings: argparse.Namespace, screen_data: str) -> str:
        openai.api_key = os.getenv('API_KEY')

        if settings.model in CHAT_MODELS:
            prompt_template = CHAT_PROMPTS[settings.prompt]
            return self.generate_chat_response(
                prompt_template, 
                screen_data,
                settings.model,
                settings.input
            )
        else:
            prompt_template = COMPLETION_PROMPTS[settings.prompt]
            return self.generate_completion_response(
                prompt_template,
                screen_data,
                settings.model
            )

    def generate_chat_response(
        self,
        prompt_template: List[PromptMessage], 
        screen_data: str,
        model: str,
        user_input: Optional[str] = None
    ) -> str:
        messages = [
            {**msg, "content": msg["content"].format(data=screen_data, input=user_input or "")}
            for msg in prompt_template
        ]
        response = openai.ChatCompletion.create(
            model=model,
            messages=messages,
            temperature=0,
            max_tokens=200,
        )
        return response.choices[0].message["content"]

    @staticmethod
    def generate_completion_response(
        prompt_template: str,
        screen_data: str,
        model: str
    ) -> str:
        prompt = prompt_template.format(data=screen_data)
        response = openai.Completion.create(
            model=model,
            prompt=prompt,
            temperature=0,
            max_tokens=200,
        )
        return response.choices[0].text

