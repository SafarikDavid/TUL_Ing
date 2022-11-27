package com.example.boardgametracker;

public class Player {
    private String name;
    private int _id;

    public Player(String name, int id) {
        this.name = name;
        _id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int get_id() {
        return _id;
    }

    public void set_id(int _id) {
        this._id = _id;
    }

    @Override
    public String toString() {
        return "Player{" +
                "name='" + name + '\'' +
                ", _id=" + _id +
                '}';
    }
}
