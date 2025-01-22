package com.example.seen

import android.app.Application
import android.os.StrictMode
import android.os.StrictMode.OnVmViolationListener
import android.os.StrictMode.VmPolicy
import android.os.strictmode.Violation
import android.util.Log
import io.flutter.view.FlutterMain
import java.io.PrintWriter
import java.io.StringWriter
import java.util.concurrent.Executor

class CurrentThreadExecutor : Executor {
    override fun execute(r: Runnable) {
        r.run()
    }
}

class StacktraceLogger : OnVmViolationListener {
    override fun onVmViolation(v: Violation) {
        val sw = StringWriter()
        val pw = PrintWriter(sw)
        v.printStackTrace(pw)
        Log.e("STRICTMODE", sw.toString())
    }
}

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
            val policy = VmPolicy.Builder()
                .detectAll()
                .detectNonSdkApiUsage()
                .penaltyListener(CurrentThreadExecutor(), StacktraceLogger())
                .build()
            StrictMode.setVmPolicy(policy)
        }
        FlutterMain.startInitialization(applicationContext)
    }
}
