extends CanvasLayer

# --- NODES ---
@onready var actual_score_label = $ColorRect/TextureRect/HBoxContainer/ActualScore
@onready var menu_button = $ColorRect/TextureRect/VBoxContainer/MenuButton
@onready var next_level_button = $ColorRect/TextureRect/VBoxContainer/NextLevelButton

func _ready():
	self.hide()
	process_mode = PROCESS_MODE_ALWAYS
	
	# Connect signals
	menu_button.pressed.connect(_on_menu_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)

func open_level_complete(final_score: int):
	actual_score_label.text = str(final_score)
	self.show()
	get_tree().paused = true

func _on_next_level_pressed():
	get_tree().paused = false
	# Tell the GameManager to load the next track in the list!
	GameManager.load_next_level()

func _on_menu_pressed():
	get_tree().paused = false
	# Tell the GameManager to handle going back home safely
	GameManager.go_to_main_menu()
