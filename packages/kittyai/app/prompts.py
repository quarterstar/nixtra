from typing import Dict, List, Optional, TypedDict

class PromptMessage(TypedDict):
    role: str
    content: str

COMPLETION_PROMPTS: Dict[str, str] = {
    "complete": """Complete this code or terminal line. Do not write anything else except the best completion.

Terminal data: {data}

Answer: """,
    "debug": """Capture from kitty terminal:
{data}
Provide a command suggestion how to handle the situation.""",
}

CHAT_PROMPTS: Dict[str, List[PromptMessage]] = {
    "complete": [
        {
            "role": "system",
            "content": "You are an AI assistant. Provide the best completion for the user's terminal content.",
        },
        {
            "role": "user",
            "content": "Terminal content: {data}. Only provide the best completion - no explanations.",
        },
    ],
    "ask": [
        {
            "role": "system",
            "content": "You are an AI assistant. Respond to the user's request about their terminal content.",
        },
        {
            "role": "user", 
            "content": "Terminal content:\n{data}\n\nUser request: {input}"
        },
    ],
}

CHAT_MODELS = {"gpt-3.5-turbo", "gpt-4", "gpt-4-turbo"}
