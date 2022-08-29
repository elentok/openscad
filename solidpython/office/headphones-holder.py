from lib.cad_object import RoundedPolyline, Circle, Coordinate, Square

MONITOR_THICKNESS = 19.3
MONITOR_TOP_PADDING = 7.5
HEADPHONE_THICKNESS = 50  # includes 10mm margin
HEADPHONE_DIAMETER = 120
HOLDER_THICKNESS = 5
HOLDER_WIDTH = 40
HOLDER_HEIGHT = 40
HOLDER_BACK_HEIGHT = 30

t = HOLDER_THICKNESS
grip = RoundedPolyline(
    thickness=t,
    points=[
        (-HEADPHONE_THICKNESS - t, HOLDER_BACK_HEIGHT),
        (-HEADPHONE_THICKNESS - t, 0),
        (0, 0),
        (0, HOLDER_HEIGHT),
        (MONITOR_THICKNESS, HOLDER_HEIGHT),
        (MONITOR_THICKNESS, HOLDER_HEIGHT - MONITOR_TOP_PADDING),
    ],
).linear_extrude(HOLDER_WIDTH)

grip_supports = RoundedPolyline(
    thickness=t,
    points=[
        (0, 0),
        (-HEADPHONE_THICKNESS / 2, 0),
        (0, -HEADPHONE_THICKNESS / 2),
        (0, 0),
    ],
).linear_extrude(HOLDER_WIDTH)

holder = grip.add(grip_supports)

curved_stand = (
    Circle(d=HEADPHONE_DIAMETER)
    .cut(Circle(d=HEADPHONE_DIAMETER - HOLDER_THICKNESS))
    .cut(Square((HEADPHONE_DIAMETER, HEADPHONE_DIAMETER / 2)).move(y="-50%"))
)

# curved_stand.export()

holder.export()
