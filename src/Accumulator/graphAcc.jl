
function graph_accumulator(all_accumulator::Accumulator, sym_acc::Symbol)
    all_acc = getData(all_accumulator)

    acc = all_acc(sym_acc)

    p = plot()
    
    return plot!(p, acc)
end