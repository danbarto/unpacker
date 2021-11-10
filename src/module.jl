using PyCall
#pushfirst!(PyVector(pyimport("sys")["path"]), "") #add current directory to python path
#pushfirst!(PyVector(pyimport("sys")["path"]), "/home/chris/Projects/ETROC Data Card/unpacker/module_test_sw/tamalero")
#pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
println(PyVector(pyimport("sys")["path"]))
np = pyimport("numpy")
println(np.random.rand(3))
t1 = pyimport("test")
#println(t1.test_obj)
sys = pyimport("sys")

println(sys.path)
kcu = pyimport("KCU")
#test = t1.test_obj()
