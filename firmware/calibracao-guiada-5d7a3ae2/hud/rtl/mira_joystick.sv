// Mira independente do controle de atitude. Atualiza a posicao em ticks lentos.
module mira_joystick #(
    parameter integer DEADZONE = 180,
    parameter integer CALIB_BITS = 25,
    parameter integer TICK_CYCLES = 5_000_000,
    parameter integer X_MIN = 24,
    parameter integer X_MAX = 616,
    parameter integer Y_MIN = 24,
    parameter integer Y_MAX = 456,
    parameter integer INITIAL_X = 320,
    parameter integer INITIAL_Y = 240,
    parameter integer MAX_STEP = 8,
    parameter integer PASSO_SHIFT = 8,
    parameter integer FIXED_STEP = 0,
    parameter integer DEBOUNCE_CYCLES = 1_000_000
) (
    input logic clk,
    input logic [11:0] x_raw, y_raw,
    input logic sw_n,
    input logic enable,
    input logic reset,
    output logic [9:0] x = 10'(INITIAL_X),
    output logic [8:0] y = 9'(INITIAL_Y),
    output logic locked = 0
);
    localparam integer TICK_W = TICK_CYCLES > 1 ? $clog2(TICK_CYCLES) : 1;
    localparam integer DB_W = DEBOUNCE_CYCLES > 1 ? $clog2(DEBOUNCE_CYCLES) : 1;
    logic [TICK_W-1:0] tick_count = 0;
    logic [11:0] center_x = 2048, center_y = 2048;
    logic [CALIB_BITS-1:0] calib_count = 0;
    logic calibrated = 0;
    (* ASYNC_REG = "TRUE" *) logic [1:0] button_sync = 2'b11;
    logic button_stable = 1;
    logic [DB_W-1:0] debounce_count = 0;
    // Pipeline: largura reduzida para os dados reais.
    localparam integer STEP_W =
        MAX_STEP > 0 ? $clog2(MAX_STEP + 1) : 1;

    // Preserva o limiar efetivo do passo proporcional original.
    localparam integer START_THRESHOLD = DEADZONE +
        (FIXED_STEP > 0 ? (1 << PASSO_SHIFT) - 1 : 0);

    logic [11:0] dx, dy;
    logic [11:0] step_x_calc, step_y_calc;

    logic [STEP_W-1:0] step_x_q = '0;
    logic [STEP_W-1:0] step_y_q = '0;
    logic dir_x_q = 1'b1;
    logic dir_y_q = 1'b1;

    logic signed [11:0] next_x, next_y;

    always_comb begin
        dx = (x_raw >= center_x) ?
            (x_raw - center_x) : (center_x - x_raw);
        dy = (y_raw >= center_y) ?
            (y_raw - center_y) : (center_y - y_raw);

        step_x_calc = (dx <= START_THRESHOLD) ?
            12'd0 : (FIXED_STEP > 0 ? 12'(FIXED_STEP) :
                ((dx - 12'(DEADZONE)) >> PASSO_SHIFT));
        step_y_calc = (dy <= START_THRESHOLD) ?
            12'd0 : (FIXED_STEP > 0 ? 12'(FIXED_STEP) :
                ((dy - 12'(DEADZONE)) >> PASSO_SHIFT));

        next_x = dir_x_q ?
            ($signed({1'b0,x}) + $signed({1'b0,step_x_q})) :
            ($signed({1'b0,x}) - $signed({1'b0,step_x_q}));

        next_y = dir_y_q ?
            ($signed({1'b0,y}) + $signed({1'b0,step_y_q})) :
            ($signed({1'b0,y}) - $signed({1'b0,step_y_q}));
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            x <= 10'(INITIAL_X);
            y <= 9'(INITIAL_Y);
            locked <= 1'b0;
            tick_count <= '0;
            center_x <= 12'd2048;
            center_y <= 12'd2048;
            calib_count <= '0;
            calibrated <= 1'b0;
            button_sync <= 2'b11;
            button_stable <= 1'b1;
            debounce_count <= '0;
            step_x_q <= '0;
            step_y_q <= '0;
        end else begin
            // Estagio 1: registra direcao e passo.
            // Estagio 2: posicao utiliza os valores registrados.
            dir_x_q <= (x_raw >= center_x);
            dir_y_q <= (y_raw >= center_y);

            step_x_q <= (step_x_calc > MAX_STEP) ?
                STEP_W'(MAX_STEP) : STEP_W'(step_x_calc);

            step_y_q <= (step_y_calc > MAX_STEP) ?
                STEP_W'(MAX_STEP) : STEP_W'(step_y_calc);

            button_sync <= {button_sync[0],sw_n};
            if (!calibrated) begin
                center_x <= x_raw;
                center_y <= y_raw;
                calib_count <= calib_count + 1'b1;
                if (&calib_count) calibrated <= 1;
            end

            if (button_sync[1] == button_stable) debounce_count <= 0;
            else if (debounce_count == DB_W'(DEBOUNCE_CYCLES-1)) begin
                debounce_count <= 0;
                button_stable <= button_sync[1];
                if (!button_sync[1] && enable) locked <= ~locked;
            end else debounce_count <= debounce_count + 1'b1;

            if (tick_count == TICK_W'(TICK_CYCLES-1)) begin
                tick_count <= 0;
                if (calibrated && !locked && enable) begin
                    if (next_x < X_MIN) x <= 10'(X_MIN);
                    else if (next_x > X_MAX) x <= 10'(X_MAX);
                    else x <= 10'(next_x);
                    if (next_y < Y_MIN) y <= 9'(Y_MIN);
                    else if (next_y > Y_MAX) y <= 9'(Y_MAX);
                    else y <= 9'(next_y);
                end
            end else tick_count <= tick_count + 1'b1;
        end
    end
endmodule
