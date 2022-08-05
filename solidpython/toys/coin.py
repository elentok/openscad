from solid import *
from lib.render import render
from dataclasses import dataclass
from solid.extensions.bosl2 import back_half
from typing import Optional


@dataclass
class Coin:
    edge_radius: float = 1
    bottom_radius: float = 1
    thickness: float = 2
    diameter: float = 30
    text: Optional[str] = "1"
    text_xoffset: float = 0
    font: str = "Google Sans:style=Bold"
    faces: float = 64

    def render(self):
        coin = self.render_flat().rotate_extrude(_fn=self.faces)

        if self.text:
            coin = difference()(coin, self.render_text())

        return coin

    def render_text(self):
        font_size = (self.diameter - 2 * self.edge_radius) * 0.5
        return (
            text(
                self.text,
                halign="center",
                valign="center",
                size=font_size,
                font=self.font,
            )
            .offset(r=-0.5)  # round the corners
            .offset(r=0.5)
            .linear_extrude(self.thickness + 0.2)
            .down(0.1)
            .right(self.text_xoffset)
        )

    def render_flat(self):
        bottom_circle = (
            circle(r=self.bottom_radius)
            .forward(self.bottom_radius)
            .right(self.diameter / 2 - self.bottom_radius)
        )

        bottom = square([self.diameter / 2 - self.bottom_radius, self.thickness])

        top_edge = (
            circle(r=self.edge_radius)
            .forward(self.thickness)  # + self.edge_radius / 2)
            .right(self.diameter / 2 - self.edge_radius)
        )

        return union()(bottom, hull()(bottom_circle, top_edge))


coin1 = Coin(text="1", text_xoffset=-1.2, diameter=30)
coin2 = Coin(text="2", diameter=25)
coin5 = Coin(text="5", diameter=40, faces=10)

all_coins = union()(
    coin1.render().left(coin1.diameter).forward(coin1.diameter),
    coin2.render().left(coin2.diameter).back(coin2.diameter),
    coin5.render().right(coin5.diameter).back(coin5.diameter),
)

render(coin1.render())
