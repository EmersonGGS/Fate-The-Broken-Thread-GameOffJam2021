extends Node

var soundPlaying = true
var musicPlaying = true
var soundVolume = .75
var musicVolume = .75

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_audio_bus_configurations()


func update_sound (soundStateNow = soundPlaying,soundVolumeNow = soundVolume):
	pass
	
func update_music(musicStateNow = musicPlaying,musicVolumeNow = musicVolume):
	pass

func update_all_music_and_sound():
	update_sound();
	update_music();
	


func _on_MusicVolume_value_changed(value):
	pass # Replace with function body.


func _on_SoundVolume_value_changed(value):
	pass # Replace with function body.

func update_audio_bus_configurations():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffect"),soundPlaying);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffect"),linear2db(soundVolume));
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BackgroundMusic"),musicPlaying);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BackgroundMusic"),linear2db(musicVolume));
	print("Sound: ", soundPlaying, "/", soundVolume, " || Music: ",musicPlaying, "/", musicVolume)


