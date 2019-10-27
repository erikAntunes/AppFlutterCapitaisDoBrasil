package com.example.hello_lbs_flutter

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.tasks.OnSuccessListener
import android.util.Log
import android.location.Location


class MainActivity: FlutterActivity() {

  private lateinit var fusedLocationClient: FusedLocationProviderClient
  private val CHANNEL = "flutter.dev/geolocation"
  private var location: Location? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
    fusedLocationClient.lastLocation.addOnSuccessListener { l : Location? ->
            Log.e("entrou", "sucesso na geolocation");
            location = l
        }.addOnFailureListener { exception : Exception? ->
            Log.e("erro", "erro")
        }

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      result.success("${location!!.latitude},${location!!.longitude}")
    }

  }
}
