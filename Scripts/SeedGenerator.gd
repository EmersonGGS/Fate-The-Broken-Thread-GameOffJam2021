extends Node

var rng

func randSeedNum():
	randomize()
	var seedNum = round(rand_range(0,999999999999))
	return seedNum

# Called when the node enters the scene tree for the first time.
func _ready():
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(randSeedNum())
	print ("Seed Key State = ",rng.state)
#	rng.state=   -9120277274334919250


	##dEBUG:
#	seed(457876081)
#	seed(randomNumber)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
