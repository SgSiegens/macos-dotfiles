from typing import Any
from kitty.boss import Boss
from kitty.window import Window


def on_focus_change(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    if data.get("focused"):
        boss.call_remote_control(window, ("set-background-opacity", "1.0"))
    else:
        boss.call_remote_control(window, ("set-background-opacity", "0.75"))

