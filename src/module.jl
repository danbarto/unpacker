using PyCall
#pushfirst!(PyVector(pyimport("sys")["path"]), "") #add current directory to python path
#pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
KCU = pyimport("tamalero.KCU")
ReadoutBoard = pyimport("tamalero.ReadoutBoard")
FIFO = pyimport("tamalero.FIFO")

function hex_dump(flag_save::Bool=false)
    println("Using KCU at address: 192.168.0.10")

    kcu = KCU.KCU(name="my_device",
              #ipb_path="chtcp-2.0://localhost:10203?target=192.168.0.10:50001",
              ipb_path="ipbusudp-2.0://192.168.0.10:50001",
              adr_table="../module_test_sw/module_test_fw/address_tables/etl_test_fw.xml")

    rb_0 = kcu.connect_readout_board(ReadoutBoard.ReadoutBoard(0, trigger=false))
    fifo = FIFO.FIFO(rb_0, elink=2)
    fifo.set_trigger(word0=0x35, word1=0x55, mask0=0xff, mask1=0xff)
    fifo.reset()
    hex_dump = fifo.giant_dump(3000,255)
    hex_dump = fifo.wipe(hex_dump, integer=true)
    if flag_save
        fifo.dump_to_file(hex_dump, filename ="julia_dump.hex")  # use 5 columns --> better to read for our data format
    end
    return hex_dump
end

#println(hex_dump())
