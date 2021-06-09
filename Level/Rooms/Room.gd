extends Node2D

# ==== Components ==== #
var _tilemap
var _money_container


# ==== Variables ==== #
export (Vector2) var _PORTAL_POSITION
export (Array, Vector2) var _ENEMY_POSITIONS 
export (Array, Vector2) var _CHEST_POSITIONS 

export (bool) var _has_boss = false


# ==== Bootstrap ==== #

func initialize():
	_tilemap = $MainTileMap
	_money_container = $MoneyContainer

