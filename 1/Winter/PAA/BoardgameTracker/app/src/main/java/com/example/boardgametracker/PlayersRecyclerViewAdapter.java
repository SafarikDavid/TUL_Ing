package com.example.boardgametracker;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class PlayersRecyclerViewAdapter extends RecyclerView.Adapter<PlayersRecyclerViewAdapter.ViewHolder> {
    private ArrayList<Player> players;
    private LayoutInflater mInflater;
    private ItemClickListener mClickListener;

    public PlayersRecyclerViewAdapter(Context context, ArrayList<Player> players) {
        this.mInflater = LayoutInflater.from(context);
        this.players = players;
    }

    public ArrayList<Player> getPlayers() {
        return players;
    }

    public void setPlayers(ArrayList<Player> players) {
        this.players = players;
    }

    public void addPlayer(Player player){
        players.add(player);
    }

    public void deletePlayer(int id){
        for (Player p:
                players) {
            if (p.get_id() == id){
                players.remove(p);
            }
        }
    }

    public Player getPlayerByName(String name){
        for (Player p:
             players) {
            if (p.getName().equalsIgnoreCase(name)){
                return p;
            }
        }
        return null;
    }

    public Player getPlayerById(int id){
        for (Player p:
                players) {
            if (p.get_id() == id){
                return p;
            }
        }
        return null;
    }

    // inflates the row layout from xml when needed
    @NonNull
    @Override
    public PlayersRecyclerViewAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.recyclerview_row, parent, false);
        return new ViewHolder(view);
    }

    // binds the data to the TextView in each row
    @Override
    public void onBindViewHolder(@NonNull PlayersRecyclerViewAdapter.ViewHolder holder, int position) {
        String player = players.get(position).toString();
        holder.myTextView.setText(player);
    }

    @Override
    public int getItemCount() {
        return players.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView myTextView;

        ViewHolder(View itemView) {
            super(itemView);
            myTextView = itemView.findViewById(R.id.player_name_id);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            if (mClickListener != null) mClickListener.onItemClick(view, getAdapterPosition());
        }
    }

    // convenience method for getting data at click position
    String getItem(int id) {
        return players.get(id).toString();
    }

    // allows clicks events to be caught
    void setClickListener(ItemClickListener itemClickListener) {
        this.mClickListener = itemClickListener;
    }

    // parent activity will implement this method to respond to click events
    public interface ItemClickListener {
        void onItemClick(View view, int position);
    }
}
