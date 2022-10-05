extends CanvasLayer
#const Settings = preload("res://LoadSettings.gd")

func _ready():
	pass

func _process(delta):
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 8:
		$PowerPotion.modulate = Color(1,1,1,1)
		$PowerPotion/PowerPotionButton.disabled = false
		$ImmunePotion.modulate = Color(1,1,1,1)
		$ImmunePotion/ImmunePotionButton.disabled = false
		$LifePotion.modulate = Color(1,1,1,1)
		$LifePotion/LifePotionButton.disabled = false
		
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 5:
		$ImmunePotion.modulate = Color(1,1,1,1)
		$ImmunePotion/ImmunePotionButton.disabled = false
		$LifePotion.modulate = Color(1,1,1,1)
		$LifePotion/LifePotionButton.disabled = false
		
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 3:
		$LifePotion.modulate = Color(1,1,1,1)
		$LifePotion/LifePotionButton.disabled = false
		


func _on_LifePotionButton_pressed():
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 3:
		$BoughtSound.play()
		get_node('../CoinsCounter/TotalCoins').text = str(int(get_node('../CoinsCounter/TotalCoins').text) - 3)
		get_node('../' + Settings.sprite + '/Life/LifeProgressBar').value += 20


func _on_ImmunePotionButton_pressed():
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 5 and not get_node('../' + Settings.sprite + '').powered:
		$BoughtSound.play()
		get_node('../CoinsCounter/TotalCoins').text = str(int(get_node('../CoinsCounter/TotalCoins').text) - 5)
		get_node('../' + Settings.sprite).get_immune()


func _on_PowerPotionButton_pressed():
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 8 and not get_node('../' + Settings.sprite).immune:
		$BoughtSound.play()
		get_node('../CoinsCounter/TotalCoins').text = str(int(get_node('../CoinsCounter/TotalCoins').text) - 8)
		get_node('../' + Settings.sprite).get_powered()
