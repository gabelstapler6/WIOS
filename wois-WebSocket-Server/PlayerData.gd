extends Node


var highscore_list = []

func _ready():
    pass

# sort the list descending order with bubblesort
func sort_highscores():
    for _i in range(1, highscore_list.size()):
        for j in range(0, highscore_list.size() - 1):
            if highscore_list[j].highscore < highscore_list[j+1].highscore:
                var c = highscore_list[j]
                highscore_list[j]= highscore_list[j+1]
                highscore_list[j+1] = c


func insert_data(username, score):
    # if the username already exists in teh list the score value gets updated
    for i in highscore_list:
        if i["username"] == username:
            i["score"] = score
            sort_highscores()
            return
    # the user is not in the list so a new entry gets added
    highscore_list.append({
        "username": username,
        "score": score
    })
    sort_highscores()
   