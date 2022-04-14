# K5 Gas Cloud

![enter image description here](https://i.imgur.com/pPuv4EW.png)

This is a **free** and **open** Fivem script that uses ESX Framework. The goal of this script is to create a barrier around a specified area to prevent players from roaming around the island. This script is ideal for servers that have a smaller player base. With this script, players will be more likely to run into eachother. The script provides items that give opportunity to the players to move out in the gas for a short period of time.

## Demo

Watch the demo here: [YouTube](https://www.youtube.com/watch?v=V7GyXrgp3dw)

## Dependencies

- es_extended

The script was tested using **ESX Legacy** and **oxmysql**. I do not guarantee if it works with other versions

# Download & Installation

To use this script, you need to edit the configuration to fit your needs.

**Using Git**

```
cd resources
git clone https://github.com/kac5a/k5_gascloud [scripts]/k5_gascloud
```

### Manually

- Download [https://github.com/kac5a/k5_gascloud](https://github.com/kac5a/k5_gascloud)
- Put it in your resources directory

### Installation

Add this in your `server.cfg`:

```
ensure k5_gascloud
```

# Items

An SQL file is inlcuded in the `/sql` folder. Run this query if you're using a database based inventory system. If you're using something like [ox_inventory](https://github.com/overextended/ox_inventory) you should define the items found in the config file. Make sure you add the correct names. The item images are included in this folder aswell, use it if you'd like, or use your own. You can delete the `/sql` folder after you're finished.
