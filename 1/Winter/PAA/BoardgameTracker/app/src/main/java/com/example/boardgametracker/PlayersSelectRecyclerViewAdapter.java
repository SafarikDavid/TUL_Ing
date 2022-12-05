package com.example.boardgametracker;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class PlayersSelectRecyclerViewAdapter extends RecyclerView.Adapter<PlayersSelectRecyclerViewAdapter.ViewHolder> {
    private ArrayList<PlayerSelect> players;
    private LayoutInflater mInflater;
    private ItemClickListener mClickListener;

    public PlayersSelectRecyclerViewAdapter(Context context, ArrayList<PlayerSelect> players) {
        this.mInflater = LayoutInflater.from(context);
        this.players = players;
    }

    public ArrayList<PlayerSelect> getPlayers() {
        return players;
    }

    public void setPlayers(ArrayList<PlayerSelect> players) {
        this.players = players;
    }

    public void addPlayer(PlayerSelect player){
        players.add(player);
    }

    // inflates the row layout from xml when needed
    @NonNull
    @Override
    public PlayersSelectRecyclerViewAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.recyclerview_players_select_row, parent, false);
        return new ViewHolder(view);
    }

    // binds the data to the TextView in each row
    @Override
    public void onBindViewHolder(@NonNull PlayersSelectRecyclerViewAdapter.ViewHolder holder, int position) {
        PlayerSelect player = players.get(position);
        holder.myTextView.setText(player.toString());
        holder.myCheckBox.setChecked(player.isSelected());
    }

    @Override
    public int getItemCount() {
        return players.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView myTextView;
        private CheckBox myCheckBox;
        private LinearLayout rowItem;

        ViewHolder(View itemView) {
            super(itemView);
            this.myTextView = itemView.findViewById(R.id.player_select_name_id);
            this.myCheckBox = itemView.findViewById(R.id.checkbox_player_select);
            this.rowItem = itemView.findViewById(R.id.player_select_row_item);

            myCheckBox.setOnClickListener(new View.OnClickListener(){

                @Override
                public void onClick(View view) {
                    boolean isChecked = ((CheckBox) myCheckBox).isChecked();

                    if (isChecked) {
                        players.get(getAdapterPosition()).setSelected(true);
                    } else {
                        players.get(getAdapterPosition()).setSelected(false);
                    }
                    notifyDataSetChanged();
                }
            });

            myTextView.setOnClickListener(new View.OnClickListener(){

                @Override
                public void onClick(View view) {

                }
            });
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
