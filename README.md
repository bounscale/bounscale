# Bounscale
Bounscale is an add-on that provides an environment to auto-scale the Rails/node.js/Play Framework2(Scala) application that is deployed to Heroku.

https://addons.heroku.com/bounscale

You can gain the following advantages by adding Bounscale:

1. You can prevent responses from decreasing.

2. You can reduce costs by adjusting the optimal number of Dynos according to the load on the application.

Bounscale realizes auto-scaling by obtaining the status of the application from RackMiddleware using gem’s bounscale.

## Supported Environments
__Application__

 * Compatibility confirmed.
   * Rails 2.3 or 3.0 or 3.2
   * Ruby 1.9.2 or 1.9.3
 * Supposed to be supported if compatible with the rack, according to the configurations.
 * [EXPERIMENTAL] node.js v0.10.15 / Express 3.3.5
 * [EXPERIMENTAL] Play Framework 2.1.3 / Scala 2.10

__Heroku Stack__

 * Ceder Stack

## Getting Started
### Ruby/Rails
 Add the following to your project’s Gemfile:

```Gemfile
gem 'bounscale'
```

 On Rails2 (not Rails3), add the following to your config/environment.rb:

```config/environment.rb
config.after_initialize do
  require 'bounscale'
end
```

### [EXPERIMENTAL] node.js / Express
 Add the following to you project's package.json
 
```package.json
{
...
  "dependencies": {
...
    "bounscale": "*"
  },
...
}
```

 And add the following to you project's app.js.
 You have to insert a line on the top of "app.use" paragraph.
 
```app.js
...
app.set(.....);
app.set(.....);
app.use(require('bounscale')); // <-- insert here
app.use(.....);
app.use(.....);
...
```

### [EXPERIMENTAL] Play Framework2 / Scala
 Add the following to you project's project/Build.scala
 
```project/Build.scala
...
object ApplicationBuild extends Build {
...
  val appDependencies = Seq(
    "bounscale" % "bounscale_2.10" % "0.0.1" // <--here
  )

  val main = play.Project(appName, appVersion, appDependencies).settings(
    resolvers += "Bounscale Maven Repository on Github" at "http://bounscale.github.io/maven/" // <--here
  )
}
```

 And create a file named "Global.scala" in your app dir like following.
```Global.scala
import play.api.GlobalSettings
import play.api.mvc.WithFilters
import com.bounscale.BounscaleFilter

object Global extends WithFilters(
    new BounscaleFilter) with GlobalSettings
```

## Installation of the Add-on

 Type the following command to add the add-on:

```
 $ heroku addons:add bounscale
```

## Bounscale Default Settings

 Go to Heroku’s Application screen and check that Bounscale has been added to Addons.

 Click the Bounscale add-on after confirming that Bounscale is added to Addons.

 ![sample01](https://s3.amazonaws.com/bounscale/sample01.png)

 The following screen will appear after you click the Bounscale button. Then, enter the following three:

 1. API Key

 Enter your Heroku account’s API key.

 You can obtain an API key by going to
 `Heroku’s Dashboard > Account > API Key`
 and clicking the Show API Key button.

 2. Web URL

 Enter a URL you wish the application to monitor.

 3. Time Zone

 Select the time zone of your location.

Click the Save button after selecting the time zone.

 ![sample02](https://s3.amazonaws.com/bounscale/sample02.png)

If Bounscale’s homepage is displayed, the setting is complete.

No charts are displayed immediately after the setting is complete as there is no data by default. Bounscale will obtain application data and start displaying charts after around 5-10 minutes.

 ![sample03](https://s3.amazonaws.com/bounscale/sample03.png)

## Auto Scale Settings

 The Auto Scale Settings screen is a screen that controls so that auto-scaling is performed appropriately according to the auto scaling-related settings you made.

 ![sample04](https://s3.amazonaws.com/bounscale/sample04.png)

### (a)Auto Scale
  You can turn on/off auto-scaling at Auto Scale. When enabled, Auto Scale obtains chart data and performs auto-scaling when the heavy load conditions are met. When disabled, Auto Scale obtains chart data but does not perform auto-scaling at all.

  It is recommended to set Auto Scale to “Disabled” once when you first use it, and set it to “Enabled” after setting the appropriate threshold based on the chart data gathered.

### (b)Dyno Limit
  You can set the range of the number of Dynos that is modified by auto-scaling at Dyno Limit. The minimum number of Dynos cannot be less than the designated value, however little the load is. The maximum number of Dynos cannot be more than the designated value, however little the load is.

  Set the minimum number of Dynos to a numeric value that secures the minimum performance. Also, set the maximum number of Dynos to a numeric value according to costs. In addition, “Current Dyno” shows the current number of Dynos.

### (c)Response Time
  Bounscale’s scale-out is performed when the status of both of the two indicators has become “high load”.

  The indicator “ResponseTime” is a response time in which an HTTP request was actually issued from Bounscale to the applicable URL.

  This indicator is the most important item to measure the load on the application and you will always use it. You can set the URL monitoring the response time by clicking “Response Time”.

  It is recommended to set a URL that returns the average application response time.

### (d)Optional indicators
 Select the second optional indicator from the drop-down box. Optional indicators are as follows:

 * Busyness[%]
  Busyness [%] is an indicator that measures the duration during which Dynos are processing requests in a certain amount of time and the wait time and shows its ratio between 0% and 100%.

  For instance, the output is 60[%] if a request is processed for 6 seconds and Dyno waits 4 seconds for a request in a period of 10 seconds.

 * CPU[ms]
  CPU [ms] is an indicator that shows the duration of the use of the CPU.

 * Memory[MB]

  Memory [MB] is an indicator that shows the amount of memory in use.

 * Throughput[response/min]

  Throughput [response/min] is an indicator that shows the number of responses returned per minute.

### (e)(f)Charts
  You can select thresholds to scale out at Charts. You can set the ResponseTime threshold, which is a fixed indicator, with the knob on the left. Also, you can set the CPU threshold, which is an optional indicator, with the knob on the right. If both of the thresholds set for the two indicators are exceeded, Bounscale will scale out to reduce the load on the application.

### (g)Interval
 You can set the interval at which data is obtained at Interval. The shorter the interval, the more suddenly the number of Dynos increases/decreases.

### (h)ScaleIn
 Bounscale’s scale-in is performed when the response time alone becomes lower than a certain threshold. You can set the response time to scale in with _ScaleIn_. It is recommended to set this value as low as possible. This is to prevent Bounscale from scaling in when the load on the application is not fully settled.

### (i)Save Button
 Click the Save button after the setting is complete.

## Once Bounscale Is in Operation

Once Bounscale is in actual operation, refer to the Dyno History screen to optimize the auto-scale settings on a regular basis with reference to the following guidelines:

 ![sample04](https://s3.amazonaws.com/bounscale/sample07.png)

* Check if enough response time is maintained.
* If the response time is not enough, check if the number of Dynos has increased in conjunction with the insufficient response time.
  * If the number of Dynos has not increased, adjust the thresholds and optional indicators appropriately.
*  If the response time does not improve despite an increase in the number of Dynos, it cannot be dealt with by Bounscale.
  * Investigate the possibility of something other than the application, such as a DB server, being the bottleneck.
* If auto-scaling is performed where the load is not high, adjust the thresholds and optional indicators appropriately likewise.

## Technical Support
 Our site of github is [here](https://github.com/bounscale/bounscale).
 If you are not certain about something or find a malfunction, etc., please register it at [Issues](https://github.com/bounscale/bounscale/issues) on github.

## Other reference docs

* http://www.resm.jp/relatedservice/bounscale.html (Japanese only)


We hope your application will be free from stress.


DTS Corporation.
