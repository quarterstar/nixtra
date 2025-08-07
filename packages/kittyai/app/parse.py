from typing import Dict, List, Optional, TypedDict
import argparse
from prompts import *

def parse_arguments(args: List[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--extent",
        "-e",
        default="selection,lastcmd,screen",
        help="Content sources in priority order (selection,lastcmd,screen,scrollback)",
    )
    parser.add_argument(
        "--provider",
        "-p",
        default="openai",
        help="LLM API to use (default: openai)",
    )
    parser.add_argument(
        "--kind",
        "-k",
        default="completion",
        help="The type of LLM generation you wish to do (default: completion) (completion/chat)",
    )
    parser.add_argument(
        "--model",
        "-m",
        default="gpt-3.5-turbo",
        help="OpenAI model to use (default: gpt-3.5-turbo)",
    )
    parser.add_argument(
        "--prompt",
        "-p",
        choices=set(COMPLETION_PROMPTS.keys()).union(set(CHAT_PROMPTS.keys())),
        default="complete",
    )
    parser.add_argument(
        "--input",
        "-i",
        help="User input for question/answer prompts",
        default=None
    )
    return parser.parse_args(args[1:])  # Skip script name
