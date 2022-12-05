package com.example.boardgametracker;

public class GamePlayer {
    private int id_game;
    private int id_player;

    @Override
    public String toString() {
        return "GamePlayer{" +
                "id_game=" + id_game +
                ", id_player=" + id_player +
                '}';
    }

    public int getId_game() {
        return id_game;
    }

    public void setId_game(int id_game) {
        this.id_game = id_game;
    }

    public int getId_player() {
        return id_player;
    }

    public void setId_player(int id_player) {
        this.id_player = id_player;
    }

    public GamePlayer(int id_game, int id_player) {
        this.id_game = id_game;
        this.id_player = id_player;
    }
}
