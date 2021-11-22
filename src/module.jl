using PyCall
#pushfirst!(PyVector(pyimport("sys")["path"]), "") #add current directory to python path
#pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
println(PyVector(pyimport("sys")["path"]))
np = pyimport("numpy")
println(np.random.rand(3))
t1 = pyimport("test")
#println(t1.test_obj)
sys = pyimport("sys")

println(sys.path)
kcu = pyimport("tamalero.KCU")
ReadotBoard = pyimport("tamalero.ReadoutBoard")
rb_0 = kcu.connect_readout_board(ReadoutBoard(0, trigger=false))
FIFO = pyimport("tamalero.FIFO")
fifo = FIFO(rb_0, elink=2)
fifo.set_trigger(word0=0x35, word1=0x55, mask0=0xff, mask1=0xff)
fifo.reset()
hex_dump = fifo.giant_dump(3000,255)
fifo.dump_to_file(hex_dump, n_col=5, filename ="julia_dump.hex")  # use 5 columns --> better to read for our data format


