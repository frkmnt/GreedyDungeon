extends Node2D

export (Vector2) var _PORTAL_POSITION
export (Array, Vector2) var _ENEMY_POSITIONS 
export (Array, Vector2) var _CHEST_POSITIONS 


# Variables
var _tilemap
var _money_container

# Meta
var _has_boss = false



func initialize():
	_tilemap = $MainTileMap
	_money_container = $MoneyContainer

