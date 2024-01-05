
function pings = measurements(num_pings)
    pings = [];
    for i = 1:num_pings
        pings = [pings; ping_stolp_1(), ping_stolp_2(), ping_stolp_3()];
    end
end