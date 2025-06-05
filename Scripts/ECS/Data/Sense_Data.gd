extends Node
class_name SenseData

enum SenseTypes {
	SIGHT, SOUND, TOUCH, TASTE, SMELL, FIELD
}

enum VisualHierarchy {MOTION, SHAPE, COLOR, FAMILY, MATERIAL, MARKING, FACE}

#perception:
	#perception will be a relational filter to say how well a mind is informed to aid in judgement and will be based in the mind
	

#definition 
	#the granularity that the sense is experienced, im not sure about this one
	#in the case of touch, i dont think there is a definition, or rather the definition is entangled with frequency and a result of the skin or the skins makeup
		#in the human body there are different skin cells or skin nerve endings that have a frequency that results in a higher granularity of touch or higher definition
		#the location of these different types of nerves is what makes your hands better for reading brail than your calf, not any touch ability or skill or variable
		#bird beaks have different levels of touch sensitivity in their beaks that apparently allows them to feel texture which i get but the _levels_ of sensitivity is where
		#i dont understand the different levels and how they are measured 
		#hyperesthesia is a heightened sense of touch which results from the brain mininterpretting sensory signals so it is a mind/brain thing like perception and not a sense thing
	#vision is more clear: clarity of the image decreases with decreased definition: image clarity halves ever 6 meters:
	#	levels of image clarity are reflected in the visualhierarchy from easiest to identify to hardest
	#	otherwise we could just make it a dice roll and make it more difficult the further away something is
	#sound also deals in Hz but the Hz reference a spectrum rather than a frequency ( i know its a frequency but im not simulating air vibrations... unless)
	#	simulating air vibrations would laregly just be giving tiles an air component that holds a vibrations array that could just be a string thats collected by anything with ears in the tile
	#	
	
#frequency:
	#the frequency that the sensory information is updated

#touch has a frequency of Hz where your skin provides the ability to feel pressure and the frequency is how often that pressure information is updated
#	so possible variations in skin may change what can be felt in some way
#	the frequency of what is felt is decided by the sensing
