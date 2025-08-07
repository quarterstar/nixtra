import argparse

class Provider:
    def name(self) -> str:
        """Get the name of the provider"""
        return ""

    def require_authentication(self) -> bool:
        """Return the authentication requirement by the remote provider"""
        return False

    def autocomplete(self, settings: argparse.Namespace, screen_data: str) -> str:
        """Generate an autocomplete response"""
        return ""

    def chat(self) -> str:
        """Respond to a chat request."""
        return ""
