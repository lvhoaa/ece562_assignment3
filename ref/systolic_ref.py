# systolic_ref.py
# simple python model for the 3-slice systolic array

W0, W1, W2 = 2, 3, 4   # weights

def to_s8(x):
    x &= 0xFF          # keep 8 bits
    return x - 256 if x & 0x80 else x

def simulate_case(xs, y_prev0=0, flush_cycles=4):
    # PE registers (reset each case)
    x0 = x1 = x2 = 0
    y0 = y1 = y2 = 0

    history = []

    for x_in in xs + [0] * flush_cycles:
        # inputs for this cycle
        x_in0 = x_in
        x_in1 = x0
        x_in2 = x1

        # compute next values
        nx0 = x_in0
        ny0 = y_prev0 + x0 * W0

        nx1 = x_in1
        ny1 = y0 + x1 * W1

        nx2 = x_in2
        ny2 = y1 + x2 * W2

        # update regs
        x0, x1, x2 = nx0, nx1, nx2
        y0, y1, y2 = ny0, ny1, ny2

        history.append({
            "x_in": x_in,
            "y_prev0": y_prev0,
            "y2": to_s8(y2),
        })

    return history


if __name__ == "__main__":
    # case 1
    xs_case1 = [1, 2, 3, 0]
    hist1 = simulate_case(xs_case1, y_prev0=0, flush_cycles=4)
    print("=== Case 1 ===")
    for i, h in enumerate(hist1):
        print(f"cycle {i:2d}: x_in={h['x_in']:3d}  y2={h['y2']:4d}")

    # case 2
    xs_case2 = [1, 2, 3, 0]
    hist2 = simulate_case(xs_case2, y_prev0=5, flush_cycles=4)
    print("\n=== Case 2 ===")
    for i, h in enumerate(hist2):
        print(f"cycle {i:2d}: x_in={h['x_in']:3d}  y_prev0={h['y_prev0']:3d}  y2={h['y2']:4d}")

    # case 3
    xs_case3 = [10, 20, 11, 21, 12, 22, 0]
    hist3 = simulate_case(xs_case3, y_prev0=0, flush_cycles=6)
    print("\n=== Case 3 ===")
    for i, h in enumerate(hist3):
        print(f"cycle {i:2d}: x_in={h['x_in']:3d}  y_prev0={h['y_prev0']:3d}  y2={h['y2']:4d}")
