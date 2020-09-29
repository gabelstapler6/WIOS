extends Node


var highscore_list = []

func _ready():
	pass

# sorter class sorting the arrray in descending order by score
class Sorter:
	static func sort_descending(a, b):
		if a["score"] > b["score"]:
			return true
		return false

func insert_data(username, score):
	# if the username already exists in teh list the score value gets updated
	for i in highscore_list:
		if i["username"] == username:
			i["score"] = score
			highscore_list.sort_custom(Sorter, "sort_descending")
			print(highscore_list)
			return
	# the user is not in the list so a new entry gets added
	highscore_list.append({
		"username": username,
		"score": score
	})
	highscore_list.sort_custom(Sorter, "sort_descending")
	print(highscore_list)
   
