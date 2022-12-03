extends CanvasLayer
#const Settings = preload("res://LoadSettings.gd")

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_released("life_potion"):
		_on_LifePotionButton_pressed()
	elif Input.is_action_just_released("kungfu_potion"):
		_on_PowerPotionButton_pressed()
	elif Input.is_action_just_released("immune_potion"):
		_on_ImmunePotionButton_pressed()
	elif Input.is_action_just_pressed("time_freeze_potion"):
		_on_TimeFreezePotionButton_pressed()
	elif Input.is_action_just_pressed("power_potion"):
		_on_WavePotionButton_pressed()
		
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 8:
		$KungfuPotion.modulate = Color(1,1,1,1)
		$KungfuPotion/KungfuPotionButton.disabled = false
		$ImmunePotion.modulate = Color(1,1,1,1)
		$ImmunePotion/ImmunePotionButton.disabled = false
		$LifePotion.modulate = Color(1,1,1,1)
		$LifePotion/LifePotionButton.disabled = false
		$TimeFreezePotion.modulate = Color(1,1,1,1)
		$TimeFreezePotion/TimeFreezePotionButton.disabled = false
		$WavePotion.modulate = Color(1,1,1,1)
		$WavePotion/WavePotionButton.disabled = false
		
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 5:
		$KungfuPotion.modulate = Color(1,1,1,1)
		$KungfuPotion/KungfuPotionButton.disabled = false
		$ImmunePotion.modulate = Color(1,1,1,1)
		$ImmunePotion/ImmunePotionButton.disabled = false
		$LifePotion.modulate = Color(1,1,1,1)
		$LifePotion/LifePotionButton.disabled = false
		$TimeFreezePotion.modulate = Color(1,1,1,1)
		$TimeFreezePotion/TimeFreezePotionButton.disabled = false
		
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 4:
		$KungfuPotion.modulate = Color(1,1,1,1)
		$KungfuPotion/KungfuPotionButton.disabled = false
		$LifePotion.modulate = Color(1,1,1,1)
		$LifePotion/LifePotionButton.disabled = false
				
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 3:
		$LifePotion.modulate = Color(1,1,1,1)
		$LifePotion/LifePotionButton.disabled = false
	else:
		$KungfuPotion.modulate = Color8(255, 255, 255, 100)
		$KungfuPotion/KungfuPotionButton.disabled = false
		$ImmunePotion.modulate = Color8(255, 255, 255, 100)
		$ImmunePotion/ImmunePotionButton.disabled = false
		$LifePotion.modulate = Color8(255, 255, 255, 100)
		$LifePotion/LifePotionButton.disabled = false
		$TimeFreezePotion.modulate = Color8(255, 255, 255, 100)
		$TimeFreezePotion/TimeFreezePotionButton.disabled = false
		$WavePotion.modulate = Color8(255, 255, 255, 100)
		$WavePotion/WavePotionButton.disabled = false
	
		


func _on_LifePotionButton_pressed():
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 3:
		$BoughtSound.play()
		get_node("../"  + Settings.sprite).deduct_coin(3)
		get_node('../' + Settings.sprite + '/Life/LifeProgressBar').value += 20


func _on_ImmunePotionButton_pressed():
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 5 and not get_node('../' + Settings.sprite + '').powered:
		$BoughtSound.play()
		get_node("../"  + Settings.sprite).deduct_coin(5)
		get_node('../' + Settings.sprite).get_immune()


func _on_PowerPotionButton_pressed():
	if int(get_node('../CoinsCounter/TotalCoins').text) >= 8 and not get_node('../' + Settings.sprite).immune:
		$BoughtSound.play()
		get_node("../"  + Settings.sprite).deduct_coin(8)
		get_node('../' + Settings.sprite).get_powered()


func _on_WavePotionButton_pressed():
	if not get_node("../"  + Settings.sprite).immune and not get_node("../"  + Settings.sprite).powered:
		$BoughtSound.play()
		get_node("../"  + Settings.sprite).get_wave()


func _on_TimeFreezePotionButton_pressed():
	get_node("../"  + Settings.sprite).time_freeze(5)
	queue_free()
