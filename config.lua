Config = {}

Config.Target = "ox" -- Set to either "ox" or "qb" (for ESX, use "ox")
Config.RequireBusinessLicense = true -- Set to true if a business license is required
Config.Inventory = "ox" -- Set to "ox" or "qb" (for ESX, use "ox")
Config.Notify = "esx" -- supports: esx, okok
Config.PayOption = "cash" -- cash or bank

Config.Businesses = {
    {
        EnableBlip = true,
        BusinessName = "Karting Centre", 
        BusinessPrice = 75000,
        BusinessJob = "karting",
        BusinessGrade = 2,
        PedCoords = vector4(-169.3625, -2143.7227, 16.0519, 194.4531),
        PedModel = "MP_M_WareMech_01",
        BlipCoords = vector3(-169.3625, -2143.7227, 17.0519),
        BlipSprite = 748,
        BlipColor = 1,
        BlipName = "Karting Centre",
        SellBackPercentage = 75
    },
    {
        EnableBlip = false,
        BusinessName = "LS Towing Services",
        BusinessPrice = 75000,
        BusinessJob = "towing",
        BusinessGrade = 3,
        PedCoords = vector4(0.0, 0.0, 0.0, 0.0),
        PedModel = "a_f_y_business_02",
        BlipCoords = vector3(0.0, 0.0, 0.0),
        BlipSprite = 475,
        BlipColor = 2,
        BlipName = "Business 2",
        SellBackPercentage = 40
    }
    -- Add more businesses as needed
}