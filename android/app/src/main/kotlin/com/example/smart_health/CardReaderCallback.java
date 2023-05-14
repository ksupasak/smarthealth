package com.example.smart_health;

import android.graphics.Bitmap;

public interface CardReaderCallback {

    void receiveResult(String text, Bitmap bitmap);

}
