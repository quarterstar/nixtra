from __future__ import annotations

from app.providers.providers import Provider
from app.providers.openai import OpenAIProvider
from app.prompts import *
import os
from typing import Dict, List, Optional, TypedDict
import openai
from kitty.boss import Boss
from kitty.window import CommandOutput
from kittens.tui.handler import result_handler
from kittens.tui.loop import debug
from parse import *
from dotenv import load_dotenv

openai.api_key = os.getenv('OPENAI_API_KEY')

def get_first_line(text: str) -> str:
    """Extract and return the first non-empty line of text."""
    return text.lstrip("\n").split("\n", maxsplit=1)[0].strip()


def get_screen_data(window: Boss.Window, extent_order: str) -> Optional[str]:
    """Retrieve terminal content based on the specified extent order."""
    for extent in extent_order.split(","):
        extent = extent.strip().lower()
        if extent == "selection" and window.has_selection():
            if data := window.text_for_selection():
                return data
        elif extent == "screen":
            if data := window.as_text():
                return data
        elif extent == "scrollback":
            if data := window.as_text(add_history=True):
                return data
        elif extent == "lastcmd":
            if data := window.cmd_output(CommandOutput.last_non_empty):
                return data
    return None

def create_providers() -> List[Provider]:
    providers = []

    providers.append(OpenAIProvider())

    return providers

@result_handler(no_ui=True)
def handle_result(
    args: List[str],
    answer: str,
    target_window_id: int,
    boss: Boss
) -> None:
    load_dotenv()
    
    settings = parse_arguments(args)

    providers = create_providers()

    for cur_provider in providers:
        if cur_provider.name == settings.provider:
            provider = cur_provider
    
    if provider is None:
        return debug('Provider not found')

    window = boss.window_id_map.get(target_window_id)
    if not window:
        return debug("Window not found")

    if not os.getenv('API_KEY') and provider.require_authentication():
        return debug('API key for authentication-based provider not found')

    try:
        if settings.kind == "complete":
            if not (screen_data := get_screen_data(window, settings.extent)):
                return debug("No content found in selected extents")

            provider.autocomplete(settings, screen_data)

            boss.call_remote_control(
                window,
                ("send_text", get_first_line(response))
            )

    except Exception as e:
        debug(f"Error processing request: {str(e)}")
        if "API key" in str(e):
            debug("Invalid or missing OpenAI API key")
