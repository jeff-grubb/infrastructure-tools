from textual.app import App, ComposeResult, RenderResult
from textual.containers import ScrollableContainer
from textual.widget import Widget
from textual.widgets import Placeholder, Button, Footer, Header, Static

class Text(Widget):

    def render(self) -> RenderResult:
        return "Hello World!"


class SimpleApp(App):

    def compose(self) -> ComposeResult:

        yield Header()
        yield Footer()
        yield ScrollableContainer(Text())


if __name__ == "__main__":
    app = SimpleApp()
    app.run()
