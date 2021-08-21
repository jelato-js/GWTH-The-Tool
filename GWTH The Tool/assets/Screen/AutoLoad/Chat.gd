extends CanvasLayer

onready var chatControl : Control = $ChatControl

onready var chatEnter : LineEdit = $ChatControl/ChatEnter
onready var chatScroll : ScrollContainer = $ChatControl/ScrollContainer
onready var chatBox : VBoxContainer = $ChatControl/ScrollContainer/ChatContainer

onready var chatEx : Label = $ChatControl/ScrollContainer/ChatContainer/ChatLabel
onready var chatExSystem1 : Label = $ChatControl/ScrollContainer/ChatContainer/SystemChat1
onready var chatExSystem2 : Label = $ChatControl/ScrollContainer/ChatContainer/SystemChat2

# Declare member variables here. Examples:
# var a = 2
var chatLog = []


# Called when the node enters the scene tree for the first time.
func _ready():
	HideChat()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ShowChat():
	chatControl.show()
func HideChat():
	chatControl.hide()

func _on_ChatEnter_text_entered(new_text):
	if chatEnter.text.empty():
		return
	var chat = "%s : %s" % [Game.player_name , chatEnter.text ]
	enter_new_chat(chat)
	chatEnter.text = ""
	if Game.players.keys().size() > 0:
		rpc("enter_new_chat", chat)

remote func enter_new_chat(text, type = 0):
	var newChat = Label.new()
	newChat.text = text
	if type > 0:
		var color
		if type == 1:
			color = chatExSystem1.get_color("font_color")
		else:
			color = chatExSystem2.get_color("font_color")
		newChat.set("custom_colors/font_color",color)
	chatBox.add_child(newChat)
	chatLog.append(text)
	yield(get_tree().create_timer(0.01), "timeout")
	var maxValue = chatScroll.get_v_scrollbar().max_value
	chatScroll.scroll_vertical = maxValue
	SoundControl.se_play_message_pop()
	yield(get_tree().create_timer(10.0), "timeout")
	newChat.queue_free()


