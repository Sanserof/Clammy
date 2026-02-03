# Clammy
FFXI addon for AshitaXI v4 that displays basic clamming information. Bucket size & weight, countdown timer, and contents.

## Commands:
### Options
 `/clammy` *Opens a config menu for general configs*
 `/clammy showvalue [true/false/...]` *Turn display of estimated value on/off*  
 `/clammy showitems [true/false/...]` *Turn display of individual items on/off*  
 `/clammy log [true/false/...]` *Turns on/off results logging - stores file in /addons/Clammy/logs*
 `/clammy tone [true/false/...]` *Turns on/off playing a tone when clamming point is ready to dig*  
 `/clammy logbrokenbucketitems [true/false/...]` *Turns on/off logging if the bucket breaks*
 `/clammy showsessioninfo [true/false/...]` *Turns on/off showing gil/hr, buckets purchased, and total gil earned*
 `/clammy usebucketvalueforweightcolor [true/false/...]` *turns on/off current weight value turning red at certain gil amounts*
 `/clammy setweightvalues [highvalue/midvalue/lowvalue] #####` *Specify a value for when bucket color should turn red*
 `/clammy resetsession` *Resets the current clamming time, buckets purchased, items in bucket, gil/hr, and total gil earned*

### Debug
 `/clammy reset` *Manually clear bucket information*
 `/clammy weight` *Manually adjust bucket weight*
