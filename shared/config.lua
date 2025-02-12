return {
    UseOxFuel = false, -- true if you use ox_fuel
    UseKeys = true, -- true if you use qbx_vehiclekeys
    Bond = 2500, -- Money to take when getting truck, can be 0 
    Moneytype = 'cash', -- 'bank', 'black_money'
    Reward = 300, -- Reward per bin cleaned 
    changeOutfit = true, -- Option to change outfit 
    requireOutfit = true, -- Option if outfit is required to spawn truck
    Uniform = {
        Shirt = 44,
        Pants = 9,
        Gloves = 65,
        Shoes = 12,
        Hat = 20,
        Undershirt = 15,
    },

    truckModel = "trash2",
    pedCoords = vector3(499.9894, -651.9183, 24.9093),
    pedName = 's_m_y_airworker',
    pedHeading = 270.8186,
    pedanimDict = "oddjobs@assassinate@guard",
    pedanimClip = "unarmed_fold_arms",
    vehicleName = 'trash2',
    vehicleCoords = vector3(510.3752, -654.7561, 24.7512),
    vehicleHeading = 179.6859,

    PropModels = {
        "prop_cs_bin_01_skinned",
        "prop_cs_bin_03"
    },

    GrabAnimDict = "anim@heists@box_carry@",
    GrabAnimClip = "idle",
    DropAnimDict = "anim@heists@narcotics@trash",
    DropAnimClip = "throw_b",

    PropLocations = {
        vector4(475.5041, -670.2628, 26.5331, 3.4894),
        vector4(141.3320, -1027.8635, 29.3513, 163.0735),
        vector4(64.3686, -1000.1199, 29.3574, 176.7247),
        vector4(-262.95, -807.96, 32.04, 65.57),
        vector4(-679.5, -876.76, 24.5, 176.54),
        vector4(-543.7, -1218.14, 18.27, 330.87),
        vector4(-341.74, -1493.09, 30.76, 282.74),
        vector4(-151.41, -1572.83, 34.76, 62.81),
    },

    ReturnLocations = {
        vector3(518.46, -631.24, 24.75),
        vector3(518.78, -623.37, 24.75),
    }
}
