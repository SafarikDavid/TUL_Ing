package com.example.boardgametracker;

import androidx.annotation.NonNull;

public class PlayerSelect extends Player{
    private boolean isSelected;

    public PlayerSelect(@NonNull Player player) {
        super(player.getName(), player.get_id());
        isSelected = false;
    }

    public PlayerSelect(String name) {
        super(name);
        isSelected = false;
    }

    public PlayerSelect(String name, int id) {
        super(name, id);
        isSelected = false;
    }

    public PlayerSelect(String name, boolean isSelected) {
        super(name);
        this.isSelected = isSelected;
    }

    public PlayerSelect(String name, int id, boolean isSelected) {
        super(name, id);
        this.isSelected = isSelected;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }
}
