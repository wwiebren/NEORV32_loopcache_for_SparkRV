# use "database -open waves -vcd" for vcd file
database -open waves -shm -into waves.shm
probe -create -all -depth all -packed 1m -unpacked 1m -database waves :
run 150ms
exit
